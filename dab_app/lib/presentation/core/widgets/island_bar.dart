import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/app_layout.dart';
import '../styles/app_theme.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Shared top “island” for home branches — fixed size and position; only [content] swaps.
/// CONTRACT: [content] receives tight constraints filling the glass interior after [islandBarInnerPadding].
class IslandBar extends StatelessWidget {
  /// Branch-specific UI; must fit within the fixed island height.
  final Widget content;

  const IslandBar({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final glass = Theme.of(context).extension<AppGlassTheme>();
    return Padding(
      padding: AppLayout.islandBarOuterPadding,
      child: SizedBox(
        height: AppLayout.islandBarHeight,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: AppLayout.borderLarge,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: glass?.blurSigma ?? AppLayout.glassBlur,
              sigmaY: glass?.blurSigma ?? AppLayout.glassBlur,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: glass?.surface ?? scheme.surfaceContainer.withValues(alpha: 0.6),
                borderRadius: AppLayout.borderLarge,
                border: Border.all(
                  color: glass?.border ?? scheme.outline.withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: glass?.shadow ?? scheme.shadow.withValues(alpha: 0.25),
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
