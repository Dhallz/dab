import 'package:dart_mappable/dart_mappable.dart';

import 'dashboard_banner_severity.dart';

part 'dashboard_banner.mapper.dart';

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: View-model describing the single banner currently surfaced by the
/// Dashboard notification layer. Built by the `BannerEvaluator`.
/// CONSTRAINTS: Identifies its source [UpcomingEvent] via [eventId] so the
/// bloc can deduplicate subsequent ticks within the same threshold window.
@MappableClass()
class DashboardBanner with DashboardBannerMappable {
  /// Source event id. Paired with [thresholdMinutes] to build a stable
  /// dedupe key: `eventId|thresholdMinutes`.
  final String eventId;

  /// Headline shown inside the banner.
  final String title;

  /// Short body copy (e.g. "Starts in 5 minutes").
  final String message;

  /// Optional deep link surfaced as the banner CTA.
  final String? url;

  /// The minute threshold (e.g. 15, 5, 0) that caused this banner to fire.
  final int thresholdMinutes;

  /// Visual emphasis derived from the event's priority.
  final DashboardBannerSeverity severity;

  const DashboardBanner({
    required this.eventId,
    required this.title,
    required this.message,
    required this.thresholdMinutes,
    this.url,
    this.severity = DashboardBannerSeverity.info,
  });

  String get dedupeKey => '$eventId|$thresholdMinutes';
}
