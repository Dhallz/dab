import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Color transformation utilities for UI accessibility and branding.
extension OnColor on Color {
  /// Adjusts the color to ensure it has enough contrast on dark glassmorphic surfaces.
  /// Used primarily for brand colors like GitHub and Slack that are naturally very dark.
  Color get toAccessibleBrandColor {
    // If luminance is too low, we boost the lightness and saturation
    if (computeLuminance() < 0.3) {
      return HSLColor.fromColor(this)
          .withLightness(0.7)
          .withSaturation(0.8)
          .toColor();
    }
    return this;
  }
}
