import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../../../presentation/core/styles/provider_icon_resolver.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Circular icon representing the provider and category of an activity.
class ActivityProviderIcon extends StatelessWidget {
  final Activity activity;
  final Color color;
  final List<ProviderConfig> configs;

  const ActivityProviderIcon({
    super.key,
    required this.activity,
    required this.color,
    this.configs = const [],
  });

  @override
  Widget build(BuildContext context) {
    final providerId = activity.provider.name;
    final fallbackIconData = ProviderIconResolver.resolveFallbackIcon(
      context,
      providerId,
    );
    final customIconUrl = ProviderIconResolver.resolveIconUrl(providerId, configs);
    final fallbackIcon = Icon(
      fallbackIconData,
      color: color,
      size: 22,
    );

    Widget icon = fallbackIcon;
    if (customIconUrl != null) {
      icon = CachedNetworkImage(
        imageUrl: customIconUrl,
        width: 22,
        height: 22,
        placeholder: (context, url) => fallbackIcon,
        errorWidget: (context, url, error) => fallbackIcon,
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: icon,
    );
  }
}
