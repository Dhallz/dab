import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/upcoming/upcoming_event.dart';
import '../../../../domain/entities/upcoming/upcoming_event_priority.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(
            'Upcoming Soon',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        if (events.isEmpty)
          _EmptyState()
        else
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _UpcomingCard(event: event, now: now),
            ),
          ),
      ],
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final UpcomingEvent event;
  final DateTime Function() now;

  const _UpcomingCard({required this.event, required this.now});

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
                        event.source.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _countdownLabel(event.startsAt, now()),
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
                child: const Text('Open'),
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

  String _countdownLabel(DateTime startsAt, DateTime currentTime) {
    final diff = startsAt.difference(currentTime);
    if (diff.isNegative) return 'in progress';
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return 'in ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'in ${diff.inHours}h';
    return 'in ${diff.inDays}d';
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _EmptyState extends StatelessWidget {
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
              'No upcoming events',
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
