import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: One row in the Explorer calendar-header activity-kind summary strip.
/// CONTRACT: Immutable POD for UI projection only.
class ExplorerActivityKindSummary {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const ExplorerActivityKindSummary({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}
