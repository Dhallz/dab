import 'package:dab_api/src/domain/dtos/phorge/phorge_task_data.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_transaction_data.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/sprint_context.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:uuid/uuid.dart';

final _phorgeTaskActivityUuid = const Uuid();

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Aggregated DTO for Phorge Task processing.
/// CONTRACT: Provides a complete snapshot of a Task and its events (Transactions).
///
/// Mapped to [Activity] via [OnPhorgeTaskBundle.toActivities].
class PhorgeTaskBundle {
  /// The core task metadata (PHID, name, status).
  final PhorgeTaskData task;

  /// The list of events/moves/comments associated with this task.
  final List<PhorgeTransactionData> transactions;

  /// the active sprint tag context for this fetching window.
  final String sprintTag;

  PhorgeTaskBundle({
    required this.task,
    required this.transactions,
    required this.sprintTag,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Interprets Phorge transactions as [`Activity`] feed rows.
extension OnPhorgeTaskBundle on PhorgeTaskBundle {
  /// Iterates transactions and skips irrelevant noise (VCS/Edits).
  List<Activity> toActivities(List<User> users) {
    if (transactions.isEmpty) return [];

    final activities = <Activity>[];

    final userMap = {for (final u in users) u.phorgePhid: u};
    User? defaultUser;
    if (users.isNotEmpty) {
      defaultUser = users.first;
    }

    for (final tx in transactions) {
      if (tx.type == 'vcs' || tx.type == 'edit') continue;

      final activity = _mapPhorgeTaskTransaction(
        tx,
        this,
        userMap,
        defaultUser,
      );
      if (activity != null) {
        activities.add(activity);
      }
    }

    return activities;
  }
}

Activity? _mapPhorgeTaskTransaction(
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
      columnFrom: _phorgeExtractColumn(tx.oldValue) ?? 'board',
      columnTo: _phorgeExtractColumn(tx.newValue) ?? 'board',
    );
  } else if (tx.type == 'projects') {
    content = 'Updated project tags';
  } else {
    return null;
  }

  final author = authorMap[tx.authorPHID] ?? defaultUser;
  if (author == null) return null;

  return Activity(
    id: _phorgeGenerateActivityUuid('phorge-tx-${tx.id}'),
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

String? _phorgeExtractColumn(dynamic value) {
  if (value is List && value.isNotEmpty) {
    final first = value.first;
    if (first is Map) {
      return first['columnPHID']?.toString();
    }
  }
  return value?.toString();
}

String _phorgeGenerateActivityUuid(String source) {
  return _phorgeTaskActivityUuid.v5(Namespace.url.value, source);
}
