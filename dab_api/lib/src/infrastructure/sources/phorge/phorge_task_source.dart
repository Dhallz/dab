import 'package:dab_api/src/domain/core/extensions/datetime_extensions.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_transaction/phorge_transaction_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: low-level I/O for Phorge (Phabricator) Tasks and Transactions.
/// CONTRACT: Implements [IActivitySource] for [PhorgeTaskBundleDto].
/// CONSTRAINTS: Must be READ-ONLY. Logic is restricted to API coordination and DTO mapping.
///
/// This source handles the complex multi-step fetching logic required by Phorge:
/// 1. Transaction discovery (either by author or by project).
/// 2. Task hydration (fetching full task details for discovered transactions).
/// 3. Bundling (pairing transactions with their parent tasks).
class PhorgeTaskSource implements IActivitySource<PhorgeTaskBundleDto> {
  final ConduitProtocol _client;

  PhorgeTaskSource(this._client);

  @override
  /// [ARCH: INFRASTRUCTURE_ENTRY]
  /// ROLE: High-level entry point for fetching Phorge Task data.
  /// CONTRACT: Decides between Authored (Personal) or Global (Sprint) fetching strategies.
  Future<List<PhorgeTaskBundleDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final sprintTag = start.phorgeSprintTag;

    if (authoredOnly) {
      return _fetchAuthoredActivities(users, start, end, sprintTag);
    } else {
      return _fetchGlobalSprintActivities(start, end, sprintTag);
    }
  }

  /// [ARCH: INFRASTRUCTURE_INTERNAL]
  /// ROLE: Fetches activities explicitly authored by the provided [users].
  /// CONTRACT: Performs a single `transaction.search` sweep by `authorPHIDs`.
  Future<List<PhorgeTaskBundleDto>> _fetchAuthoredActivities(
    List<User> users,
    DateTime start,
    DateTime end,
    String sprintTag,
  ) async {
    final userPhids = users
        .map((u) => u.phorgePhid?.trim())
        .whereType<String>()
        .where((phid) => phid.isNotEmpty)
        .toSet()
        .toList();
    if (userPhids.isEmpty) {
      return [];
    }

    final txData = await _fetchPagedTransactions(
      constraints: {'authorPHIDs': userPhids},
      start: start,
      stopWhenBeforeStart: true,
      pageLimit: 150,
    );

    return _processTransactionsIntoBundles(
      {'data': txData},
      start,
      end,
      sprintTag,
    );
  }

  /// [ARCH: INFRASTRUCTURE_INTERNAL]
  /// ROLE: Discovers and fetches all activities within a specific Sprint project.
  /// CONTRACT: Performs Task Discovery via `maniphest.search` projects, then fetches transactions.
  Future<List<PhorgeTaskBundleDto>> _fetchGlobalSprintActivities(
    DateTime start,
    DateTime end,
    String sprintTag,
  ) async {
    // 1. Fetch Sprint Project PHID
    final projectResult = await _client.call('project.search', {
      'constraints': {'query': sprintTag},
    });
    final projectData = projectResult['data'] as List<dynamic>?;
    if (projectData == null || projectData.isEmpty) return [];
    final sprintPhid = projectData.first['phid'].toString();

    // 2. Fetch all tasks in this sprint
    final tasksResult = await _client.call('maniphest.search', {
      'constraints': {
        'projects': [sprintPhid],
      },
      'limit': 100,
    });
    final taskData = tasksResult['data'] as List<dynamic>?;
    if (taskData == null || taskData.isEmpty) return [];
    final taskPhids = taskData.map((t) => t['phid'].toString()).toList();

    // 3. Fetch all transactions for these tasks
    final txData = await _fetchPagedTransactions(
      constraints: {'objectPHIDs': taskPhids},
      start: start,
      stopWhenBeforeStart: true,
      pageLimit: 200,
    );

    return _processTransactionsIntoBundles(
      {'data': txData},
      start,
      end,
      sprintTag,
    );
  }

  Future<List<dynamic>> _fetchPagedTransactions({
    required Map<String, dynamic> constraints,
    required DateTime start,
    required bool stopWhenBeforeStart,
    required int pageLimit,
  }) async {
    final allRows = <dynamic>[];
    String? afterCursor;

    for (var page = 0; page < 50; page++) {
      final params = <String, dynamic>{
        'objectType': 'TASK',
        'constraints': constraints,
        'limit': pageLimit,
      };
      if (afterCursor != null && afterCursor.isNotEmpty) {
        params['after'] = afterCursor;
      }

      final txResult = await _client.call('transaction.search', params);
      final pageRows = txResult['data'] as List<dynamic>? ?? const [];
      if (pageRows.isEmpty) break;

      allRows.addAll(pageRows);

      if (stopWhenBeforeStart) {
        final oldestInPage = _oldestDateCreated(pageRows);
        if (oldestInPage != null && oldestInPage.isBefore(start)) {
          break;
        }
      }

      final cursorMap = txResult['cursor'] as Map<String, dynamic>?;
      final nextAfter = cursorMap?['after']?.toString();
      if (nextAfter == null || nextAfter.isEmpty || nextAfter == afterCursor) {
        break;
      }
      afterCursor = nextAfter;
    }

    return allRows;
  }

  DateTime? _oldestDateCreated(List<dynamic> rows) {
    DateTime? oldest;
    for (final row in rows) {
      final map = row as Map<String, dynamic>;
      final date = _extractDateCreated(map);
      if (date == null) continue;
      if (oldest == null || date.isBefore(oldest)) {
        oldest = date;
      }
    }
    return oldest;
  }

  DateTime? _extractDateCreated(Map<String, dynamic> json) {
    final value = int.tryParse(json['dateCreated']?.toString() ?? '');
    if (value == null || value <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
  }

  /// [ARCH: INFRASTRUCTURE_INTERNAL]
  /// ROLE: Orchestrates the transformation of raw Transactions into hydrated Bundles.
  /// CONTRACT: Filters transactions by date, hydrates parent Tasks, and groups them.
  Future<List<PhorgeTaskBundleDto>> _processTransactionsIntoBundles(
    Map<String, dynamic> txResult,
    DateTime start,
    DateTime end,
    String sprintTag,
  ) async {
    final rawTxData = txResult['data'] as List<dynamic>?;
    if (rawTxData == null || rawTxData.isEmpty) return [];

    final allTransactions = rawTxData
        .map((e) => _mapToTransactionData(e as Map<String, dynamic>))
        .where(
          (tx) =>
              !tx.dateCreated.isBefore(start) && !tx.dateCreated.isAfter(end),
        )
        .toList();

    if (allTransactions.isEmpty) return [];
    final taskPhids = allTransactions
        .map((tx) => tx.objectPHID)
        .toSet()
        .toList();
    final taskResult = await _client.call('maniphest.search', {
      'constraints': {'phids': taskPhids},
      'attachments': {'projects': true},
    });

    final rawTaskData = taskResult['data'] as List<dynamic>?;
    if (rawTaskData == null) return [];

    final tasksMap = {
      for (var t in rawTaskData)
        t['phid'].toString(): PhorgeTaskDtoMapper.fromMap(
          t as Map<String, dynamic>,
        ),
    };

    // 3. Group transactions by task and create bundles
    final bundlesMap = <String, List<PhorgeTransactionDto>>{};
    for (final tx in allTransactions) {
      bundlesMap.putIfAbsent(tx.objectPHID, () => []).add(tx);
    }

    return bundlesMap.entries.where((e) => tasksMap.containsKey(e.key)).map((
      entry,
    ) {
      return PhorgeTaskBundleDto(
        task: tasksMap[entry.key]!,
        transactions: entry.value,
        sprintTag: sprintTag,
      );
    }).toList();
  }

  PhorgeTransactionDto _mapToTransactionData(Map<String, dynamic> json) {
    return PhorgeTransactionDto(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phid: json['phid']?.toString() ?? '',
      objectPHID: json['objectPHID']?.toString() ?? '',
      authorPHID: json['authorPHID']?.toString() ?? 'system',
      type: json['type']?.toString() ?? 'unknown',
      oldValue: json['oldValue'],
      newValue: json['newValue'],
      commentText: _extractComment(json),
      dateCreated: DateTime.fromMillisecondsSinceEpoch(
        (int.tryParse(json['dateCreated']?.toString() ?? '0') ?? 0) * 1000,
        isUtc: true,
      ),
    );
  }

  String? _extractComment(Map<String, dynamic> json) {
    if (json['type'] != 'comment') return null;
    final comments = json['comments'] as List<dynamic>?;
    if (comments == null || comments.isEmpty) return null;
    final firstComment = comments.first as Map<String, dynamic>?;
    if (firstComment == null) return null;
    final content = firstComment['content'] as Map<String, dynamic>?;
    if (content == null) return null;
    return content['raw']?.toString();
  }
}
