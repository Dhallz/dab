import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/view_toolbar.dart';
import '../insights_notifier.dart';
import '../insights_state.dart';
import 'insights_breakdown_charts.dart';
import 'insights_details_table.dart';
import 'insights_kpi_grid.dart';
import 'insights_trend_chart.dart';

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

class _FeedbackState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _FeedbackState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ViewToolbar.horizontalPadding(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: cs.onSurfaceVariant.withValues(alpha: 0.45),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
