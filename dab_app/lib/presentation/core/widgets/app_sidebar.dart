import 'dart:ui';

import 'package:flutter/material.dart';
import '../styles/app_theme.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.children,
    this.width = 288,
    this.padding = const EdgeInsets.all(24),
  });

  final List<Widget> children;
  final double width;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final glass = Theme.of(context).extension<AppGlassTheme>();
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass?.blurSigma ?? 30,
          sigmaY: glass?.blurSigma ?? 30,
        ),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: glass?.surface ?? scheme.surfaceContainer.withValues(alpha: 0.6),
            border: Border(
              right: BorderSide(color: glass?.border ?? scheme.outline.withValues(alpha: 0.2)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
