import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/provider_styles.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../insights_state.dart';
import 'insights_glass_card.dart';

class InsightsTrendChart extends StatelessWidget {
  final InsightsState state;

  const InsightsTrendChart({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final days = state.dailyCounts.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    final dayIndex = {for (var i = 0; i < days.length; i++) days[i]: i};
    final providerCountsByDay = <String, Map<DateTime, int>>{};
    for (final activity in state.activities) {
      final provider = activity.provider.name;
      final day = DateTime(
        activity.createdAt.year,
        activity.createdAt.month,
        activity.createdAt.day,
      );
      if (!dayIndex.containsKey(day)) {
        continue;
      }
      final providerCounts = providerCountsByDay.putIfAbsent(
        provider,
        () => {},
      );
      providerCounts.update(day, (value) => value + 1, ifAbsent: () => 1);
    }
    final providerKeys = providerCountsByDay.keys.toList()..sort();
    final providerStyles =
        Theme.of(context).extension<ProviderStyles>() ?? ProviderStyles.dark();
    final cs = Theme.of(context).colorScheme;
    final series = providerKeys.map((provider) {
      final spots = <FlSpot>[
        for (final day in days)
          FlSpot(
            dayIndex[day]!.toDouble(),
            (providerCountsByDay[provider]?[day] ?? 0).toDouble(),
          ),
      ];
      return _ProviderSeries(
        provider: provider,
        color: providerStyles.styleOf(provider).brandColor,
        spots: spots,
      );
    }).toList();
    final maxY = series.isEmpty
        ? 1.0
        : series
              .expand((item) => item.spots)
              .map((spot) => spot.y)
              .fold<double>(1, (max, value) => value > max ? value : max);
    return InsightsGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.insightsTrendTitle,
            style: AppTextStyles.titleMedium.copyWith(
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          if (series.isNotEmpty)
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.xs,
              children: series
                  .map(
                    (item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          item.provider,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          if (series.isNotEmpty) const SizedBox(height: AppSpacing.s),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: days.isEmpty ? 1 : (days.length - 1).toDouble(),
                minY: 0,
                maxY: maxY == 0 ? 1 : maxY * 1.2,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY / 4).clamp(1, 100000),
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: cs.outline.withValues(alpha: 0.35),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: (maxY / 4).clamp(1, 100000),
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  if (series.isEmpty)
                    LineChartBarData(
                      spots: const [FlSpot(0, 0)],
                      isCurved: true,
                      color: cs.primary,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            cs.primary.withValues(alpha: 0.2),
                            cs.primary.withValues(alpha: 0.01),
                          ],
                        ),
                      ),
                    ),
                  ...series.map(
                    (item) => LineChartBarData(
                      spots: item.spots,
                      isCurved: true,
                      color: item.color,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                          radius: 2.5,
                          color: item.color,
                          strokeColor: cs.surface,
                          strokeWidth: 1,
                        ),
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderSeries {
  final String provider;
  final Color color;
  final List<FlSpot> spots;

  const _ProviderSeries({
    required this.provider,
    required this.color,
    required this.spots,
  });
}
