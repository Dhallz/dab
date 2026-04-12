import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entities/activity/activity.dart';
import '../../../../../domain/entities/provider/provider_config.dart';
import '../../../../../presentation/core/styles/app_colors.dart';
import '../../../../../presentation/core/styles/provider_icon_resolver.dart';

class ActivityProviderIcon extends StatelessWidget {
  final Activity activity;
  final List<ProviderConfig> configs;

  const ActivityProviderIcon({
    super.key,
    required this.activity,
    required this.configs,
  });

  @override
  Widget build(BuildContext context) {
    final providerId = activity.provider.name;
    final iconData = ProviderIconResolver.resolveFallbackIcon(context, providerId);
    final brandColor = ProviderIconResolver.resolveBrandColor(context, providerId);
    final iconColor = brandColor.computeLuminance() < 0.2
        ? AppColors.onSurface
        : brandColor;
    final customIconUrl = ProviderIconResolver.resolveIconUrl(providerId, configs);

    Widget fallbackIcon = Icon(
      iconData,
      size: 16,
      color: iconColor,
    );

    Widget icon = fallbackIcon;

    if (customIconUrl != null) {
      icon = CachedNetworkImage(
        imageUrl: customIconUrl,
        width: 16,
        height: 16,
        placeholder: (context, url) => fallbackIcon,
        errorWidget: (context, url, error) => fallbackIcon,
      );
    }

    return Tooltip(
      message: 'Source: ${activity.provider.name}',
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.onSurfaceVariantLow.withValues(alpha: 0.35),
          ),
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
