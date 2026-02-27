import 'package:flutter/material.dart';

class AppColors {
  // --- Material 3 ColorScheme Standard Roles ---

  // Primary: The most prominent color
  static const Color primary = Color(0xFF0e1929);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFcdd4d8);
  static const Color onPrimaryContainer = Color(0xFF0e1929);

  // Secondary: Less prominent, for selection/accents
  static const Color secondary = Color(0xFF7c8c9b);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFcdd4d8);
  static const Color onSecondaryContainer = Color(0xFF0e1929);

  // Tertiary: Contrasting accents
  static const Color tertiary = Color(0xFFe4e9ed);
  static const Color onTertiary = Color(0xFF000000);
  static const Color tertiaryContainer = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF000000);

  // Error: For destructive actions and errors
  static const Color error = Color(0xFFb00020);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFfcd8df);
  static const Color onErrorContainer = Color(0xFF370617);

  // Surface: The "background" of views and cards
  static const Color surface = Color(0xFF0a0f19);
  static const Color onSurface = Color(0xFFFFFFFF);

  // Neutral Variants: For borders and subtle separators
  static const Color outline = Color(0xFF5f6c79);
  static const Color shadow = Color(0xFF000000);

  // Surface Roles (Official M3)
  static const Color surfaceContainerLowest = Color(0xFFF0F0F0);
  static const Color surfaceContainerLow = Color(0xFFEBEBEB);
  static const Color surfaceContainer = Color(0xFFE8E8E8);
  static const Color surfaceContainerHigh = Color(0xFFE0E0E0);
  static const Color surfaceContainerHighest = Color(0xFFD8D8D8);

  // --- Functional / Semantic Extras ---

  // Feedback
  static const Color success = Color(0xFF2E7D32);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFE8F5E9);

  // UI Utilities
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // --- Brand / Artistic Tokens ---

  // Gradients components
  static const Color _gradientYellow = Color(0xFFFFE24C);
  static const Color _gradientOrange = Color(0xFFFF5A0C);
  static const Color _gradientOrangeDark = Color(0xFFF95000);

  // Gradient Getters
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _gradientYellow,
      _gradientOrange,
      _gradientOrangeDark,
      _gradientOrange,
    ],
  );

  static LinearGradient get primaryOnPressedGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_gradientOrange, _gradientYellow, _gradientOrange],
  );
}
