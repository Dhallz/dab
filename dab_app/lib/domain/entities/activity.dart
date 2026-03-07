import 'package:dart_mappable/dart_mappable.dart';

import 'activity_provider.dart';

export 'activity_provider.dart';

part 'activity.mapper.dart';

@MappableEnum()
enum ActivityCategory {
  commit,
  revision,
  task,
  generic;

  String get label {
    switch (this) {
      case ActivityCategory.commit:
      case ActivityCategory.revision:
        return 'Engineering';
      case ActivityCategory.task:
        return 'Product';
      case ActivityCategory.generic:
        return 'Activity';
    }
  }
}

@MappableClass()
class Activity with ActivityMappable {
  final String id;
  final String userId;
  final ActivityProvider provider;
  final String title;
  final String content;
  final String authorName;
  final String? authorAvatarUrl;
  final int commentCount;
  final String? url;
  final DateTime createdAt;

  Activity({
    required this.id,
    required this.userId,
    required this.provider,
    required this.title,
    required this.content,
    required this.authorName,
    this.authorAvatarUrl,
    required this.commentCount,
    this.url,
    required this.createdAt,
  });
}

extension OnActivity on Activity {
  ActivityCategory get type => provider.category;
}
