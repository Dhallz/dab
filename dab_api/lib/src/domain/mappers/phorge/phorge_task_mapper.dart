import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/mappers/i_activity_mapper.dart';
import 'package:dab_api/src/domain/entities/provider_payloads/phorge/phorge_task_bundle.dart';
import 'package:dab_api/src/domain/entities/provider_payloads/phorge/phorge_transaction_data.dart';
import 'package:uuid/uuid.dart';

import '../../entities/sprint_context.dart';

/// [ARCH: DOMAIN_MAPPER]
/// ROLE: Business Logic Transformer for Phorge Task data.
/// CONTRACT: Implements [IActivityMapper] for [PhorgeTaskBundle].
/// CONSTRAINTS: Pure Logic (No I/O). Must translate technical protocol data into human-readable Activities.
///
/// This mapper contains the business rules for the Phorge platform. It decides
/// which technical transactions (status changes, columns moves) are relevant to
/// the DAB users and how they should be described in the feed.
class PhorgeTaskMapper implements IActivityMapper<PhorgeTaskBundle> {
  final _uuid = const Uuid();

  @override
  String get providerName => 'phorge';

  @override
  /// [ARCH: DOMAIN_ENTRY]
  /// ROLE: High-level transformation entry point.
  /// CONTRACT: Iterates over transactions and filters out irrelevant noise (VCS/Edits).
  List<Activity> mapToActivities(PhorgeTaskBundle bundle, List<User> users) {
    if (bundle.transactions.isEmpty) return [];

    final activities = <Activity>[];

    // Create an O(1) lookup map for authors
    final userMap = {for (final u in users) u.phorgePhid: u};

    for (final tx in bundle.transactions) {
      if (tx.type == 'vcs' || tx.type == 'edit') continue;

      final activity = _mapTransaction(tx, bundle, userMap, users.firstOrNull);
      if (activity != null) {
        activities.add(activity);
      }
    }

    return activities;
  }

  /// [ARCH: DOMAIN_INTERNAL]
  /// ROLE: Interprets a single Phorge Transaction as a DAB Activity.
  /// CONTRACT: Defines the business logic for status-to-sprint-context mapping.
  Activity? _mapTransaction(
    PhorgeTransactionData tx,
    PhorgeTaskBundle bundle,
    Map<String?, User> authorMap,
    User? defaultUser,
  ) {
    String content = 'Updated task';
    SprintContext? sprintContext;

    if (tx.type == 'comment') {
      content = tx.commentText?.trim() ?? 'Commented on task';
    } else if (tx.type == 'status') {
      content = 'Changed status from ${tx.oldValue} to ${tx.newValue}';
      sprintContext = SprintContext(
        tag: bundle.sprintTag,
        columnFrom: tx.oldValue?.toString(),
        columnTo: tx.newValue?.toString(),
      );
    } else if (tx.type == 'columns' || tx.type == 'core:columns') {
      content = 'Moved task on the sprint board';
      sprintContext = SprintContext(
        tag: bundle.sprintTag,
        columnFrom: _extractColumn(tx.oldValue) ?? 'board',
        columnTo: _extractColumn(tx.newValue) ?? 'board',
      );
    } else if (tx.type == 'projects') {
      content = 'Updated project tags';
    } else {
      return null;
    }

    // Resolve author
    final author = authorMap[tx.authorPHID] ?? defaultUser;
    if (author == null) return null;

    return Activity(
      id: _generateUuid('phorge-tx-${tx.id}'),
      userId: author.id,
      authorName: (author.phorgeUsername ?? '').trim().isNotEmpty
          ? author.phorgeUsername!.trim()
          : author.name,
      commentCount: tx.type == 'comment' ? 1 : 0,
      provider: PhorgeTaskProvider(
        taskPhid: bundle.task.phid,
        sprintContext: sprintContext,
        tags: bundle.task.projectPHIDs.join(','),
      ),
      title: '[T${bundle.task.id}] ${bundle.task.name}',
      content: content,
      url: '/T${bundle.task.id}',
      createdAt: tx.dateCreated,
    );
  }

  /// [ARCH: DOMAIN_INTERNAL]
  /// ROLE: Low-level JSON extractor for column PHIDs.
  String? _extractColumn(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is Map) {
        return first['columnPHID']?.toString();
      }
    }
    return value?.toString();
  }

  String _generateUuid(String source) {
    return _uuid.v5(Namespace.url.value, source);
  }
}
