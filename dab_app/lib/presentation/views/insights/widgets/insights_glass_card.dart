import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';

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
    return ClipRRect(
      borderRadius: AppLayout.borderLarge,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppLayout.glassBlur,
          sigmaY: AppLayout.glassBlur,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.glassSurface,
            borderRadius: AppLayout.borderLarge,
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.glassGlow,
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
