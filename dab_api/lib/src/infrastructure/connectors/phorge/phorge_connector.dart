import 'package:dab_api/src/domain/entities/activity.dart';
import 'package:dab_api/src/domain/entities/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user.dart';
import 'package:uuid/uuid.dart';

import 'dtos/phorge_project_dto.dart';
import 'dtos/phorge_revision_dto.dart';
import 'dtos/phorge_task_dto.dart';
import 'dtos/phorge_transaction_dto.dart';
import 'phorge_client.dart';

class PhorgeConnector {
  final PhorgeClient _client;
  final _uuid = const Uuid();

  PhorgeConnector({PhorgeClient? client}) : _client = client ?? PhorgeClient();

  Future<List<Activity>> fetchActivities({
    required List<User> users,
    required DateTime startDate,
    required DateTime endDate,
    bool authoredOnly = true,
  }) async {
    final validUsers = users.where((u) => u.phorgePhid != null).toList();
    if (validUsers.isEmpty) return [];

    final userPhids = validUsers.map((u) => u.phorgePhid!).toList();
    final sprintTag = _getCurrentSprintTag(startDate);
    final sprintPhid = await _fetchSprintProjectPhid(sprintTag);

    final tasks = await _fetchSprintTasks(
      validUsers,
      userPhids,
      sprintPhid,
      sprintTag,
      startDate,
      endDate,
      authoredOnly,
    );

    final revisions = await _fetchRevisions(
      validUsers,
      userPhids,
      startDate,
      endDate,
    );

    return [...tasks, ...revisions]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  String _getCurrentSprintTag([DateTime? now]) {
    final date = now ?? DateTime.now();
    int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();

    int isoWeekNumber(DateTime d) {
      int doy = d.difference(DateTime(d.year, 1, 1)).inDays + 1;
      int w = ((doy - d.weekday + 10) / 7).floor();
      return w;
    }

    if (woy < 1) {
      woy = isoWeekNumber(DateTime(date.year - 1, 12, 31));
    } else if (woy > 52) {
      int lastDayOfYear = DateTime(date.year, 12, 31).weekday;
      if (lastDayOfYear < DateTime.thursday) {
        woy = 1;
      }
    }

    int year = date.year;
    if (date.month == 1 && woy > 50) year--;
    if (date.month == 12 && woy == 1) year++;

    return 'DS$year-${woy.toString().padLeft(2, '0')}';
  }

  Future<String?> _fetchSprintProjectPhid(String tag) async {
    final result = await _client.call('project.search', {
      'constraints': {'query': tag},
    });
    final data = result['data'] as List<dynamic>?;
    if (data != null && data.isNotEmpty) {
      final prj = PhorgeProjectDto.fromConduit(
        data.first as Map<String, dynamic>,
      );
      return prj.phid;
    }
    return null;
  }

  /// Fetches all active Phorge projects/tags for UI filtering within the current Sprint
  Future<List<PhorgeProjectDto>> fetchAllProjects(String userPhid) async {
    final sprintTag = _getCurrentSprintTag();
    final sprintPhid = await _fetchSprintProjectPhid(sprintTag);

    // 1. Fetch all open tasks in the current sprint assigned to the user
    final tasksData = await _client.call('maniphest.search', {
      'constraints': {
        'assigned': [userPhid],
        if (sprintPhid != null) 'projects': [sprintPhid],
        'statuses': ['open'],
      },
    });

    final rawData = tasksData['data'] as List<dynamic>?;
    if (rawData == null || rawData.isEmpty) return [];

    final tasks = rawData
        .map((e) => PhorgeTaskDto.fromConduit(e as Map<String, dynamic>))
        .toList();

    // 2. Extract unique Project PHIDs attached to these sprint tasks
    final tagPhids = <String>{};
    for (final task in tasks) {
      tagPhids.addAll(task.projectPHIDs);
    }
    tagPhids.remove(
      sprintPhid,
    ); // Exclude the Sprint tag itself from UI filters

    if (tagPhids.isEmpty) return [];

    // 3. Fetch the metadata for these specific tag PHIDs
    final result = await _client.call('project.search', {
      'constraints': {'phids': tagPhids.toList()},
      'limit': 100,
    });

    final tagsData = result['data'] as List<dynamic>?;
    if (tagsData == null) return [];

    return tagsData
        .map((e) => PhorgeProjectDto.fromConduit(e as Map<String, dynamic>))
        .toList();
  }

  /// Searches Phorge for a user account using the robust full-text 'query' constraint.
  /// It first searches by the email prefix, then falls back to the provided real name.
  /// Returns the PHID if found, or null if the user does not exist in Phorge.
  Future<String?> lookupUserPhid(String name, String email) async {
    final prefix = email.split('@').first;

    // Attempt 1: Prefix search (e.g. "david" or "dlimier")
    var result = await _client.call('user.search', {
      'constraints': {'query': prefix},
    });

    var data = result['data'] as List<dynamic>?;
    if (data != null && data.isNotEmpty) {
      return (data.first as Map<String, dynamic>)['phid']?.toString();
    }

    // Attempt 2: Full name fallback (e.g. "David Limier")
    result = await _client.call('user.search', {
      'constraints': {'query': name},
    });

    data = result['data'] as List<dynamic>?;
    if (data != null && data.isNotEmpty) {
      return (data.first as Map<String, dynamic>)['phid']?.toString();
    }

    return null;
  }

  String _generateUuid(String source) {
    return _uuid.v5(Namespace.url.value, source);
  }

  Future<List<Activity>> _fetchSprintTasks(
    List<User> validUsers,
    List<String> userPhids,
    String? sprintPhid,
    String sprintTag,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    List<Activity> activities = [];

    if (authoredOnly) {
      // Option 1: Find all actions authored by these users directly.
      List<PhorgeTransactionDto> targetTransactions = [];
      String? afterCursor;

      // Paginating backwards until we hit a transaction older than the start date
      while (true) {
        final txResult = await _client.call('transaction.search', {
          'objectType': 'TASK',
          'constraints': {'authorPHIDs': userPhids},
          'limit': 100,
          ?'after': afterCursor,
        });

        final rawTxData = txResult['data'] as List<dynamic>?;
        if (rawTxData == null || rawTxData.isEmpty) break;

        final batch = rawTxData
            .map(
              (e) =>
                  PhorgeTransactionDto.fromConduit(e as Map<String, dynamic>),
            )
            .toList();
        bool reachedEnd = false;

        for (final tx in batch) {
          if (tx.dateCreated.isBefore(start)) {
            reachedEnd = true;
            break; // Since they are sorted descending, if this one is older than start, all subsequent ones are too.
          }
          if (tx.dateCreated.isBefore(end)) {
            targetTransactions.add(tx);
          }
        }

        if (reachedEnd) break;

        final cursor = txResult['cursor'] as Map<String, dynamic>?;
        if (cursor != null && cursor['after'] != null) {
          afterCursor = cursor['after'].toString();
        } else {
          break;
        }
      }

      if (targetTransactions.isEmpty) return [];

      // Hydrate task details for the authored transactions
      final taskPhids = targetTransactions
          .map((tx) => tx.objectPHID)
          .toSet()
          .toList();
      final taskResult = await _client.call('maniphest.search', {
        'constraints': {'phids': taskPhids},
      });

      final rawTaskData = taskResult['data'] as List<dynamic>?;
      if (rawTaskData == null) return [];

      final tasksMap = {
        for (var t in rawTaskData)
          t['phid'].toString(): PhorgeTaskDto.fromConduit(
            t as Map<String, dynamic>,
          ),
      };

      for (final tx in targetTransactions) {
        final task = tasksMap[tx.objectPHID];
        if (task == null) continue;

        _processTransaction(
          tx,
          task,
          sprintTag,
          userPhids,
          validUsers,
          activities,
          authoredOnly: true,
        );
      }
    } else {
      // Option 2: Inbox mode. Find tasks assigned to the users modified in this timeframe.
      Map<String, dynamic> constraints = {
        'modifiedStart': start.millisecondsSinceEpoch ~/ 1000,
        'modifiedEnd': end.millisecondsSinceEpoch ~/ 1000,
        'statuses': ['open'],
        'assigned': userPhids,
      };

      if (sprintPhid != null) {
        constraints['projects'] = [sprintPhid];
      }

      final result = await _client.call('maniphest.search', {
        'constraints': constraints,
      });

      final rawData = result['data'] as List<dynamic>?;
      if (rawData == null) return [];

      final tasks = rawData
          .map((e) => PhorgeTaskDto.fromConduit(e as Map<String, dynamic>))
          .toList();

      for (final task in tasks) {
        final txResult = await _client.call('transaction.search', {
          'objectIdentifier': task.phid,
        });

        final rawTxData = txResult['data'] as List<dynamic>?;
        if (rawTxData == null) continue;

        final transactions = rawTxData
            .map(
              (e) =>
                  PhorgeTransactionDto.fromConduit(e as Map<String, dynamic>),
            )
            .toList();

        for (final tx in transactions) {
          if (tx.dateCreated.isBefore(start) || tx.dateCreated.isAfter(end)) {
            continue;
          }

          // In Inbox mode, we care if the user originated it, OR if it happened on a task they own
          if (!userPhids.contains(tx.authorPHID) &&
              !userPhids.contains(task.ownerPHID)) {
            continue;
          }

          _processTransaction(
            tx,
            task,
            sprintTag,
            userPhids,
            validUsers,
            activities,
            authoredOnly: false,
          );
        }
      }
    }

    return activities;
  }

  void _processTransaction(
    PhorgeTransactionDto tx,
    PhorgeTaskDto task,
    String sprintTag,
    List<String> userPhids,
    List<User> validUsers,
    List<Activity> activities, {
    required bool authoredOnly,
  }) {
    String content = 'Updated task';
    SprintContext? sprintContext;

    if (tx.type == 'vcs' || tx.type == 'edit') return; // Skip noise

    if (tx.type == 'comment') {
      content = tx.commentText?.trim() ?? 'Commented on task';
    } else if (tx.type == 'status') {
      content = 'Changed status from ${tx.oldValue} to ${tx.newValue}';
      sprintContext = SprintContext(
        tag: sprintTag,
        columnFrom: tx.oldValue?.toString(),
        columnTo: tx.newValue?.toString(),
      );
    } else if (tx.type == 'columns') {
      content = 'Moved task on the sprint board';
      sprintContext = SprintContext(
        tag: sprintTag,
        columnFrom: 'board',
        columnTo: 'board',
      );
    } else if (tx.type == 'projects') {
      content = 'Updated project tags';
    } else {
      return;
    }

    // Resolve which user triggered this Activity
    final authorUuid = validUsers
        .firstWhere(
          (u) => u.phorgePhid == tx.authorPHID,
          orElse: () => validUsers
              .first, // Fallback to the first requested user if it was an inbox event initiated by a random 3rd party
        )
        .id;

    activities.add(
      Activity(
        id: _generateUuid('phorge-tx-${tx.id}'),
        userId: authorUuid,
        provider: PhorgeTaskProvider(
          taskPhid: task.phid,
          sprintContext: sprintContext,
          tags: task.projectPHIDs.join(','),
        ),
        title: '[T${task.id}] ${task.name}',
        content: content,
        url: task.uri,
        createdAt: tx.dateCreated,
      ),
    );
  }

  Future<List<Activity>> _fetchRevisions(
    List<User> validUsers,
    List<String> userPhids,
    DateTime start,
    DateTime end,
  ) async {
    final result = await _client.call('differential.revision.search', {
      'constraints': {
        'authorPHIDs': userPhids,
        'modifiedStart': start.millisecondsSinceEpoch ~/ 1000,
        'modifiedEnd': end.millisecondsSinceEpoch ~/ 1000,
      },
    });

    final rawData = result['data'] as List<dynamic>?;
    if (rawData == null) return [];

    final revisions = rawData
        .map((e) => PhorgeRevisionDto.fromConduit(e as Map<String, dynamic>))
        .toList();

    return revisions.map((rev) {
      final authorUuid = validUsers
          .firstWhere(
            (u) => u.phorgePhid == rev.authorPHID,
            orElse: () => validUsers.first,
          )
          .id;

      return Activity(
        id: _generateUuid('phorge-rev-${rev.id}'),
        userId: authorUuid,
        provider: PhorgeRevisionProvider(revisionId: rev.phid),
        title: 'D${rev.id}: ${rev.title}',
        content: 'Status: ${rev.statusName}',
        url: rev.uri,
        createdAt: rev.dateModified,
      );
    }).toList();
  }

  String userPHIDToName(String phid) => 'Me';
}
