import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Compact toggle for switching the Dashboard feed between "Hide
/// archived" (default) and "Show archived".
class DashboardArchiveToggle extends StatelessWidget {
  final bool showArchived;
  final int archivedCount;
  final VoidCallback onToggle;

  const DashboardArchiveToggle({
    super.key,
    required this.showArchived,
    required this.archivedCount,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final label = showArchived
        ? 'Hide archived'
        : archivedCount == 0
        ? 'Show archived'
        : 'Show archived ($archivedCount)';

    return TextButton.icon(
      onPressed: archivedCount == 0 && !showArchived ? null : onToggle,
      icon: Icon(
        showArchived
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        size: 18,
      ),
      label: Text(label),
      style: TextButton.styleFrom(foregroundColor: AppColors.onSurfaceVariant),
    );
  }
}
