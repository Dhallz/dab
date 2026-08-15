import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../localization/l10n_extension.dart';
import '../styles/provider_icon_resolver.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Provider glyph for activity rows. Shared by Dashboard and Explorer.
class ActivityProviderIcon extends StatelessWidget {
  final Activity activity;
  final List<ProviderConfig> configs;
  final Color? color;
  final bool padded;

  const ActivityProviderIcon({
    super.key,
    required this.activity,
    this.configs = const [],
    this.color,
    this.padded = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final providerId = activity.provider.name;
    final fallbackIconData = ProviderIconResolver.resolveFallbackIcon(
      context,
      providerId,
    );
    final brandColor =
        color ?? ProviderIconResolver.resolveBrandColor(context, providerId);
    final iconColor = color != null
        ? color!
        : (brandColor.computeLuminance() < 0.2 ? cs.onSurface : brandColor);
    final customIconUrl = ProviderIconResolver.resolveIconUrl(
      providerId,
      configs,
    );
    final iconSize = padded ? 22.0 : 16.0;
    final fallbackIcon = Icon(
      fallbackIconData,
      color: iconColor,
      size: iconSize,
    );

    Widget icon = fallbackIcon;
    if (customIconUrl != null) {
      icon = CachedNetworkImage(
        imageUrl: customIconUrl,
        width: iconSize,
        height: iconSize,
        placeholder: (context, url) => fallbackIcon,
        errorWidget: (context, url, error) => fallbackIcon,
      );
    }

    if (padded) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: iconColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: icon,
      );
    }

    return Tooltip(
      message: context.l10n.explorerTooltipSource(activity.provider.name),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(
            color: cs.onSurfaceVariant.withValues(alpha: 0.35),
          ),
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
