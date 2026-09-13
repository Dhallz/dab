import 'package:flutter/material.dart';

import '../../../../core/styles/app_layout.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../models/explorer_activity_kind_summary.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Compact activity-kind count chip for the Explorer calendar header.
class ExplorerCompactKindChip extends StatelessWidget {
  final ExplorerActivityKindSummary summary;

  const ExplorerCompactKindChip({super.key, required this.summary});

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
