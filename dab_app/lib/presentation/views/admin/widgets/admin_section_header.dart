import 'package:flutter/material.dart';
import '../../../core/styles/app_colors.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Header for a section in the Admin Console.
class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AdminSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.white,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.onSurfaceVariantLow.withValues(
              alpha: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}
