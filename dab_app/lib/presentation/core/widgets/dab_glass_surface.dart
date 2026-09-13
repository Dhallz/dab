import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/app_layout.dart';
import '../styles/app_theme.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Shared glass panel for cards and chrome. Uses [AppGlassTheme] tokens.
class DabGlassSurface extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const DabGlassSurface({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final glass = Theme.of(context).extension<AppGlassTheme>();
    final radius = borderRadius ?? AppLayout.borderLarge;
    final blur = glass?.blurSigma ?? AppLayout.glassBlur;
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color:
                glass?.surface ??
                scheme.surfaceContainer.withValues(alpha: 0.7),
            borderRadius: radius,
            border: Border.all(
              color: glass?.border ?? scheme.outline.withValues(alpha: 0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: glass?.shadow ?? scheme.shadow.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
