import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/domain/services/phorge_sprint_service.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_client.dart';
import 'package:dab_api/src/infrastructure/dtos/phorge/phorge_task_bundle.dart';
import 'package:dab_api/src/infrastructure/dtos/phorge/phorge_task_data.dart';
import 'package:dab_api/src/infrastructure/dtos/phorge/phorge_transaction_data.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: low-level I/O for Phorge (Phabricator) Tasks and Transactions.
/// CONTRACT: Implements [IActivitySource] for [PhorgeTaskBundle].
/// CONSTRAINTS: Must be READ-ONLY. Logic is restricted to API coordination and DTO mapping.
///
/// This source handles the complex multi-step fetching logic required by Phorge:
/// 1. Transaction discovery (either by author or by project).
/// 2. Task hydration (fetching full task details for discovered transactions).
/// 3. Bundling (pairing transactions with their parent tasks).
class PhorgeTaskSource implements IActivitySource<PhorgeTaskBundle> {
  final PhorgeClient _client;
  final PhorgeSprintService _sprintService;

  PhorgeTaskSource(this._client, this._sprintService);

  @override
  /// [ARCH: INFRASTRUCTURE_ENTRY]
  /// ROLE: High-level entry point for fetching Phorge Task data.
  /// CONTRACT: Decides between Authored (Personal) or Global (Sprint) fetching strategies.
  Future<List<PhorgeTaskBundle>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final sprintTag = _sprintService.getCurrentSprintTag(start);

    if (authoredOnly) {
      return _fetchAuthoredActivities(users, start, end, sprintTag);
    } else {
      return _fetchGlobalSprintActivities(start, end, sprintTag);
    }
  }

  /// [ARCH: INFRASTRUCTURE_INTERNAL]
  /// ROLE: Fetches activities explicitly authored by the provided [users].
  /// CONTRACT: Performs a single `transaction.search` sweep by `authorPHIDs`.
  Future<List<PhorgeTaskBundle>> _fetchAuthoredActivities(
    List<User> users,
    DateTime start,
    DateTime end,
    String sprintTag,
  ) async {
    final userPhids = users.map((u) => u.phorgePhid!).toList();

    // 1. PERFORMANCE: Single Transaction Sweep for Authored Activities
    final txResult = await _client.call('transaction.search', {
      'objectType': 'TASK',
      'constraints': {'authorPHIDs': userPhids},
      'limit': 150,
    });

    return _processTransactionsIntoBundles(txResult, start, end, sprintTag);
  }

  /// [ARCH: INFRASTRUCTURE_INTERNAL]
  /// ROLE: Discovers and fetches all activities within a specific Sprint project.
  /// CONTRACT: Performs Task Discovery via `maniphest.search` projects, then fetches transactions.
  Future<List<PhorgeTaskBundle>> _fetchGlobalSprintActivities(
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
      'constraints': {'projects': [sprintPhid]},
      'limit': 100,
    });
    final taskData = tasksResult['data'] as List<dynamic>?;
    if (taskData == null || taskData.isEmpty) return [];
    final taskPhids = taskData.map((t) => t['phid'].toString()).toList();

    // 3. Fetch all transactions for these tasks
    final txResult = await _client.call('transaction.search', {
      'objectType': 'TASK',
      'constraints': {'objectPHIDs': taskPhids},
      'limit': 200,
    });

    return _processTransactionsIntoBundles(txResult, start, end, sprintTag);
  }

  /// [ARCH: INFRASTRUCTURE_INTERNAL]
  /// ROLE: Orchestrates the transformation of raw Transactions into hydrated Bundles.
  /// CONTRACT: Filters transactions by date, hydrates parent Tasks, and groups them.
  Future<List<PhorgeTaskBundle>> _processTransactionsIntoBundles(
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
          (tx) => !tx.dateCreated.isBefore(start) && !tx.dateCreated.isAfter(end),
        )
        .toList();

    if (allTransactions.isEmpty) return [];

    final taskPhids = allTransactions.map((tx) => tx.objectPHID).toSet().toList();
    final taskResult = await _client.call('maniphest.search', {
      'constraints': {'phids': taskPhids},
      'attachments': {'projects': true},
    });

    final rawTaskData = taskResult['data'] as List<dynamic>?;
    if (rawTaskData == null) return [];

    final tasksMap = {
      for (var t in rawTaskData)
        t['phid'].toString(): _mapToTaskData(t as Map<String, dynamic>),
    };

    // 3. Group transactions by task and create bundles
    final bundlesMap = <String, List<PhorgeTransactionData>>{};
    for (final tx in allTransactions) {
      bundlesMap.putIfAbsent(tx.objectPHID, () => []).add(tx);
    }

    return bundlesMap.entries.where((e) => tasksMap.containsKey(e.key)).map((entry) {
      return PhorgeTaskBundle(
        task: tasksMap[entry.key]!,
        transactions: entry.value,
        sprintTag: sprintTag,
      );
    }).toList();
  }

  PhorgeTaskData _mapToTaskData(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};
    final attachments = json['attachments'] as Map<String, dynamic>? ?? {};
    final projectsAttachment = attachments['projects'] as Map<String, dynamic>? ?? {};
    final projectDict = projectsAttachment['projectPHIDs'] as List<dynamic>? ?? [];

    return PhorgeTaskData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phid: json['phid']?.toString() ?? '',
      name: fields['name'] as String? ?? 'Unknown',
      uri: fields['uri'] as String? ?? '',
      ownerPHID: fields['ownerPHID'] as String? ?? 'system',
      projectPHIDs: projectDict.map((e) => e.toString()).toList(),
      dateModified: fields['dateModified'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (int.tryParse(fields['dateModified'].toString()) ?? 0) * 1000,
              isUtc: true)
          : null,
    );
  }

  PhorgeTransactionData _mapToTransactionData(Map<String, dynamic> json) {
    return PhorgeTransactionData(
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
