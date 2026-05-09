import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/upcoming/upcoming_event.dart';
import '../../../../domain/entities/upcoming/upcoming_event_priority.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../auth/widgets/auth_glass_card.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Renders the Dashboard "Upcoming Soon" section — a list of time
/// anchored items with relative countdown labels and a single deep-link CTA.
/// When the supplied [events] list is empty an empty-state card is rendered
/// so the section keeps a stable footprint.
class UpcomingSoonSection extends StatelessWidget {
  final List<UpcomingEvent> events;
  final DateTime Function() now;

  const UpcomingSoonSection({
    super.key,
    required this.events,
    this.now = DateTime.now,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(
            l10n.dashboardUpcomingSoonTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        if (events.isEmpty)
          _EmptyState(l10n: l10n)
        else
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _UpcomingCard(event: event, now: now, l10n: l10n),
            ),
          ),
      ],
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final UpcomingEvent event;
  final DateTime Function() now;
  final AppLocalizations l10n;

  const _UpcomingCard({
    required this.event,
    required this.now,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _colorForPriority(event.priority);
    return AuthGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _localizedSourceLabel(l10n, event.source),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _countdownLabel(l10n, event.startsAt, now()),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariantLow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (event.url != null)
              TextButton(
                onPressed: () => _open(event.url!),
                child: Text(l10n.commonOpen),
              ),
          ],
        ),
      ),
    );
  }

  Color _colorForPriority(UpcomingEventPriority priority) {
    switch (priority) {
      case UpcomingEventPriority.critical:
        return AppColors.error;
      case UpcomingEventPriority.high:
        return AppColors.genericActivity;
      case UpcomingEventPriority.normal:
        return AppColors.primary;
      case UpcomingEventPriority.low:
        return AppColors.onSurfaceVariant;
    }
  }

  String _countdownLabel(
    AppLocalizations l10n,
    DateTime startsAt,
    DateTime currentTime,
  ) {
    final diff = startsAt.difference(currentTime);
    if (diff.isNegative) return l10n.upcomingRelativeInProgress;
    if (diff.inMinutes < 1) return l10n.upcomingRelativeNow;
    if (diff.inMinutes < 60) {
      return l10n.upcomingRelativeInMinutes(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return l10n.upcomingRelativeInHours(diff.inHours);
    }
    return l10n.upcomingRelativeInDays(diff.inDays);
  }

  /// Maps known [UpcomingEvent.source] values to localized labels; passes
  /// through unknown sources unchanged (still uppercased for chrome).
  static String _localizedSourceLabel(AppLocalizations l10n, String source) {
    final trimmed = source.trim();
    final lower = trimmed.toLowerCase();
    final mapped = switch (lower) {
      'calendar' => l10n.dashboardUpcomingSourceCalendar,
      _ => trimmed,
    };
    return mapped.toUpperCase();
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return AuthGlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Row(
          children: [
            Icon(
              Icons.event_available_outlined,
              color: AppColors.onSurfaceVariantLow,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.dashboardUpcomingNoEvents,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
