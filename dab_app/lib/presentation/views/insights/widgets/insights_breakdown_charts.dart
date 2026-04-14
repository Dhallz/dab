import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../domain/entities/activity/activity_category.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../insights_state.dart';
import 'insights_glass_card.dart';

class InsightsBreakdownCharts extends StatelessWidget {
  final InsightsState state;
  final Map<String, String> userNameById;

  const InsightsBreakdownCharts({
    super.key,
    required this.state,
    required this.userNameById,
  });

  @override
  Widget build(BuildContext context) {
    final providerData = state.providerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final categoryData = state.categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final userData = state.userCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 920;
        final cards = [
          _BreakdownCard(
            title: context.l10n.insightsBreakdownProviders,
            rows: providerData
                .map((entry) => _BreakdownRow(entry.key, entry.value))
                .toList(),
            color: AppColors.primary,
          ),
          _BreakdownCard(
            title: context.l10n.insightsBreakdownActivityTypes,
            rows: categoryData
                .map(
                  (entry) => _BreakdownRow(
                    _categoryLabel(context, entry.key),
                    entry.value,
                  ),
                )
                .toList(),
            color: AppColors.tertiary,
          ),
          _BreakdownCard(
            title: context.l10n.insightsBreakdownTopUsers,
            rows: userData
                .take(6)
                .map(
                  (entry) => _BreakdownRow(
                    userNameById[entry.key] ?? entry.key,
                    entry.value,
                  ),
                )
                .toList(),
            color: AppColors.secondary,
          ),
        ];

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: AppSpacing.m),
              Expanded(child: cards[1]),
              const SizedBox(width: AppSpacing.m),
              Expanded(child: cards[2]),
            ],
          );
        }

        return Column(
          children: [
            cards[0],
            const SizedBox(height: AppSpacing.m),
            cards[1],
            const SizedBox(height: AppSpacing.m),
            cards[2],
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

class _BreakdownCard extends StatelessWidget {
  final String title;
  final List<_BreakdownRow> rows;
  final Color color;

  const _BreakdownCard({
    required this.title,
    required this.rows,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = rows.isEmpty
        ? 1.0
        : rows
              .map((entry) => entry.value)
              .reduce((a, b) => a > b ? a : b)
              .toDouble();
    final bars = <BarChartGroupData>[
      for (var i = 0; i < rows.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: rows[i].value.toDouble(),
              width: 14,
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
    ];
    return InsightsGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onSurfaceHighlight,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          if (rows.isEmpty)
            Text(
              context.l10n.insightsNoData,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            )
          else ...[
            SizedBox(
              height: 120,
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: maxValue == 0 ? 1 : maxValue * 1.2,
                  barGroups: bars,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (maxValue / 3).clamp(1, 100000),
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.outline.withValues(alpha: 0.35),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= rows.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            '${index + 1}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.label,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          row.value.toString(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: AppColors.surfaceContainerHigh.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: row.value / maxValue,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BreakdownRow {
  final String label;
  final int value;

  const _BreakdownRow(this.label, this.value);
}
