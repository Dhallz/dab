import 'package:flutter/material.dart';

class AppColors {
  // --- Material 3 ColorScheme Standard Roles ---

  // Primary: The most prominent color
  static const Color primary = Color(0xFF6366F1); // Electric Indigo
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF4F46E5);
  static const Color onPrimaryContainer = Color(0xFFFFFFFF);

  // Secondary: Less prominent, for selection/accents
  static const Color secondary = Color(0xFF94A3B8);
  static const Color onSecondary = Color(0xFF0F172A);
  static const Color secondaryContainer = Color(0xFF1E293B);
  static const Color onSecondaryContainer = Color(0xFFF8FAFC);

  // Tertiary: Contrasting accents
  static const Color tertiary = Color(0xFF10B981); // Emerald
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF064E3B);
  static const Color onTertiaryContainer = Color(0xFFD1FAE5);

  // Error: For destructive actions and errors
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFF450A0A);
  static const Color onErrorContainer = Color(0xFFFEE2E2);

  // Surface: The "background" of views and cards
  static const Color surface = Color(0xFF020617); // Slate 950
  static const Color onSurface = Color(0xFFF8FAFC);
  static const Color onSurfaceVariant = Color(0xFF94A3B8);

  // Neutral Variants: For borders and subtle separators
  static const Color outline = Color(0xFF334155);
  static const Color outlineVariant = Color(0xFF475569);
  static const Color shadow = Color(0xFF000000);

  // Surface Roles (Official M3)
  static const Color surfaceContainerLowest = Color(0xFF020617);
  static const Color surfaceContainerLow = Color(0xFF0F172A);
  static const Color surfaceContainer = Color(0xFF1E293B);
  static const Color surfaceContainerHigh = Color(0xFF334155);
  static const Color surfaceContainerHighest = Color(0xFF475569);

  // Semantic Text & UI Roles
  static const Color onSurfaceVariantLow = Color(0xFF94A3B8);
  static const Color onSurfaceHighlight = Color(0xFFF8FAFC);
  static const Color accentIndigo = Color(0xFF6366F1);

  // --- Functional / Semantic Extras ---

  // Glassmorphism Tokens
  static const Color glassSurface = Color(0x1A64748B); // Slate with 10% opacity
  static const Color glassBorder = Color(0x33FFFFFF); // White with 20% opacity
  static const Color glassGlow = Color(0x0D6366F1); // Indigo with 5% opacity

  // Feedback
  static const Color success = Color(0xFF2E7D32);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFE8F5E9);

  // UI Utilities
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // --- Activity Category Colors ---
  static const Color engineering = Color(0xFF3B82F6);
  static const Color revision = Color(0xFFA855F7);
  static const Color product = Color(0xFF10B981);
  static const Color genericActivity = Color(0xFFF59E0B);

  // --- Provider Brand Colors ---
  static const Color brandPhorge = Color(0xFF0066CC);
  static const Color brandGitHub = Color(0xFF181717);
  static const Color brandGitLab = Color(0xFFFC6D26);
  static const Color brandBitbucket = Color(0xFF0052CC);
  static const Color brandJira = Color(0xFF0052CC);
  static const Color brandLinear = Color(0xFF5E6AD2);
  static const Color brandFigma = Color(0xFFF24E1E);
  static const Color brandSlack = Color(0xFF4A154B);
  static const Color brandDiscord = Color(0xFF5865F2);

  // Gradient Getters

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
