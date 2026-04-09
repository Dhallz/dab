import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entities/activity.dart';
import '../../../../../domain/entities/provider_config.dart';
import '../../../../../presentation/core/extensions/activity_provider_extensions.dart';

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
    final iconData = activity.provider.icon(context);
    final iconColor = activity.provider.brandColor(context);

    String? customIconUrl;
    final providerId = activity.provider.name.toLowerCase();
    final config =
        configs.where((c) => c.id.toLowerCase() == providerId).firstOrNull ??
        configs
            .where((c) => providerId.contains(c.id.toLowerCase()))
            .firstOrNull;

    if (config != null) {
      customIconUrl = config.iconUrl;
    }

    Widget fallbackIcon = Icon(
      iconData,
      size: 16,
      color: iconColor,
    );

    Widget icon = fallbackIcon;

    if (customIconUrl != null && customIconUrl.isNotEmpty) {
      icon = CachedNetworkImage(
        imageUrl: customIconUrl,
        width: 16,
        height: 16,
        placeholder: (context, url) => fallbackIcon,
        errorWidget: (context, url, error) => fallbackIcon,
      );
    }

    return Tooltip(message: 'Source: ${activity.provider.name}', child: icon);
  }
}
