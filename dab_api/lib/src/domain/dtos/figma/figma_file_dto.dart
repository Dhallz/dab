import 'package:dab_api/src/domain/core/figma_scope.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'figma_file_dto.mapper.dart';

final _figmaFileActivityUuid = const Uuid();

/// [ARCH: DOMAIN]
/// ROLE: Parsed Figma file comment or last-edited snapshot for ingestion.
/// CONTRACT: [dabUserId] is the linked actor when known. Live ingest passes
/// [forUserIds] (mentions) and [followerUserIds] (file Followers).
@MappableClass()
class FigmaFileDto with FigmaFileDtoMappable {
  final String fileKey;
  final String fileName;
  final DateTime createdAt;

  /// Comment id when this row is a `FILE_COMMENT` (or poll comment).
  final String? commentId;
  final String? commentMessage;
  final String? parentId;

  /// Figma user id of the comment author or last-touched person.
  final String? authorId;
  final String? authorHandle;

  /// Figma user ids from `mentions[]`. Unlinked ids are dropped at fan-out.
  final List<String> mentionIds;

  /// True when this is a last-edited heartbeat (Follow lane only).
  final bool lastEdited;

  /// DAB user id of the actor when a linked identity exists.
  final String? dabUserId;

  const FigmaFileDto({
    required this.fileKey,
    required this.fileName,
    required this.createdAt,
    this.commentId,
    this.commentMessage,
    this.parentId,
    this.authorId,
    this.authorHandle,
    this.mentionIds = const [],
    this.lastEdited = false,
    this.dabUserId,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Maps a [FigmaFileDto] into normalized [Activity] rows.
/// CONSTRAINTS: Pure. Last-edited uses a stable id so later touches replace.
extension OnFigmaFileDto on FigmaFileDto {
  List<Activity> toActivities(
    List<User> users, {
    Iterable<String>? forUserIds,
    Iterable<String>? followerUserIds,
    String? senderUserId,
  }) {
    final userById = {for (final u in users) u.id: u};
    final events = <Activity>[];
    final fanOut = forUserIds != null || followerUserIds != null;
    final key = fileKey.trim();
    if (key.isEmpty) return const [];

    if (lastEdited) {
      final targets = fanOut
          ? resolveInboxLaneTargets(
              forUserIds: const <String>[],
              followerUserIds: followerUserIds,
            )
          : [
              for (final user in users)
                (user.id, ActivityInboxLane.directed),
            ];
      for (final (targetId, lane) in targets) {
        final owner = userById[targetId];
        if (owner == null) continue;
        final handle = (authorHandle ?? '').trim();
        final mappedAuthor = (dabUserId ?? '').trim().isEmpty
            ? null
            : userById[dabUserId];
        final authorLabel = figmaAuthorLabel(
          handle: handle,
          authorId: authorId,
        );
        final displayAuthor = authorLabel.isNotEmpty
            ? authorLabel
            : (mappedAuthor?.name.trim().isNotEmpty == true
                  ? mappedAuthor!.name.trim()
                  : '');
        final headline = displayAuthor.isEmpty
            ? 'Edited recently'
            : 'last edited by $displayAuthor';
        final fileTitle = fileName.trim().isEmpty ? key : fileName.trim();
        final idSeed = ('figma|$key|touched|$targetId').withInboxLaneId(lane);
        events.add(
          Activity(
            id: _figmaFileActivityUuid.v5(Namespace.url.value, idSeed),
            userId: owner.id,
            senderUserId: senderUserId ?? dabUserId,
            provider: FigmaFileProvider(
              fileKey: key,
              lastTouchedBy: displayAuthor.isEmpty ? null : displayAuthor,
            ),
            title: fileTitle,
            content: headline,
            url: key.figmaFileUrl(),
            authorName: displayAuthor,
            authorAvatarUrl: mappedAuthor?.avatarUrl ?? owner.avatarUrl,
            commentCount: 0,
            createdAt: createdAt.toUtc(),
            inboxLane: lane,
          ),
        );
      }
      return events;
    }

    final cid = (commentId ?? '').trim();
    if (cid.isEmpty) return const [];
    final mappedAuthor = (dabUserId ?? '').trim().isEmpty
        ? null
        : userById[dabUserId];
    final fallbackUser = mappedAuthor;
    final authorLabel = figmaAuthorLabel(
      handle: authorHandle,
      authorId: authorId,
    );
    final displayAuthor = authorLabel.isNotEmpty
        ? authorLabel
        : (mappedAuthor?.name.trim().isNotEmpty == true
              ? mappedAuthor!.name.trim()
              : '');
    final targets = resolveInboxLaneTargets(
      forUserIds: forUserIds,
      followerUserIds: followerUserIds,
      fallbackUserId: fallbackUser?.id,
    );
    for (final (targetId, lane) in targets) {
      final recipient = userById[targetId];
      if (recipient == null) continue;
      final body = (commentMessage ?? '').trim();
      final seed = fanOut
          ? ('figma|$key|comment|$cid|$targetId').withInboxLaneId(lane)
          : 'figma|$key|comment|$cid';
      final fileTitle = fileName.trim().isEmpty ? key : fileName.trim();
      events.add(
        Activity(
          id: _figmaFileActivityUuid.v5(Namespace.url.value, seed),
          userId: recipient.id,
          senderUserId: senderUserId ?? dabUserId,
          provider: FigmaFileProvider(fileKey: key, commentId: cid),
          title: fileTitle,
          content: body.isEmpty ? '(no comment body)' : body,
          url: key.figmaFileUrl(),
          authorName: displayAuthor,
          authorAvatarUrl: (mappedAuthor ?? recipient).avatarUrl,
          commentCount: 1,
          createdAt: createdAt.toUtc(),
          inboxLane: lane,
        ),
      );
    }
    return events;
  }
}
