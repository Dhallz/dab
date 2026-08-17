import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/user/activity_follow.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/provider_icon_resolver.dart';
import '../../../core/widgets/dab_glass_surface.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Compact watching rows for Follow pins that do not yet have a
/// Follow-lane live card.
class DashboardFollowingPins extends StatelessWidget {
  final List<ActivityFollow> pins;
  final void Function(ActivityFollow follow) onUnfollow;

  const DashboardFollowingPins({
    super.key,
    required this.pins,
    required this.onUnfollow,
  });

  @override
  Widget build(BuildContext context) {
    if (pins.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final pin in pins)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s),
            child: _WatchingPinTile(
              pin: pin,
              onUnfollow: () => onUnfollow(pin),
            ),
          ),
      ],
    );
  }
}

class _WatchingPinTile extends StatelessWidget {
  final ActivityFollow pin;
  final VoidCallback onUnfollow;

  const _WatchingPinTile({required this.pin, required this.onUnfollow});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final icon = ProviderIconResolver.resolveFallbackIcon(
      context,
      pin.providerId,
    );
    final brand = ProviderIconResolver.resolveBrandColor(
      context,
      pin.providerId,
    );
    final url = pin.url?.trim() ?? '';
    return DabGlassSurface(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: brand),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: InkWell(
              onTap: url.isEmpty ? null : () => _launch(url),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashboardWatchingPinLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                  Text(
                    pin.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.activityTooltipFollowing,
            icon: Icon(AppIcons.following),
            color: scheme.primary,
            onPressed: onUnfollow,
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
