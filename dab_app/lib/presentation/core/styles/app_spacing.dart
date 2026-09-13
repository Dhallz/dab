/// [ARCH: PRESENTATION_CORE]
/// ROLE: Central repository for all spacing, padding, and gap constants.
/// USAGE: `AppSpacing.m`, `EdgeInsets.all(AppSpacing.screenPadding)`
class AppSpacing {
  // Base scales
  /// 4px
  static const double xxs = 4.0;

  /// 8px
  static const double xs = 8.0;

  /// 12px
  static const double s = 12.0;

  /// 16px
  static const double m = 16.0;

  /// 24px
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Semantic mappings
  static const double screenPadding = l;
  static const double cardPadding = m;
  static const double elementGap = s;
  static const double sectionGap = xl;
}
