import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';

class DirectoryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DirectoryTile({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 72,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.accentIndigo.withValues(alpha: 0.5)
                  : AppColors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentIndigo.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColors.accentIndigo
                    : AppColors.onSurfaceVariantLow,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.onSurfaceVariantLow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
