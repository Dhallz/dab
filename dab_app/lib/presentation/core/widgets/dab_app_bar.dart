import 'dart:ui';

import 'package:flutter/material.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
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
