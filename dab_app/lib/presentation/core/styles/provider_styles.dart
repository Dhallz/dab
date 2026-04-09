import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_icons.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Visual metadata for external tool providers.
class ProviderStyle {
  final Color brandColor;
  final IconData icon;

  const ProviderStyle({
    required this.brandColor,
    required this.icon,
  });

  ProviderStyle lerp(ProviderStyle? other, double t) {
    if (other == null) return this;
    return ProviderStyle(
      brandColor: Color.lerp(brandColor, other.brandColor, t) ?? brandColor,
      icon: t < 0.5 ? icon : other.icon,
    );
  }
}

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Theme extension for provider-specific branding.
class ProviderStyles extends ThemeExtension<ProviderStyles> {
  final Map<String, ProviderStyle> styles;

  const ProviderStyles({required this.styles});

  factory ProviderStyles.dark() {
    return const ProviderStyles(
      styles: {
        'phorge': ProviderStyle(
          brandColor: AppColors.brandPhorge,
          icon: AppIcons.phorge,
        ),
        'github': ProviderStyle(
          brandColor: AppColors.brandGitHub,
          icon: AppIcons.github,
        ),
        'gitlab': ProviderStyle(
          brandColor: AppColors.brandGitLab,
          icon: AppIcons.github, // Fallback icon until gitlab icon added
        ),
        'linear': ProviderStyle(
          brandColor: AppColors.brandLinear,
          icon: AppIcons.genericActivity,
        ),
        'jira': ProviderStyle(
          brandColor: AppColors.brandJira,
          icon: AppIcons.task,
        ),
        'slack': ProviderStyle(
          brandColor: AppColors.brandSlack,
          icon: AppIcons.genericActivity,
        ),
        'teams': ProviderStyle(
          brandColor: AppColors.brandTeams,
          icon: AppIcons.genericActivity,
        ),
        'discord': ProviderStyle(
          brandColor: AppColors.brandDiscord,
          icon: AppIcons.genericActivity,
        ),
      },
    );
  }

  @override
  ThemeExtension<ProviderStyles> copyWith({
    Map<String, ProviderStyle>? styles,
  }) {
    return ProviderStyles(styles: styles ?? this.styles);
  }

  @override
  ThemeExtension<ProviderStyles> lerp(
    ThemeExtension<ProviderStyles>? other,
    double t,
  ) {
    if (other is! ProviderStyles) return this;
    final lerpedStyles = <String, ProviderStyle>{};
    styles.forEach((key, value) {
      lerpedStyles[key] = value.lerp(other.styles[key], t);
    });
    return ProviderStyles(styles: lerpedStyles);
  }

  ProviderStyle styleOf(String providerId) {
    final key = providerId.toLowerCase().trim();
    // Try exact match then partial match
    return styles[key] ??
        styles.entries
            .firstWhere(
              (e) => key.contains(e.key),
              orElse: () => MapEntry(
                'unknown',
                ProviderStyle(
                  brandColor: AppColors.onSurfaceVariantLow,
                  icon: AppIcons.unknownProvider,
                ),
              ),
            )
            .value;
  }
}
