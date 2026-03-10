import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';

class SelectionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? avatarUrl;
  final IconData? iconData;

  const SelectionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.avatarUrl,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.accentIndigo.withValues(alpha: 0.5)
                : AppColors.white.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentIndigo.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            if (avatarUrl != null)
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.white.withValues(alpha: 0.1),
                backgroundImage: NetworkImage(avatarUrl!),
              )
            else if (iconData != null)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentIndigo.withValues(alpha: 0.1)
                      : AppColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconData,
                  size: 14,
                  color: isSelected
                      ? AppColors.accentIndigo
                      : AppColors.onSurfaceVariantLow,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.accentIndigo,
              ),
          ],
        ),
      ),
    );
  }
}
