import 'package:dab_api/src/domain/entities/activity.dart';
import 'package:dab_api/src/domain/entities/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user.dart';
import 'package:uuid/uuid.dart';

import 'phorge_client.dart';

class PhorgeConnector {
  final PhorgeClient _client;
  final _uuid = const Uuid();

  PhorgeConnector({PhorgeClient? client}) : _client = client ?? PhorgeClient();

  /// Fetches Phorge activities for a specific user on a specific date.
  /// If [date] is null, it defaults to today.
  Future<List<Activity>> fetchUserActivities({
    required User user,
    DateTime? date,
  }) async {
    final targetDate = date ?? DateTime.now();
    final startOfDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    if (user.phorgePhid == null) return [];

    final tasks = await _fetchTasks(
      user.id,
      user.phorgePhid!,
      startOfDay,
      endOfDay,
    );
    final revisions = await _fetchRevisions(
      user.id,
      user.phorgePhid!,
      startOfDay,
      endOfDay,
    );

    return [...tasks, ...revisions]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  String _generateUuid(String source) {
    // Use v5 UUID for deterministic mapping of external IDs
    return _uuid.v5(Namespace.url.value, source);
  }

  Future<List<Activity>> _fetchTasks(
    String userId,
    String phid,
    DateTime start,
    DateTime end,
  ) async {
    final result = await _client.call('maniphest.search', {
      'constraints': {
        'ownerPHIDs': [phid],
        'modifiedStart': start.millisecondsSinceEpoch ~/ 1000,
        'modifiedEnd': end.millisecondsSinceEpoch ~/ 1000,
      },
    });

    final data = result['data'] as List<dynamic>;
    return data.map((task) {
      final fields = task['fields'] as Map<String, dynamic>;
      final status = fields['status'] as Map<String, dynamic>;
      final priority = fields['priority'] as Map<String, dynamic>;
      final externalId = 'phorge-task-${task['id']}';

      return Activity(
        id: _generateUuid(externalId),
        userId: userId,
        provider: PhorgeTaskProvider(taskPhid: task['phid'] as String?),
        title: '[T${task['id']}] ${fields['name']}',
        content: 'Status: ${status['name']} | Priority: ${priority['name']}',
        url: fields['uri'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          fields['dateModified'] * 1000,
        ),
      );
    }).toList();
  }

  Future<List<Activity>> _fetchRevisions(
    String userId,
    String phid,
    DateTime start,
    DateTime end,
  ) async {
    final result = await _client.call('differential.revision.search', {
      'constraints': {
        'authorPHIDs': [phid],
        'modifiedStart': start.millisecondsSinceEpoch ~/ 1000,
        'modifiedEnd': end.millisecondsSinceEpoch ~/ 1000,
      },
    });

    final data = result['data'] as List<dynamic>;
    return data.map((rev) {
      final fields = rev['fields'] as Map<String, dynamic>;
      final status = fields['status'] as Map<String, dynamic>;
      final externalId = 'phorge-rev-${rev['id']}';

      return Activity(
        id: _generateUuid(externalId),
        userId: userId,
        provider: PhorgeRevisionProvider(revisionId: rev['phid'] as String?),
        title: 'D${rev['id']}: ${fields['title']}',
        content: 'Status: ${status['name']}',
        url: fields['uri'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          fields['dateModified'] * 1000,
        ),
      );
    }).toList();
  }

  String userPHIDToName(String phid) => 'Me';
}
