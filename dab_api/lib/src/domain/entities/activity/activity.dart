import 'package:dart_mappable/dart_mappable.dart';
import 'activity_provider.dart';

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
  
  /// The internal DAB User ID associated with this activity.
  final String userId;
  
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

  Activity({
    required this.id,
    required this.userId,
    required this.provider,
    required this.title,
    required this.content,
    this.url,
    required this.authorName,
    this.authorAvatarUrl,
    this.commentCount = 0,
    required this.createdAt,
  });
}

extension OnActivity on Activity {
  /// Helper to get the category (type) from the provider
  String get type => provider.category;
}
