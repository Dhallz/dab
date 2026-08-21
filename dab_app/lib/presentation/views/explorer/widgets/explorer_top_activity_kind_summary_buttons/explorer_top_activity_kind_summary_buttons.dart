import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../explorer_state.dart';
import '../../models/explorer_activity_kind_summary.dart';
import 'explorer_compact_kind_chip.dart';
import 'explorer_tall_kind_chip.dart';

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
                  ? ExplorerCompactKindChip(summary: summary)
                  : ExplorerTallKindChip(summary: summary),
            ),
          ),
        ),
      ],
    );
  }
}
