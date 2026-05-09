import 'package:flutter/material.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Branding logo for the application.
class HomeLogo extends StatelessWidget {
  final bool showExpandedName;
  final double iconSize;

  const HomeLogo({super.key, this.showExpandedName = true, this.iconSize = 28});

  @override
  Widget build(BuildContext context) {
    final primaryLabelStyle = AppTextStyles.titleLarge.copyWith(
      color: AppColors.onSurfaceHighlight,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
    );
    final secondaryLabelStyle = AppTextStyles.labelSmall.copyWith(
      color: AppColors.onSurfaceVariantLow,
      fontWeight: FontWeight.w600,
      height: 1.05,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.brand, color: AppColors.primary, size: iconSize),
        const SizedBox(width: AppSpacing.s),
        Text('DAB', style: primaryLabelStyle),
        if (showExpandedName) ...[
          const SizedBox(width: AppSpacing.xs),
          Container(
            width: 1,
            height: iconSize,
            decoration: BoxDecoration(
              color: AppColors.outline.withValues(alpha: 0.5),
              borderRadius: AppLayout.borderSmall,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Dev Activity Board',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: secondaryLabelStyle,
          ),
        ],
      ],
    );
  }
}
