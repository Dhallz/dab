import 'package:flutter/material.dart';

import '../../../../../domain/entities/activity/activity_category.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../insights_state.dart';
import 'insights_breakdown_card.dart';

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
        final cs = Theme.of(context).colorScheme;
        final isWide = constraints.maxWidth > 920;
        final cards = [
          InsightsBreakdownCard(
            title: context.l10n.insightsBreakdownProviders,
            rows: providerData
                .map((entry) => InsightsBreakdownRow(entry.key, entry.value))
                .toList(),
            color: cs.primary,
          ),
          InsightsBreakdownCard(
            title: context.l10n.insightsBreakdownActivityTypes,
            rows: categoryData
                .map(
                  (entry) => InsightsBreakdownRow(
                    _categoryLabel(context, entry.key),
                    entry.value,
                  ),
                )
                .toList(),
            color: cs.tertiary,
          ),
          InsightsBreakdownCard(
            title: context.l10n.insightsBreakdownTopUsers,
            rows: userData
                .take(6)
                .map(
                  (entry) => InsightsBreakdownRow(
                    userNameById[entry.key] ?? entry.key,
                    entry.value,
                  ),
                )
                .toList(),
            color: cs.secondary,
          ),
        ];

        if (isWide) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: AppSpacing.m),
                Expanded(child: cards[1]),
                const SizedBox(width: AppSpacing.m),
                Expanded(child: cards[2]),
              ],
            ),
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
