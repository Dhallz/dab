import 'package:flutter/widgets.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Central repository for layout-related constants (radius, blur, shadows), based on Material 3.
class AppLayout {
  // Border Radius (M3 Shape)
  static const double radiusNone = 0.0;
  static const double radiusExtraSmall = 4.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 28.0;
  static const double radiusFull = 999.0;

  static BorderRadius get borderSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderExtraLarge =>
      BorderRadius.circular(radiusExtraLarge);

  // Blur / Glassmorphism
  static const double glassBlur = 30.0;

  // Icon Sizes
  static const double iconSmall = 18.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 64.0;
}
