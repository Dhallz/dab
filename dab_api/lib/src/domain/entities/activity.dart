import 'package:dart_mappable/dart_mappable.dart';

import 'activity_provider.dart';

part 'activity.mapper.dart';

@MappableClass()
class Activity with ActivityMappable {
  final String id;
  final String userId;
  final ActivityProvider provider;
  final String title;
  final String content;
  final String? url;
  final String authorName;
  final String? authorAvatarUrl;
  final int commentCount;
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
