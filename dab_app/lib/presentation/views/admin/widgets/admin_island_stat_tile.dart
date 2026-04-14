import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Single metric tile in the admin island bar (icon + caption + value, explorer-style chrome).
class AdminIslandStatTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String tooltip;
  final Color? iconColor;

  const AdminIslandStatTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.tooltip,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer.withValues(alpha: 0.55),
          borderRadius: AppLayout.borderMedium,
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.45)),
        ),
        child: Padding(
          // Explorer calendar buttons use compact vertical-only padding.
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 13,
                color: iconColor ?? AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  fontSize: 8,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
