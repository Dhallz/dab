import 'package:dart_mappable/dart_mappable.dart';

part 'activity.mapper.dart';

@MappableClass()
class Activity with ActivityMappable {
  final String id;
  final String userId;
  final String type; // 'commit', 'slack', 'jira', 'linear'
  final String provider; // 'GitHub', 'Slack', 'Jira', 'Linear'
  final String title;
  final String content;
  final String? url;
  final DateTime createdAt;

  Activity({
    required this.id,
    required this.userId,
    required this.type,
    required this.provider,
    required this.title,
    required this.content,
    this.url,
    required this.createdAt,
  });
}
