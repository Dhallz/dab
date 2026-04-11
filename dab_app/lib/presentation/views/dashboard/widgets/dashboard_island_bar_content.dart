import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Dashboard body for [IslandBar] — lightweight placeholder until dashboard metrics exist.
class DashboardIslandBarContent extends StatelessWidget {
  const DashboardIslandBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcons.emptyState, color: AppColors.onSurfaceVariant, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Dashboard',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          'Overview',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
