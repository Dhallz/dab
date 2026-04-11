import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: User profile display with name and avatar.
class HomeProfile extends StatelessWidget {
  const HomeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Text(
            'Alex Rivera',
            style: TextStyle(
              color: Color(0xFFCBD5E1), // slate-300
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withOpacity(0.2),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.4),
              ),
            ),
            child: const Center(
              child: Text(
                'AR',
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
