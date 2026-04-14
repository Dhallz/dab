import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../insights_bloc.dart';
import '../insights_state.dart';
import 'insights_breakdown_charts.dart';
import 'insights_details_table.dart';
import 'insights_kpi_grid.dart';
import 'insights_trend_chart.dart';

class InsightsBodyContent extends StatelessWidget {
  const InsightsBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<InsightsBloc, InsightsState>(
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        if (state.status == ViewStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ViewStatus.failure) {
          return _FeedbackState(
            icon: AppIcons.error,
            message: state.errorMessage ?? context.l10n.insightsErrorLoading,
          );
        }
        if (state.activities.isEmpty) {
          return _FeedbackState(
            icon: AppIcons.insights,
            message: context.l10n.insightsNoDataForFilters,
          );
        }

        final userNames = {for (final user in state.users) user.id: user.name};
        final detailRows = state.detailRows(userNames);

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppLayout.islandBarOuterPadding.left,
            AppSpacing.s,
            AppLayout.islandBarOuterPadding.right,
            AppSpacing.l,
          ),
          child: Column(
            children: [
              InsightsKpiGrid(state: state),
              const SizedBox(height: AppSpacing.m),
              InsightsTrendChart(state: state),
              const SizedBox(height: AppSpacing.m),
              InsightsBreakdownCharts(state: state, userNameById: userNames),
              const SizedBox(height: AppSpacing.m),
              InsightsDetailsTable(rows: detailRows),
            ],
          ),
        );
      },
    );
  }
}

class _FeedbackState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _FeedbackState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.islandBarOuterPadding.left,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppColors.onSurfaceVariantLow.withValues(alpha: 0.45),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
