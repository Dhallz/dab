import 'package:flutter/material.dart';

import '../styles/app_spacing.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Compact per-view toolbar. Left-packed controls, optional pinned trailing action.
class ViewToolbar extends StatelessWidget {
  final List<Widget> children;
  final Widget? trailing;

  const ViewToolbar({super.key, required this.children, this.trailing});

  /// Horizontal inset shared with the view body so content lines up with the toolbar.
  static double horizontalPadding(BuildContext context) =>
      MediaQuery.sizeOf(context).width > 800 ? 28.0 : AppSpacing.m;

  @override
  Widget build(BuildContext context) {
    final horizontal = horizontalPadding(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.xs),
                    children[i],
                  ],
                ],
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.xs),
            trailing!,
          ],
        ],
      ),
    );
  }
}
