import 'package:dart_mappable/dart_mappable.dart';

import 'upcoming_event_priority.dart';

part 'upcoming_event.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Placeholder-ready model for time-anchored events shown in the
/// Dashboard "Upcoming Soon" section (meetings, deadlines, ceremonies).
/// CONTRACT: Immutable value object. Serializable via dart_mappable.
/// CONSTRAINTS: No provider coupling — calendar integrations will map their
/// domain objects onto this contract when they land. Must stay
/// presentation-agnostic so multiple sources can contribute events.
@MappableClass()
class UpcomingEvent with UpcomingEventMappable {
  /// Stable identifier. Used for dedupe across refreshes and for the
  /// banner-notified-event set on the Dashboard state.
  final String id;

  /// Human title for the card and banner.
  final String title;

  /// Absolute start time. Banner evaluation compares this against `now()`.
  final DateTime startsAt;

  /// Optional deep link (calendar entry, docs, meeting URL).
  final String? url;

  /// Short source label (e.g. "Calendar", "Sprint") surfaced on the card.
  final String source;

  /// Relative importance. Controls banner sort order and visual emphasis.
  final UpcomingEventPriority priority;

  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.startsAt,
    this.url,
    this.source = 'Calendar',
    this.priority = UpcomingEventPriority.normal,
  });
}
