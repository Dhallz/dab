import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Central repository for all typography styles, based on Material 3 roles.
class AppTextStyles {
  // Primary UI Font: Mona Sans (Technical, Modern, Wide)
  static const String fontFamily = 'Mona Sans';

  // Monospaced Font: JetBrains Mono (For IDs, Hashes, Code)
  static TextStyle get monospaced => GoogleFonts.jetBrainsMono();

  // --- Display Styles ---
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: -1.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: -0.8,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: -0.5,
  );

  // --- Headline Styles ---
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
  );

  // --- Title Styles ---
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: 0.1,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: 0.1,
  );

  // --- Body Styles ---
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
  );

  // --- Label Styles ---
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );

  // --- Custom Variants (Semantic) ---
  static TextStyle get dashboardTitle => displaySmall.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.onSurfaceHighlight,
    letterSpacing: -0.5,
  );

  static TextStyle get bodySubtitle =>
      bodyMedium.copyWith(color: AppColors.onSurfaceVariantLow);

  static TextStyle get codeSnippet =>
      monospaced.copyWith(fontSize: 12, color: AppColors.secondary);
}
