import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../models/insights_detail_row.dart';
import 'insights_glass_card.dart';

class InsightsDetailsTable extends StatelessWidget {
  final List<InsightsDetailRow> rows;

  const InsightsDetailsTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InsightsGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.insightsDetailsTitle,
            style: AppTextStyles.titleMedium.copyWith(
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          if (rows.isEmpty)
            Text(
              context.l10n.insightsNoData,
              style: AppTextStyles.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            )
          else
            ...rows
                .take(12)
                .map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_kindLabel(context, row.kind)}: ${row.label}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        Text(
                          row.count.toString(),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        SizedBox(
                          width: 48,
                          child: Text(
                            row.share,
                            textAlign: TextAlign.right,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
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

  String _kindLabel(BuildContext context, InsightsDetailRowKind kind) {
    switch (kind) {
      case InsightsDetailRowKind.provider:
        return context.l10n.insightsProvidersSectionTitle;
      case InsightsDetailRowKind.activityType:
        return context.l10n.insightsActivityTypesSectionTitle;
      case InsightsDetailRowKind.user:
        return context.l10n.insightsUsersSectionTitle;
    }
  }
}
