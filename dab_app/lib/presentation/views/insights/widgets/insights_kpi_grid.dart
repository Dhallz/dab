import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity_category.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../insights_state.dart';
import 'insights_glass_card.dart';

class InsightsKpiGrid extends StatelessWidget {
  final InsightsState state;

  const InsightsKpiGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final topCategory = state.mostFrequentCategory != null
        ? _categoryLabel(context, state.mostFrequentCategory!)
        : '-';
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 520
            ? 2
            : 1;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.m,
          crossAxisSpacing: AppSpacing.m,
          childAspectRatio: 2.2,
          children: [
            _KpiTile(
              label: context.l10n.insightsKpiTotalActivities,
              value: state.totalActivities.toString(),
            ),
            _KpiTile(
              label: context.l10n.insightsKpiActiveUsers,
              value: state.activeUsersCount.toString(),
            ),
            _KpiTile(
              label: context.l10n.insightsKpiActiveProviders,
              value: state.activeProvidersCount.toString(),
            ),
            _KpiTile(
              label: context.l10n.insightsKpiTopActivityType,
              value: topCategory,
            ),
          ],
        );
      },
    );
  }

  String _categoryLabel(BuildContext context, ActivityCategory category) {
    return switch (category) {
      ActivityCategory.commit => context.l10n.explorerActivityFilterCommit,
      ActivityCategory.revision => context.l10n.explorerActivityFilterRevision,
      ActivityCategory.task => context.l10n.explorerActivityFilterTask,
      ActivityCategory.message => context.l10n.explorerActivityFilterMessage,
      ActivityCategory.generic => context.l10n.explorerActivityFilterGeneric,
    };
  }
}

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;

  const _KpiTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return InsightsGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onSurfaceHighlight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
