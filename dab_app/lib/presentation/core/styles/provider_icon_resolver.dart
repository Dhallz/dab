import 'package:flutter/material.dart';

import '../../../domain/entities/provider/provider_config.dart';
import 'app_colors.dart';
import 'app_icons.dart';
import 'provider_styles.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Deterministic resolver for provider icons/colors across UI surfaces.
class ProviderIconResolver {
  static String? resolveIconUrl(
    String providerId,
    List<ProviderConfig> configs,
  ) {
    final normalizedProvider = providerId.toLowerCase();
    final config =
        configs
            .where((c) => c.id.toLowerCase() == normalizedProvider)
            .firstOrNull ??
        configs
            .where((c) => normalizedProvider.contains(c.id.toLowerCase()))
            .firstOrNull;
    final iconUrl = config?.iconUrl?.trim();
    if (iconUrl == null || iconUrl.isEmpty) {
      return null;
    }
    return iconUrl;
  }

  static IconData resolveFallbackIcon(BuildContext context, String providerId) {
    final mappedStyle = _providerStyle(context, providerId);
    if (mappedStyle != null) {
      return mappedStyle.icon;
    }
    return _simpleIconFallback(providerId) ?? AppIcons.unknownProvider;
  }

  static Color resolveBrandColor(BuildContext context, String providerId) {
    final mappedStyle = _providerStyle(context, providerId);
    return mappedStyle?.brandColor ?? AppColors.onSurfaceVariantLow;
  }

  static ProviderStyle? _providerStyle(
    BuildContext context,
    String providerId,
  ) {
    final theme = Theme.of(context);
    final extension = theme.extension<ProviderStyles>();
    return extension?.tryStyleOf(providerId) ??
        ProviderStyles.dark().tryStyleOf(providerId);
  }

  static IconData? _simpleIconFallback(String providerId) {
    final key = providerId.toLowerCase().trim();
    if (key.contains('github')) return AppIcons.github;
    if (key.contains('gitlab')) return AppIcons.gitlab;
    if (key.contains('jira') || key.contains('jora')) return AppIcons.jira;
    if (key.contains('slack')) return AppIcons.slack;
    if (key.contains('teams') || key.contains('microsoft')) {
      return AppIcons.teams;
    }
    if (key.contains('discord')) return AppIcons.discord;
    if (key.contains('linear')) return AppIcons.linear;
    return null;
  }
}
