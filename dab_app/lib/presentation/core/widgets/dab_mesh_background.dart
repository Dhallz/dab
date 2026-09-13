import 'package:flutter/material.dart';

class DabMeshBackground extends StatelessWidget {
  final Widget child;

  const DabMeshBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        // Base background
        Positioned.fill(child: ColoredBox(color: scheme.surface)),
        // Corner Mesh Glow 1
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  scheme.primary.withValues(alpha: 0.12),
                  scheme.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        // Corner Mesh Glow 2
        Positioned(
          bottom: -150,
          right: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  scheme.tertiaryContainer.withValues(alpha: 0.2),
                  scheme.tertiaryContainer.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        // The content
        Positioned.fill(child: child),
      ],
    );
  }
}
