import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Header display for the mobile version of the home view.
class HomeMobileHeader extends StatelessWidget {
  const HomeMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.history_edu_rounded,
                color: Color(0xFF6366F1),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'DAB',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF6366F1).withOpacity(0.2),
            child: const Text(
              'AD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
