import 'package:flutter/material.dart';

import '../../../../core/styles/app_icons.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Empty-state copy for a dashboard inbox pane.
class DashboardEmptyLivePlaceholder extends StatelessWidget {
  final bool showingArchived;
  final bool hasAnyActivities;
  final String caughtUpMessage;
  final String noneMessage;

  const DashboardEmptyLivePlaceholder({
    super.key,
    required this.showingArchived,
    required this.hasAnyActivities,
    required this.caughtUpMessage,
    required this.noneMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final message = (!showingArchived && hasAnyActivities)
        ? caughtUpMessage
        : noneMessage;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.emptyState,
              size: 48,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
