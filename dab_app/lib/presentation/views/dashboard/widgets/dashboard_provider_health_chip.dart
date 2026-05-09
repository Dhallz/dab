import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../models/dashboard_provider_health.dart';

class DashboardProviderHealthChip extends StatelessWidget {
  final DashboardProviderHealth health;

  const DashboardProviderHealthChip({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, color) = switch (health.status) {
      DashboardProviderHealthStatus.live => (
        l10n.dashboardProviderHealthLive,
        const Color(0xFF22C55E),
      ),
      DashboardProviderHealthStatus.degraded => (
        l10n.dashboardProviderHealthDegraded,
        const Color(0xFFF59E0B),
      ),
      DashboardProviderHealthStatus.offline => (
        l10n.dashboardProviderHealthOffline,
        AppColors.error,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              health.providerName,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
