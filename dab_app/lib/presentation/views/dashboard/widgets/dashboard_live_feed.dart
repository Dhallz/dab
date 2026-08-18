import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/styles/app_icons.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/user/activity_follow.dart';
import '../dashboard_notifier.dart';
import '../dashboard_state.dart';
import '../models/dashboard_feed_group.dart';
import '../models/dashboard_feed_mode.dart';
import 'dashboard_follow_search.dart';
import 'dashboard_following_pins.dart';
import 'dashboard_grouped_feed.dart';
import 'dashboard_timeline_feed.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Renders one Dashboard inbox pane (directed or Follow) with archive
/// triage. Dispatches archive/unarchive actions to [DashboardNotifier].
class DashboardLiveFeed extends ConsumerWidget {
  final DashboardState state;
  final String title;
  final List<Activity> activities;
  final List<DashboardFeedGroup> groups;
  final String emptyCaughtUp;
  final String emptyNone;
  final bool hasAnyInLane;
  final List<ActivityFollow> watchingPins;
  final bool showFollowSearch;
  final EdgeInsetsGeometry padding;

  const DashboardLiveFeed({
    super.key,
    required this.state,
    required this.title,
    required this.activities,
    required this.groups,
    required this.emptyCaughtUp,
    required this.emptyNone,
    required this.hasAnyInLane,
    this.watchingPins = const [],
    this.showFollowSearch = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardNotifierProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final showPins = watchingPins.isNotEmpty;
    final showEmpty = activities.isEmpty && !showPins;
    final showGrouped =
        activities.isNotEmpty &&
        state.feedMode != DashboardFeedMode.timeline &&
        groups.isNotEmpty;

    Widget feedBody;
    if (showGrouped) {
      feedBody = DashboardGroupedFeed(
        groups: groups,
        onArchive: (activity) => notifier.requestArchive(activity.id),
        onUnarchive: (activity) => notifier.requestUnarchive(activity.id),
        isFollowing: state.isFollowing,
        onFollow: notifier.follow,
        onUnfollow: notifier.unfollow,
      );
    } else if (showEmpty) {
      feedBody = _EmptyLivePlaceholder(
        showingArchived: state.showArchivedActivities,
        hasAnyActivities: hasAnyInLane,
        caughtUpMessage: emptyCaughtUp,
        noneMessage: emptyNone,
      );
    } else if (activities.isEmpty) {
      feedBody = const SizedBox.shrink();
    } else {
      feedBody = DashboardTimelineFeed(
        activities: activities,
        onArchive: (activity) => notifier.requestArchive(activity.id),
        onUnarchive: (activity) => notifier.requestUnarchive(activity.id),
        isFollowing: state.isFollowing,
        onFollow: notifier.follow,
        onUnfollow: notifier.unfollow,
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          if (showFollowSearch) ...[
            DashboardFollowSearch(
              state: state,
              onQueryChanged: notifier.setFollowSearchQuery,
              onFollow: notifier.followCandidate,
            ),
            const SizedBox(height: 8),
          ],
          if (showPins)
            DashboardFollowingPins(
              pins: watchingPins,
              onUnfollow: notifier.unfollowPin,
            ),
          Expanded(child: feedBody),
        ],
      ),
    );
  }
}

class _EmptyLivePlaceholder extends StatelessWidget {
  final bool showingArchived;
  final bool hasAnyActivities;
  final String caughtUpMessage;
  final String noneMessage;

  const _EmptyLivePlaceholder({
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
