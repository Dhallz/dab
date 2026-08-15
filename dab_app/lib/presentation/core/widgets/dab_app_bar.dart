import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/app_layout.dart';
import '../styles/app_theme.dart';

class DabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? child;
  final List<Widget>? actions;
  final double height;
  final EdgeInsetsGeometry padding;

  const DabAppBar({
    super.key,
    this.child,
    this.actions,
    this.height = 100,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final glass = Theme.of(context).extension<AppGlassTheme>();
    return ClipRRect(
      borderRadius: AppLayout.borderLarge,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass?.blurSigma ?? AppLayout.glassBlur,
          sigmaY: glass?.blurSigma ?? AppLayout.glassBlur,
        ),
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color:
                glass?.surface ??
                scheme.surfaceContainer.withValues(alpha: 0.6),
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
          child: Row(
            children: [
              if (child != null) Expanded(child: child!),
              if (actions != null) ...[const SizedBox(width: 16), ...actions!],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
