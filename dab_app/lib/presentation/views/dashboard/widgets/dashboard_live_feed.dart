import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../dashboard_bloc.dart';
import '../dashboard_event.dart';
import '../dashboard_state.dart';
import 'dab_activity_card.dart';
import 'dashboard_archive_toggle.dart';
import 'dashboard_banner_widget.dart';
import 'upcoming_soon_section.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Renders the dashboard body — Upcoming Soon section, Live Now header
/// with archive visibility toggle, and the live activity list with triage
/// actions. Dispatches archive/unarchive/toggle events back to the bloc.
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

    final bloc = context.read<DashboardBloc>();
    final theme = Theme.of(context);
    final visibleActivities = state.visibleActivities;

    return ListView(
      padding: padding,
      children: [
        if (state.activeBanner != null) ...[
          DashboardBannerWidget(
            banner: state.activeBanner!,
            onDismiss: () => bloc.add(const DashboardBannerDismissed()),
          ),
          const SizedBox(height: 12),
        ],
        UpcomingSoonSection(events: state.upcomingEvents),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Live Now',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            DashboardArchiveToggle(
              showArchived: state.showArchivedActivities,
              archivedCount: state.archivedCount,
              onToggle: () => bloc.add(
                const DashboardArchivedVisibilityToggled(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.status == ViewStatus.failure &&
            state.activities.isEmpty)
          _FailurePlaceholder(message: state.errorMessage)
        else if (visibleActivities.isEmpty)
          _EmptyLivePlaceholder(
            showingArchived: state.showArchivedActivities,
            hasAnyActivities: state.activities.isNotEmpty,
          )
        else
          ...visibleActivities.map(
            (activity) => DabActivityCard(
              activity: activity,
              onArchive: activity.archived
                  ? null
                  : () => bloc.add(
                        DashboardArchiveActivityRequested(activity.id),
                      ),
              onUnarchive: activity.archived
                  ? () => bloc.add(
                        DashboardUnarchiveActivityRequested(activity.id),
                      )
                  : null,
            ),
          ),
      ],
    );
  }
}

class _FailurePlaceholder extends StatelessWidget {
  final String? message;
  const _FailurePlaceholder({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          message ?? 'Failed to load live activities.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _EmptyLivePlaceholder extends StatelessWidget {
  final bool showingArchived;
  final bool hasAnyActivities;
  const _EmptyLivePlaceholder({
    required this.showingArchived,
    required this.hasAnyActivities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = (!showingArchived && hasAnyActivities)
        ? 'All caught up — enable "Show archived" to review prior items.'
        : 'No live activities yet.';
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
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
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
