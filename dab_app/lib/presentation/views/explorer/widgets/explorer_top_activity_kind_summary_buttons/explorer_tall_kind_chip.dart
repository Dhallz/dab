import 'package:flutter/material.dart';

import '../../../../core/styles/app_layout.dart';
import '../../models/explorer_activity_kind_summary.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Tall activity-kind count chip for the Explorer calendar header.
class ExplorerTallKindChip extends StatelessWidget {
  final ExplorerActivityKindSummary summary;

  const ExplorerTallKindChip({super.key, required this.summary});

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
