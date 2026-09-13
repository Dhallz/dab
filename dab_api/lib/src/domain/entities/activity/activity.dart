import 'package:dart_mappable/dart_mappable.dart';
import '../../core/activity_inbox_lane.dart';
import 'activity_provider.dart';

export '../../core/activity_inbox_lane.dart';

part 'activity.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Central data model for the entire DAB system.
/// CONTRACT: Represents a single unit of work/event from an external platform.
/// CONSTRAINTS: Must be serializable (Mappable). Must be platform-agnostic.
///
/// This entity follows the **Table-Per-Type (TBT)** pattern:
/// - Core properties (title, userId, createdAt) are stored in the base `activities` table.
/// - Specialized platform-specific metadata is stored in the [provider] object.
@MappableClass()
class Activity with ActivityMappable {
  /// Unique identifier (usually UUID v5 derived from the source ID).
  final String id;

  /// Inbox owner (recipient DAB user). Live ingest fans out one row per target.
  final String userId;

  /// Linked DAB user who caused the event, when known. Null when the actor
  /// has no linked identity. Broadcasts and git watches omit this user from
  /// recipients; an explicit @mention of themselves still lands in their inbox.
  final String? senderUserId;

  /// Platform-specific metadata (Phorge Task, Jira Issue, etc.).
  final ActivityProvider provider;

  /// The summary of the activity (e.g. "[T123] New Task Created").
  final String title;

  /// The main content (e.g., the text of a comment or description of a move).
  final String content;

  /// The relative URL to the activity on the host platform.
  final String? url;

  /// Cached display name of the author at the time of the activity.
  final String authorName;

  /// Cached avatar URL of the author.
  final String? authorAvatarUrl;

  /// Count of comments/replies directly associated with this activity.
  final int commentCount;

  /// The timestamp of the activity as recorded by the external platform.
  final DateTime createdAt;

  /// Triage flag: whether the user archived this activity from the live feed.
  /// This field is only meaningful for activities currently in the Redis live
  /// feed; it is always `false` when the entity comes from the persistent
  /// database because archive/unarchive is a live-feed-only operation that is
  /// wiped from Redis on the daily UTC purge (archived or prior calendar days).
  final bool archived;

  /// Dashboard pane. Live ingest may emit a directed copy and a Follow copy.
  /// Explorer poll rows stay [ActivityInboxLane.directed].
  final ActivityInboxLane inboxLane;

  Activity({
    required this.id,
    required this.userId,
    this.senderUserId,
    required this.provider,
    required this.title,
    required this.content,
    this.url,
    required this.authorName,
    this.authorAvatarUrl,
    this.commentCount = 0,
    required this.createdAt,
    this.archived = false,
    this.inboxLane = ActivityInboxLane.directed,
  });
}

extension OnActivity on Activity {
  /// Helper to get the category (type) from the provider
  String get type => provider.category;

  /// Follow subscription copy for the right-hand Dashboard pane.
  bool get isFollowLane => inboxLane == ActivityInboxLane.follow;
}
