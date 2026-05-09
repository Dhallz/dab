import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../models/dashboard_banner.dart';
import '../models/dashboard_banner_severity.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Renders the currently active in-app banner surfaced by
/// Dashboard upcoming-events banner. Shows a title + body, an optional
/// deep-link CTA, and a dismiss button.
/// CONSTRAINTS: Pure presentational widget; mutation is delegated back to
/// the bloc via the supplied callbacks.
class DashboardBannerWidget extends StatelessWidget {
  final DashboardBanner banner;
  final VoidCallback onDismiss;

  const DashboardBannerWidget({
    super.key,
    required this.banner,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final accent = _accentFor(banner.severity);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        border: Border.all(color: accent.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_iconFor(banner.severity), color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatDashboardUpcomingBannerBody(l10n, banner.untilStart),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (banner.url != null)
            TextButton(
              onPressed: () => _open(banner.url!),
              child: Text(l10n.commonOpen),
            ),
          IconButton(
            tooltip: l10n.commonDismiss,
            onPressed: onDismiss,
            icon: const Icon(Icons.close),
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Color _accentFor(DashboardBannerSeverity severity) {
    switch (severity) {
      case DashboardBannerSeverity.info:
        return AppColors.primary;
      case DashboardBannerSeverity.warning:
        return AppColors.genericActivity;
      case DashboardBannerSeverity.critical:
        return AppColors.error;
    }
  }

  IconData _iconFor(DashboardBannerSeverity severity) {
    switch (severity) {
      case DashboardBannerSeverity.info:
        return Icons.notifications_active_outlined;
      case DashboardBannerSeverity.warning:
        return Icons.warning_amber_outlined;
      case DashboardBannerSeverity.critical:
        return Icons.priority_high_rounded;
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// Localized body for upcoming-event banners from [BannerEvaluator].
String formatDashboardUpcomingBannerBody(
  AppLocalizations l10n,
  Duration untilStart,
) {
  if (untilStart.isNegative) return l10n.bannerStartingNow;
  if (untilStart.inMinutes <= 0) return l10n.bannerStartingNow;
  if (untilStart.inMinutes == 1) return l10n.bannerStartsInOneMinute;
  if (untilStart.inMinutes < 60) {
    return l10n.bannerStartsInMinutes(untilStart.inMinutes);
  }
  final hours = untilStart.inHours;
  return hours == 1
      ? l10n.bannerStartsInOneHour
      : l10n.bannerStartsInHours(hours);
}
