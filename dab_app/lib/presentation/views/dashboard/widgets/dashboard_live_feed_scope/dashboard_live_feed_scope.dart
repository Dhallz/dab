import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/entities/activity/activity.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/models/view_status.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../dashboard_notifier.dart';
import '../../dashboard_state.dart';
import '../../models/dashboard_feed_group.dart';
import '../../models/dashboard_feed_mode.dart';
import '../dashboard_live_feed/dashboard_live_feed.dart';
import 'dashboard_failure_placeholder.dart';
import 'dashboard_reconnect_notice_banner.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Subscribes to dashboard feed-relevant state and lays out both inbox
/// panes. Desktop is a 2:1 side-by-side split; mobile stacks Directed over a
/// shorter Following strip. Separation is whitespace, not a divider.
class DashboardLiveFeedScope extends ConsumerWidget {
  final EdgeInsetsGeometry padding;
  final Axis axis;

  const DashboardLiveFeedScope({
    super.key,
    required this.padding,
    this.axis = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      dashboardNotifierProvider.select(
        (s) => (
          status: s.status,
          activities: s.activities,
          showArchivedActivities: s.showArchivedActivities,
          feedMode: s.feedMode,
          providerHealth: s.providerHealth,
          reconnectNoticeAt: s.reconnectNoticeAt,
          errorMessage: s.errorMessage,
          followedObjectRefs: s.followedObjectRefs,
          follows: s.follows,
          followSearchQuery: s.followSearchQuery,
          followCandidates: s.followCandidates,
          followSearchStatus: s.followSearchStatus,
        ),
      ),
    );
    final state = ref.read(dashboardNotifierProvider);
    final l10n = context.l10n;

    if (state.status == ViewStatus.loading && state.activities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget panes;
    if (state.status == ViewStatus.failure && state.activities.isEmpty) {
      panes = DashboardFailurePlaceholder(
        message: state.errorMessage,
        fallbackMessage: l10n.dashboardFailedLoadLive,
      );
    } else {
      final directed = state.directedVisible;
      final followed = state.followedFeed;
      final gap = axis == Axis.horizontal
          ? const SizedBox(width: AppSpacing.sectionGap)
          : const SizedBox(height: AppSpacing.sectionGap);
      panes = Flex(
        direction: axis,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: DashboardLiveFeed(
              state: state,
              title: l10n.dashboardDirectedTitle,
              activities: directed,
              groups: _groupsFor(state, directed),
              emptyCaughtUp: l10n.dashboardEmptyDirectedCaughtUp,
              emptyNone: l10n.dashboardEmptyDirectedNone,
              hasAnyInLane: state.activities.any((a) => !a.isFollowLane),
            ),
          ),
          gap,
          Expanded(
            flex: 1,
            child: DashboardLiveFeed(
              state: state,
              title: l10n.dashboardFollowingTitle,
              activities: followed,
              groups: _groupsFor(state, followed),
              emptyCaughtUp: l10n.dashboardEmptyFollowingCaughtUp,
              emptyNone: l10n.dashboardEmptyFollowingNone,
              hasAnyInLane: state.activities.any((a) => a.isFollowLane),
              showFollowSearch: true,
              compact: true,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.reconnectNoticeAt != null) ...[
            DashboardReconnectNoticeBanner(
              at: state.reconnectNoticeAt!,
              l10n: l10n,
            ),
            const SizedBox(height: 10),
          ],
          Expanded(child: panes),
        ],
      ),
    );
  }

  List<DashboardFeedGroup> _groupsFor(
    DashboardState state,
    List<Activity> activities,
  ) {
    return switch (state.feedMode) {
      DashboardFeedMode.category => state.categoryGroupsFor(activities),
      DashboardFeedMode.provider => state.providerGroupsFor(activities),
      DashboardFeedMode.timeline => const <DashboardFeedGroup>[],
    };
  }
}
