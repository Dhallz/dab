import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/app_colors.dart';
import '../styles/app_layout.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Shared top “island” for home branches — fixed size and position; only [content] swaps.
/// CONTRACT: [content] receives tight constraints filling the glass interior after [islandBarInnerPadding].
class IslandBar extends StatelessWidget {
  /// Branch-specific UI; must fit within the fixed island height.
  final Widget content;

  const IslandBar({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppLayout.islandBarOuterPadding,
      child: SizedBox(
        height: AppLayout.islandBarHeight,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: AppLayout.borderLarge,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: AppLayout.glassBlur,
              sigmaY: AppLayout.glassBlur,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withValues(alpha: 0.6),
                borderRadius: AppLayout.borderLarge,
                border: Border.all(
                  color: AppColors.outline.withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: AppLayout.islandBarInnerPadding,
                child: SizedBox.expand(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
