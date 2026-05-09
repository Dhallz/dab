import 'package:flutter/material.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Search input field for the application header.
class HomeSearchBar extends StatelessWidget {
  final double width;

  const HomeSearchBar({super.key, this.width = 256});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: width,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: AppLayout.borderSmall,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(AppIcons.search, color: AppColors.onSurfaceVariantLow, size: 18),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              l10n.homeSearchArchivesPlaceholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
