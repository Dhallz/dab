import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Tappable refresh control in the admin island bar, matching stat tile chrome.
class AdminIslandRefreshTile extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const AdminIslandRefreshTile({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Refresh admin data',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppLayout.borderMedium,
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withValues(alpha: 0.55),
              borderRadius: AppLayout.borderMedium,
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.45),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loading)
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    )
                  else
                    Icon(
                      AppIcons.refresh,
                      size: AppLayout.iconLarge,
                      color: AppColors.onSurfaceVariant,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'REFRESH',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
