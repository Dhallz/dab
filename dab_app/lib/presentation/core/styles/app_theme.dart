import 'dart:ui' show lerpDouble;

import 'package:dab_app/domain/entities/system/app_theme_variant.dart';
import 'package:flutter/material.dart';

import 'package:dab_app/presentation/core/styles/activity_category_styles.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:dab_app/presentation/core/styles/provider_styles.dart';

@immutable
class AppGlassTheme extends ThemeExtension<AppGlassTheme> {
  final Color surface;
  final Color border;
  final Color shadow;
  final double blurSigma;

  const AppGlassTheme({
    required this.surface,
    required this.border,
    required this.shadow,
    this.blurSigma = 30,
  });

  @override
  AppGlassTheme copyWith({
    Color? surface,
    Color? border,
    Color? shadow,
    double? blurSigma,
  }) {
    return AppGlassTheme(
      surface: surface ?? this.surface,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      blurSigma: blurSigma ?? this.blurSigma,
    );
  }

  @override
  AppGlassTheme lerp(ThemeExtension<AppGlassTheme>? other, double t) {
    if (other is! AppGlassTheme) {
      return this;
    }
    return AppGlassTheme(
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      border: Color.lerp(border, other.border, t) ?? border,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t) ?? blurSigma,
    );
  }
}

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Central theme configuration for the application.
class AppTheme {
  /// Light-specific neutrals: warm off-white canvas, white elevated surfaces,
  /// soft shadows instead of heavy gray fills (see [_buildLightTheme]).
  static const Color _lightCanvas = Color(0xFFF5F4F2);
  static const Color _lightOnSurface = Color(0xFF1C1917);
  static const Color _lightOnVariant = Color(0xFF57534E);
  static const Color _lightOutlineSoft = Color(0xFFE7E5E4);

  static ThemeData _buildLightTheme(ColorScheme colorScheme) {
    final subtleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: colorScheme.outlineVariant.withValues(alpha: 0.85),
      ),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTextStyles.fontFamily,
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: _lightOutlineSoft.withValues(alpha: 0.9),
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.95),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
        ),
        border: subtleBorder,
        enabledBorder: subtleBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 3,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        textStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      extensions: [
        ActivityCategoryStyles.dark(),
        ProviderStyles.dark(),
        AppGlassTheme(
          surface: colorScheme.surfaceContainerLowest.withValues(alpha: 0.82),
          border: colorScheme.outline.withValues(alpha: 0.35),
          shadow: colorScheme.shadow.withValues(alpha: 0.07),
          blurSigma: 22,
        ),
      ],
    );
  }

  static ThemeData get light {
    final seed = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );
    return _buildLightTheme(
      seed.copyWith(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: const Color(0xFFE8E9FD),
        onPrimaryContainer: const Color(0xFF1E1B4B),
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        error: AppColors.error,
        onError: AppColors.onError,
        surfaceTint: AppColors.primary,
        // Warm minimal canvas; white is reserved for cards/chrome that should float.
        surface: _lightCanvas,
        surfaceContainerLowest: const Color(0xFFFFFFFF),
        surfaceContainerLow: const Color(0xFFFDFCFB),
        surfaceContainer: const Color(0xFFF0EEEB),
        surfaceContainerHigh: const Color(0xFFE8E6E3),
        surfaceContainerHighest: const Color(0xFFDCDAD7),
        onSurface: _lightOnSurface,
        onSurfaceVariant: _lightOnVariant,
        outline: const Color(0xFFA8A29E),
        outlineVariant: _lightOutlineSoft,
        shadow: const Color(0xFF000000),
        inverseSurface: const Color(0xFF1C1917),
        onInverseSurface: const Color(0xFFF5F5F4),
        inversePrimary: const Color(0xFFC7D2FE),
      ),
    );
  }

  /// Branded DAB dark palette ([AppThemeVariant.dab]).
  static ThemeData get dab {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: AppColors.shadow,
      scrim: AppColors.black,
      inverseSurface: AppColors.white,
      onInverseSurface: AppColors.black,
      inversePrimary: AppColors.primary,
      surfaceTint: AppColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: colorScheme.copyWith(
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge,
      ),
      // Preserve your original dark palette behavior.
      extensions: [ActivityCategoryStyles.dark(), ProviderStyles.dark()],
    );
  }

  /// Neutral grayscale dark surfaces ([AppThemeVariant.greyscale]) with the same
  /// DAB indigo primary/highlight as [dab] (not the seed-derived cyan accent).
  static ThemeData get greyscale {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF737373),
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      inversePrimary: AppColors.primary,
      surfaceTint: AppColors.primary,
      surface: const Color(0xFF121212),
      surfaceContainerLowest: const Color(0xFF0D0D0D),
      surfaceContainerLow: const Color(0xFF161616),
      surfaceContainer: const Color(0xFF1E1E1E),
      surfaceContainerHigh: const Color(0xFF262626),
      surfaceContainerHighest: const Color(0xFF2E2E2E),
      onSurface: const Color(0xFFE5E5E5),
      onSurfaceVariant: const Color(0xFFA3A3A3),
      outline: const Color(0xFF525252),
      outlineVariant: const Color(0xFF404040),
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      extensions: [ActivityCategoryStyles.dark(), ProviderStyles.dark()],
    );
  }

  static ThemeData themeFor(AppThemeVariant variant) {
    return switch (variant) {
      AppThemeVariant.light => light,
      AppThemeVariant.dab => dab,
      AppThemeVariant.greyscale => greyscale,
    };
  }
}
