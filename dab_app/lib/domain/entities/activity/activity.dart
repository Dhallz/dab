import 'package:dart_mappable/dart_mappable.dart';
import 'activity_category.dart';
import 'activity_provider.dart';
export 'activity_provider.dart';

part 'activity.mapper.dart';

@MappableClass()
class Activity with ActivityMappable {
  final String id;
  final String userId;

  /// Linked DAB user who caused the event, when known.
  final String? senderUserId;

  final ActivityProvider provider;
  final String title;
  final String content;
  final String authorName;
  final String? authorAvatarUrl;
  final int commentCount;
  final String? url;
  final DateTime createdAt;

  /// Triage flag: whether the entry was archived by the user from the
  /// dashboard live feed. Archived entries are hidden by default and wiped
  /// at midnight. Only meaningful for live-feed activities.
  final bool archived;

  Activity({
    required this.id,
    required this.userId,
    this.senderUserId,
    required this.provider,
    required this.title,
    required this.content,
    required this.authorName,
    this.authorAvatarUrl,
    required this.commentCount,
    this.url,
    required this.createdAt,
    this.archived = false,
  });
}

extension OnActivity on Activity {
  ActivityCategory get type => provider.category;
}
