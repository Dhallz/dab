import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../dashboard_state.dart';
import 'dashboard_provider_health_chip.dart';

class DashboardSidebarContent extends StatelessWidget {
  final DashboardState state;

  const DashboardSidebarContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboardProviderHealthTitle,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          if (state.providerHealth.isEmpty)
            Text(
              l10n.dashboardNoProviderActivity,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            )
          else
            ...state.providerHealth.map(
              (provider) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DashboardProviderHealthChip(health: provider),
              ),
            ),
          const SizedBox(height: 20),
          _CounterTile(label: l10n.dashboardSnoozed, value: state.snoozedCount),
          const SizedBox(height: 8),
          _CounterTile(
            label: l10n.dashboardReviewQueue,
            value: state.reviewQueueCount,
          ),
          const SizedBox(height: 20),
          Text(
            state.lastSyncedAt == null
                ? l10n.dashboardNoSyncYet
                : l10n.dashboardLastSync(
                    _formatSyncTime(state.lastSyncedAt!),
                  ),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSyncTime(DateTime dateTime) {
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mm = dateTime.minute.toString().padLeft(2, '0');
    final ss = dateTime.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}

class _CounterTile extends StatelessWidget {
  final String label;
  final int value;

  const _CounterTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            '$value',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
