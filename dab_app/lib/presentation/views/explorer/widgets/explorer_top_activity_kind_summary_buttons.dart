import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_layout.dart';
import '../explorer_state.dart';
import '../models/explorer_activity_kind_summary.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Activity-kind count chips in Explorer island bar (left of heat bar).
class ExplorerTopActivityKindSummaryButtons extends StatelessWidget {
  final ExplorerState state;

  const ExplorerTopActivityKindSummaryButtons({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summaries = state.islandActivityKindSummaries(context);

    return Row(
      children: [
        ...summaries.map(
          (ExplorerActivityKindSummary summary) => Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Tooltip(
              message: l10n.activityKindCountTooltip(
                summary.label,
                summary.count,
              ),
              child: Container(
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
