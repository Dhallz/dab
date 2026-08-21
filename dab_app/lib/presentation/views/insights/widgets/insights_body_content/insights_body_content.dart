import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/models/view_status.dart';
import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../../../core/widgets/view_toolbar.dart';
import '../../insights_notifier.dart';
import '../../insights_state.dart';
import '../insights_breakdown_charts/insights_breakdown_charts.dart';
import '../insights_details_table.dart';
import '../insights_kpi_grid/insights_kpi_grid.dart';
import '../insights_trend_chart.dart';
import 'insights_feedback_state.dart';

class InsightsBodyContent extends ConsumerWidget {
  const InsightsBodyContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      insightsNotifierProvider.select(
        (s) => (
          status: s.status,
          errorMessage: s.errorMessage,
          activities: s.activities,
          users: s.users,
        ),
      ),
    );
    final state = ref.read(insightsNotifierProvider);
    if (state.status == ViewStatus.initial ||
        state.status == ViewStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == ViewStatus.failure) {
      return InsightsFeedbackState(
        icon: AppIcons.error,
        message: state.errorMessage ?? context.l10n.insightsErrorLoading,
      );
    }
    if (state.activities.isEmpty) {
      return InsightsFeedbackState(
        icon: AppIcons.insights,
        message: context.l10n.insightsNoDataForFilters,
      );
    }

    final userNames = {for (final user in state.users) user.id: user.name};
    final detailRows = state.detailRows(userNames);

    final horizontal = ViewToolbar.horizontalPadding(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontal,
        AppSpacing.s,
        horizontal,
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
  }
}
