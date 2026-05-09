import 'package:dart_mappable/dart_mappable.dart';

part 'upcoming_event_priority.mapper.dart';

/// [ARCH: DOMAIN_ENUM]
/// Relative importance levels for [UpcomingEvent]s. Drives the sort order
/// consumed by the banner evaluator when multiple events are eligible.
@MappableEnum()
enum UpcomingEventPriority {
  low,
  normal,
  high,
  critical;

  /// Integer weight used for sorting; higher wins.
  int get weight => switch (this) {
    UpcomingEventPriority.low => 0,
    UpcomingEventPriority.normal => 1,
    UpcomingEventPriority.high => 2,
    UpcomingEventPriority.critical => 3,
  };
}
