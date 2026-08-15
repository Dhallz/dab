import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/dab_island_stat.dart';
import '../dashboard_state.dart';
import 'dashboard_provider_health_chip.dart';

class DashboardSidebarContent extends StatelessWidget {
  final DashboardState state;

  const DashboardSidebarContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DabIslandStat(
            icon: AppIcons.dashboard,
            title: l10n.dashboardIslandLive,
            value: '${state.visibleActivities.length}',
          ),
          const SizedBox(height: AppSpacing.s),
          DabIslandStat(
            icon: AppIcons.delete,
            title: l10n.dashboardIslandArchived,
            value: '${state.archivedCount}',
          ),
          const SizedBox(height: AppSpacing.l),
          Text(
            l10n.dashboardProviderHealthTitle,
            style: AppTextStyles.labelLarge.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          if (state.providerHealth.isEmpty)
            Text(
              l10n.dashboardNoProviderActivity,
              style: AppTextStyles.bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          else
            ...state.providerHealth.map(
              (provider) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DashboardProviderHealthChip(health: provider),
              ),
            ),
        ],
      ),
    );
  }
}
