import 'package:dart_mappable/dart_mappable.dart';

part 'group_type.mapper.dart';

@MappableEnum()
enum GroupType {
  /// Manually created by DAB users.
  custom,

  /// Synchronized from external platforms (e.g., Slack Channels).
  provider
}
