import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_theme.dart';

class InsightsGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const InsightsGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.m),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final glass = Theme.of(context).extension<AppGlassTheme>();
    final blur = glass?.blurSigma ?? AppLayout.glassBlur;
    return ClipRRect(
      borderRadius: AppLayout.borderLarge,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: glass?.surface ??
                scheme.surfaceContainer.withValues(alpha: 0.72),
            borderRadius: AppLayout.borderLarge,
            border: Border.all(
              color: glass?.border ??
                  scheme.outline.withValues(alpha: 0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: glass?.shadow ??
                    scheme.shadow.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
