import 'package:flutter/material.dart';

class DabMeshBackground extends StatelessWidget {
  final Widget child;

  const DabMeshBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base background
        Positioned.fill(
          child: Container(color: const Color(0xFF0F172A)), // Primary BG
        ),
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
                  const Color(0xFF6366F1).withOpacity(0.1), // Accent Primary
                  const Color(0xFF6366F1).withOpacity(0),
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
                  const Color(0xFF1E1B4B).withOpacity(0.2), // Mesh Corner
                  const Color(0xFF1E1B4B).withOpacity(0),
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
