import 'package:flutter/material.dart';

import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../dashboard_state.dart';
import 'dab_activity_card.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Renders the dashboard live activity list and state placeholders.
class DashboardLiveFeed extends StatelessWidget {
  final DashboardState state;
  final EdgeInsetsGeometry padding;

  const DashboardLiveFeed({
    super.key,
    required this.state,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    if (state.status == ViewStatus.loading && state.activities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ViewStatus.failure && state.activities.isEmpty) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Failed to load live activities.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.emptyState,
              size: 48,
              color: AppColors.onSurfaceVariantLow.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No live activities yet.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: padding,
      itemCount: state.activities.length,
      itemBuilder: (context, index) {
        final activity = state.activities[index];
        return DabActivityCard(activity: activity);
      },
    );
  }
}
