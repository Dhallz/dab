import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Search input field for the application header.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256, // w-64
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 18),
          SizedBox(width: 8),
          Text(
            'Search archives...',
            style: TextStyle(
              color: Color(0xFF64748B), // slate-500
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
