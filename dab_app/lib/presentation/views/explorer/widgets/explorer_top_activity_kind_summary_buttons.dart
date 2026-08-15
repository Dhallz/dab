import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../explorer_state.dart';
import '../models/explorer_activity_kind_summary.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Activity-kind count chips in the Explorer calendar header (left of heat bar).
class ExplorerTopActivityKindSummaryButtons extends StatelessWidget {
  final ExplorerState state;
  final bool compact;

  const ExplorerTopActivityKindSummaryButtons({
    super.key,
    required this.state,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summaries = state.islandActivityKindSummaries(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...summaries.map(
          (ExplorerActivityKindSummary summary) => Padding(
            padding: EdgeInsets.only(right: compact ? AppSpacing.xs : 14),
            child: Tooltip(
              message: l10n.activityKindCountTooltip(
                summary.label,
                summary.count,
              ),
              child: compact
                  ? _CompactKindChip(summary: summary)
                  : _TallKindChip(summary: summary),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactKindChip extends StatelessWidget {
  final ExplorerActivityKindSummary summary;

  const _CompactKindChip({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: summary.color.withValues(
          alpha: summary.count == 0 ? 0.04 : 0.08,
        ),
        borderRadius: BorderRadius.circular(AppLayout.radiusSmall),
        border: Border.all(
          color: summary.color.withValues(
            alpha: summary.count == 0 ? 0.16 : 0.25,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(summary.icon, size: AppLayout.iconSmall, color: summary.color),
          const SizedBox(width: 6),
          Text(
            '${summary.count}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: summary.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TallKindChip extends StatelessWidget {
  final ExplorerActivityKindSummary summary;

  const _TallKindChip({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: summary.color.withValues(
          alpha: summary.count == 0 ? 0.04 : 0.08,
        ),
        borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
        border: Border.all(
          color: summary.color.withValues(
            alpha: summary.count == 0 ? 0.16 : 0.25,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(summary.icon, size: 13, color: summary.color),
          const SizedBox(height: 3),
          Text(
            '${summary.count}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: summary.color,
            ),
          ),
        ],
      ),
    );
  }
}
