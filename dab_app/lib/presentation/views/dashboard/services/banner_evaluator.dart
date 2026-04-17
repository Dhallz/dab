import '../../../../domain/entities/upcoming/upcoming_event.dart';
import '../../../../domain/entities/upcoming/upcoming_event_priority.dart';
import '../models/dashboard_banner.dart';
import '../models/dashboard_banner_severity.dart';

/// [ARCH: PRESENTATION_SERVICE]
/// ROLE: Pure function that decides whether the Dashboard should surface an
/// in-app banner for any of the supplied upcoming events.
/// CONTRACT: Single-result selector — picks at most one banner per tick,
/// using the highest-priority event that freshly crossed one of the
/// configured thresholds (15m, 5m, 0m by default).
/// CONSTRAINTS: Deterministic and stateless; callers own the dedupe set
/// (`alreadyNotified`) so the bloc controls lifecycle.
class BannerEvaluator {
  /// Thresholds in minutes, evaluated from smallest (most urgent) to
  /// largest. An event is considered to have crossed a threshold once
  /// `startsAt - now <= threshold && startsAt - now > nextSmallerThreshold`.
  final List<int> thresholds;

  /// Maximum drift past `startsAt` where the banner is still relevant. After
  /// this window the event is considered stale and will not fire anymore.
  final Duration staleAfter;

  const BannerEvaluator({
    this.thresholds = const [0, 5, 15],
    this.staleAfter = const Duration(minutes: 5),
  });

  /// Returns a [DashboardBanner] to display, or `null` when no event is
  /// eligible given the [alreadyNotified] dedupe set.
  DashboardBanner? evaluate({
    required List<UpcomingEvent> events,
    required DateTime now,
    required Set<String> alreadyNotified,
  }) {
    DashboardBanner? winner;
    int? winnerPriorityWeight;
    Duration? winnerUntilStart;

    for (final event in events) {
      final untilStart = event.startsAt.difference(now);
      if (untilStart.isNegative && untilStart.abs() > staleAfter) {
        continue;
      }
      final threshold = _matchedThreshold(untilStart);
      if (threshold == null) continue;

      final candidate = DashboardBanner(
        eventId: event.id,
        title: event.title,
        message: _formatMessage(untilStart),
        thresholdMinutes: threshold,
        url: event.url,
        severity: _severityFor(event.priority, threshold),
      );
      if (alreadyNotified.contains(candidate.dedupeKey)) continue;

      final weight = event.priority.weight;
      final isBetter = winner == null ||
          weight > (winnerPriorityWeight ?? -1) ||
          (weight == winnerPriorityWeight &&
              untilStart < (winnerUntilStart ?? const Duration(days: 365)));

      if (isBetter) {
        winner = candidate;
        winnerPriorityWeight = weight;
        winnerUntilStart = untilStart;
      }
    }

    return winner;
  }

  int? _matchedThreshold(Duration untilStart) {
    final minutesUntil = untilStart.inSeconds / 60.0;
    // If the event has started (negative but within staleAfter) we match the
    // `0` threshold (the "now" banner).
    if (minutesUntil <= 0) return 0;
    for (final threshold in thresholds) {
      if (threshold == 0) continue;
      if (minutesUntil <= threshold) return threshold;
    }
    return null;
  }

  String _formatMessage(Duration untilStart) {
    if (untilStart.isNegative) return 'Starting now';
    if (untilStart.inMinutes <= 0) return 'Starting now';
    if (untilStart.inMinutes == 1) return 'Starts in 1 minute';
    if (untilStart.inMinutes < 60) {
      return 'Starts in ${untilStart.inMinutes} minutes';
    }
    final hours = untilStart.inHours;
    return hours == 1 ? 'Starts in 1 hour' : 'Starts in $hours hours';
  }

  DashboardBannerSeverity _severityFor(
    UpcomingEventPriority priority,
    int threshold,
  ) {
    if (priority == UpcomingEventPriority.critical || threshold == 0) {
      return DashboardBannerSeverity.critical;
    }
    if (priority == UpcomingEventPriority.high || threshold <= 5) {
      return DashboardBannerSeverity.warning;
    }
    return DashboardBannerSeverity.info;
  }
}
