import 'package:dab_api/src/domain/core/extensions/string_extensions.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_transaction/phorge_transaction_dto.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/sprint_context.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_bundle_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Aggregated DTO for Phorge task processing.
/// CONTRACT: Snapshot of one task and its `transaction.search` rows; decode with [PhorgeTaskBundleDtoMapper.fromMap] when serializing.
///
/// Mapped to [Activity] via [OnPhorgeTaskBundleDto.toActivities].
@MappableClass()
class PhorgeTaskBundleDto with PhorgeTaskBundleDtoMappable {
  /// Core task metadata (`maniphest.search` row).
  final PhorgeTaskDto task;

  /// Events (comments, status, columns, …) for this task.
  final List<PhorgeTransactionDto> transactions;

  /// Active sprint tag for the fetch window.
  final String sprintTag;

  const PhorgeTaskBundleDto({
    required this.task,
    required this.transactions,
    required this.sprintTag,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Interprets Phorge transactions as [`Activity`] feed rows.
extension OnPhorgeTaskBundleDto on PhorgeTaskBundleDto {
  /// Maps one [`PhorgeTransactionDto`] onto a unified-feed [`Activity`], or null if the event kind is not surfaced.
  Activity? activityFromTransaction(
    PhorgeTransactionDto tx,
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
        tag: sprintTag,
        columnFrom: tx.oldValue?.toString(),
        columnTo: tx.newValue?.toString(),
      );
    } else if (tx.type == 'columns' || tx.type == 'core:columns') {
      content = 'Moved task on the sprint board';
      sprintContext = SprintContext(
        tag: sprintTag,
        columnFrom: boardColumnPhidFromWire(tx.oldValue) ?? 'board',
        columnTo: boardColumnPhidFromWire(tx.newValue) ?? 'board',
      );
    } else if (tx.type == 'projects') {
      content = 'Updated project tags';
    } else {
      return null;
    }

    final author = authorMap[tx.authorPHID] ?? defaultUser;
    if (author == null) return null;

    return Activity(
      id: 'phorge-tx-${tx.id}'.v5Uuid,
      userId: author.id,
      authorName: (author.phorgeUsername ?? '').trim().isNotEmpty
          ? author.phorgeUsername!.trim()
          : author.name,
      commentCount: tx.type == 'comment' ? 1 : 0,
      provider: PhorgeTaskProvider(
        taskPhid: task.conduitPhid,
        sprintContext: sprintContext,
        tags: task.projectPHIDs.join(','),
      ),
      title: '[T${task.conduitTaskId}] ${task.name}',
      content: content,
      url: '/T${task.conduitTaskId}',
      createdAt: tx.dateCreated,
    );
  }

  /// Normalizes board column payloads on `transaction.search` (`columns` / `core:columns` events).
  String? boardColumnPhidFromWire(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is Map) {
        return first['columnPHID']?.toString();
      }
    }
    return value?.toString();
  }

  /// Iterates transactions and skips irrelevant noise (VCS/Edits).
  List<Activity> toActivities(
    List<User> users, {
    Iterable<String>? forUserIds,
    Iterable<String>? followerUserIds,
    String? senderUserId,
    bool inbound = false,
  }) {
    if (transactions.isEmpty) return [];

    final activities = <Activity>[];
    final userMap = {for (final u in users) u.phorgePhid: u};
    User? defaultUser;
    if (users.isNotEmpty) {
      defaultUser = users.first;
    }

    for (final tx in transactions) {
      if (tx.type == 'vcs' || tx.type == 'edit') continue;

      var activity = activityFromTransaction(tx, userMap, defaultUser);
      if (activity == null && (inbound || forUserIds != null)) {
        activity = _directedInboxActivity(tx, userMap, defaultUser);
      }
      if (activity == null) continue;

      if (!inbound && forUserIds == null && followerUserIds == null) {
        activities.add(activity);
        continue;
      }

      final author = userMap[tx.authorPHID];
      final directed = forUserIds != null
          ? forUserIds.where((id) => id.isNotEmpty)
          : _inboxRecipientsFor(tx, users);
      final targets = inboxLaneTargets(
        directedUserIds: directed,
        followerUserIds: followerUserIds ?? const [],
      );
      for (final (targetId, lane) in targets) {
        final recipient = users.where((u) => u.id == targetId).firstOrNull;
        if (recipient == null) continue;
        activities.add(
          Activity(
            id: withInboxLaneId('phorge-tx-${tx.id}-$targetId', lane).v5Uuid,
            userId: recipient.id,
            senderUserId: senderUserId ?? author?.id,
            authorName: activity.authorName,
            commentCount: activity.commentCount,
            provider: activity.provider,
            title: activity.title,
            content: activity.content,
            url: activity.url,
            createdAt: activity.createdAt,
            inboxLane: lane,
          ),
        );
      }
    }

    return activities;
  }

  /// Maps assignee / CC / reviewer transactions that Explorer does not surface.
  Activity? _directedInboxActivity(
    PhorgeTransactionDto tx,
    Map<String?, User> authorMap,
    User? defaultUser,
  ) {
    final content = _directedInboxContent(tx.type);
    if (content == null) return null;
    final author = authorMap[tx.authorPHID] ?? defaultUser;
    if (author == null) return null;
    return Activity(
      id: 'phorge-tx-${tx.id}'.v5Uuid,
      userId: author.id,
      authorName: (author.phorgeUsername ?? '').trim().isNotEmpty
          ? author.phorgeUsername!.trim()
          : author.name,
      commentCount: 0,
      provider: PhorgeTaskProvider(
        taskPhid: task.conduitPhid,
        tags: task.projectPHIDs.join(','),
      ),
      title: '[T${task.conduitTaskId}] ${task.name}',
      content: content,
      url: '/T${task.conduitTaskId}',
      createdAt: tx.dateCreated,
    );
  }

  String? _directedInboxContent(String type) {
    if (type == 'owner' || type == 'reassign') return 'Changed task assignee';
    if (type == 'reviewers' || type.contains('reviewer')) {
      return 'Updated reviewers';
    }
    if (type == 'subscribers' || type.contains('subscriber')) {
      return 'Updated subscribers';
    }
    return null;
  }

  /// Mentions, new assignee, and newly added CC/reviewers. Standing owner is
  /// not automatic — Follow supplies extra recipients at ingest.
  Set<String> _inboxRecipientsFor(PhorgeTransactionDto tx, List<User> users) {
    final phidToUser = {
      for (final user in users)
        if ((user.phorgePhid ?? '').isNotEmpty) user.phorgePhid!: user.id,
    };
    final nameToUser = {
      for (final user in users)
        if ((user.phorgeUsername ?? '').trim().isNotEmpty)
          user.phorgeUsername!.trim().toLowerCase(): user.id,
    };
    final explicit = <String>{};

    void addPhid(Object? raw, Set<String> into) {
      if (raw is List) {
        for (final item in raw) {
          addPhid(item, into);
        }
        return;
      }
      if (raw is Map) {
        for (final key in raw.keys) {
          addPhid(key, into);
        }
        return;
      }
      final phid = raw?.toString().trim() ?? '';
      if (phid.isEmpty) return;
      final userId = phidToUser[phid];
      if (userId != null) into.add(userId);
    }

    if (tx.type == 'comment') {
      final text = tx.commentText ?? '';
      for (final match in RegExp(r'\{@([^}]+)\}').allMatches(text)) {
        addPhid(match.group(1), explicit);
      }
      for (final match in RegExp(r'@([A-Za-z0-9._-]+)').allMatches(text)) {
        final name = match.group(1)?.toLowerCase();
        if (name == null) continue;
        final userId = nameToUser[name];
        if (userId != null) explicit.add(userId);
      }
    }
    if (tx.type == 'owner' || tx.type == 'reassign') {
      addPhid(tx.newValue, explicit);
    }
    if (tx.type == 'subscribers' ||
        tx.type == 'reviewers' ||
        tx.type.contains('reviewer') ||
        tx.type.contains('subscriber')) {
      addPhid(tx.newValue, explicit);
    }

    return explicit;
  }
}
