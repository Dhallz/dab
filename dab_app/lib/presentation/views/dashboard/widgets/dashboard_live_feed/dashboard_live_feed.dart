import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/entities/activity/activity.dart';
import '../../dashboard_notifier.dart';
import '../../dashboard_state.dart';
import '../../models/dashboard_feed_group.dart';
import '../../models/dashboard_feed_mode.dart';
import '../dashboard_follow_search/dashboard_follow_search.dart';
import '../dashboard_grouped_feed.dart';
import '../dashboard_timeline_feed.dart';
import 'dashboard_empty_live_placeholder.dart';

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
  final bool showFollowSearch;
  final bool compact;
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
    this.showFollowSearch = false,
    this.compact = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardNotifierProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final showEmpty = activities.isEmpty;
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
        compact: compact,
      );
    } else if (showEmpty) {
      feedBody = DashboardEmptyLivePlaceholder(
        showingArchived: state.showArchivedActivities,
        hasAnyActivities: hasAnyInLane,
        caughtUpMessage: emptyCaughtUp,
        noneMessage: emptyNone,
      );
    } else {
      feedBody = DashboardTimelineFeed(
        activities: activities,
        onArchive: (activity) => notifier.requestArchive(activity.id),
        onUnarchive: (activity) => notifier.requestUnarchive(activity.id),
        isFollowing: state.isFollowing,
        onFollow: notifier.follow,
        onUnfollow: notifier.unfollow,
        compact: compact,
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
          Expanded(child: feedBody),
        ],
      ),
    );
  }
}
