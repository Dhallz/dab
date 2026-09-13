import 'dart:ui' show lerpDouble;

import 'package:dab_app/domain/entities/system/app_theme_variant.dart';
import 'package:flutter/material.dart';

import 'package:dab_app/presentation/core/styles/activity_category_styles.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
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
      dividerTheme: _dividerTheme(colorScheme),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
        dense: true,
      ),
      checkboxTheme: _checkboxTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      switchTheme: _switchTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
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
    ).copyWith(
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
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
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: _dividerTheme(colorScheme),
      checkboxTheme: _checkboxTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      switchTheme: _switchTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
        dense: true,
      ),
      extensions: [
        ActivityCategoryStyles.dark(),
        ProviderStyles.dark(),
        _glassTheme(colorScheme),
      ],
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
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      error: AppColors.error,
      onError: AppColors.onError,
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
      dividerTheme: _dividerTheme(colorScheme),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
        dense: true,
      ),
      checkboxTheme: _checkboxTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      switchTheme: _switchTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
      ),
      extensions: [
        ActivityCategoryStyles.dark(),
        ProviderStyles.dark(),
        _glassTheme(colorScheme),
      ],
    );
  }

  static ThemeData themeFor(AppThemeVariant variant) {
    return switch (variant) {
      AppThemeVariant.light => light,
      AppThemeVariant.dab => dab,
      AppThemeVariant.greyscale => greyscale,
    };
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme cs) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return cs.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(cs.onPrimary),
      side: BorderSide(color: cs.outline, width: 1.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  static ChipThemeData _chipTheme(ColorScheme cs) {
    return ChipThemeData(
      selectedColor: cs.primary.withValues(alpha: 0.2),
      checkmarkColor: cs.primary,
      labelStyle: AppTextStyles.labelMedium.copyWith(color: cs.onSurface),
      shape: const StadiumBorder(),
      side: BorderSide(color: cs.outline.withValues(alpha: 0.35)),
    );
  }

  static SwitchThemeData _switchTheme(ColorScheme cs) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return cs.onPrimary;
        return cs.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return cs.primary;
        return cs.surfaceContainerHighest;
      }),
    );
  }

  static DividerThemeData _dividerTheme(ColorScheme cs) {
    return DividerThemeData(
      color: cs.outlineVariant.withValues(alpha: 0.9),
      thickness: 1,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme cs) {
    final fill = cs.brightness == Brightness.light
        ? cs.surfaceContainerLowest
        : cs.surfaceContainerLow;
    final subtleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: cs.outlineVariant.withValues(alpha: 0.85),
      ),
    );
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: cs.onSurfaceVariant.withValues(alpha: 0.75),
      ),
      border: subtleBorder,
      enabledBorder: subtleBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.primary, width: 1.5),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme cs) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.95),
        ),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static AppGlassTheme _glassTheme(ColorScheme cs) {
    return AppGlassTheme(
      surface: cs.surfaceContainer.withValues(alpha: 0.65),
      border: cs.outline.withValues(alpha: 0.3),
      shadow: cs.shadow.withValues(alpha: 0.2),
      blurSigma: AppLayout.glassBlur,
    );
  }
}
