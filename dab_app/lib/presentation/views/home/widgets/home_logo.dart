import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Branding logo for the application.
class HomeLogo extends StatelessWidget {
  const HomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.history_edu_rounded,
          color: Color(0xFF6366F1), // Primary accent color
          size: 28,
        ),
        SizedBox(width: 12),
        Text(
          'DAB Explorer',
          style: TextStyle(
            color: Color(0xFFF1F5F9), // slate-100
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
