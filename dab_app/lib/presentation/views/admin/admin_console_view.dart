import 'package:flutter/material.dart';

class AdminConsoleView extends StatelessWidget {
  const AdminConsoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.admin_panel_settings_rounded,
            size: 64,
            color: const Color(0xFF94A3B8).withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          const Text(
            'Admin Console',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFFF8FAFC),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon: Manage teams and organization settings.',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF94A3B8).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
