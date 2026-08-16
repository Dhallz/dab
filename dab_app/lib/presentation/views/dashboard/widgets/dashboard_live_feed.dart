import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_icons.dart';
import '../dashboard_notifier.dart';
import '../dashboard_state.dart';
import '../models/dashboard_feed_group.dart';
import '../models/dashboard_feed_mode.dart';
import 'dashboard_grouped_feed.dart';
import 'dashboard_timeline_feed.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Renders the dashboard Live Now feed with archive triage.
/// Dispatches archive/unarchive actions to [DashboardNotifier].
class DashboardLiveFeed extends ConsumerWidget {
  final DashboardState state;
  final EdgeInsetsGeometry padding;

  const DashboardLiveFeed({
    super.key,
    required this.state,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.status == ViewStatus.loading && state.activities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final notifier = ref.read(dashboardNotifierProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final visibleActivities = state.visibleActivities;
    final groups = switch (state.feedMode) {
      DashboardFeedMode.category => state.categoryGroups,
      DashboardFeedMode.provider => state.providerGroups,
      DashboardFeedMode.timeline => const <DashboardFeedGroup>[],
    };
    final showGrouped =
        state.feedMode != DashboardFeedMode.timeline && groups.isNotEmpty;
    final showEmpty =
        !showGrouped &&
        visibleActivities.isEmpty &&
        (state.status != ViewStatus.failure || state.activities.isNotEmpty);

    Widget body;
    if (state.status == ViewStatus.failure && state.activities.isEmpty) {
      body = _FailurePlaceholder(
        message: state.errorMessage,
        fallbackMessage: l10n.dashboardFailedLoadLive,
      );
    } else if (showGrouped) {
      body = DashboardGroupedFeed(
        groups: groups,
        onArchive: (activity) => notifier.requestArchive(activity.id),
        onUnarchive: (activity) => notifier.requestUnarchive(activity.id),
        isFollowing: state.isFollowing,
        onFollow: notifier.follow,
        onUnfollow: notifier.unfollow,
      );
    } else if (showEmpty) {
      body = _EmptyLivePlaceholder(
        showingArchived: state.showArchivedActivities,
        hasAnyActivities: state.activities.isNotEmpty,
        l10n: l10n,
      );
    } else {
      body = DashboardTimelineFeed(
        activities: visibleActivities,
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
          if (state.reconnectNoticeAt != null) ...[
            _ReconnectNoticeBanner(at: state.reconnectNoticeAt!, l10n: l10n),
            const SizedBox(height: 10),
          ],
          Text(
            l10n.dashboardLiveNowTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _ReconnectNoticeBanner extends StatelessWidget {
  final DateTime at;
  final AppLocalizations l10n;

  const _ReconnectNoticeBanner({required this.at, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hh = at.hour.toString().padLeft(2, '0');
    final mm = at.minute.toString().padLeft(2, '0');
    final ss = at.second.toString().padLeft(2, '0');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: Text(
        l10n.dashboardReconnectNotice('$hh:$mm:$ss'),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FailurePlaceholder extends StatelessWidget {
  final String? message;
  final String fallbackMessage;

  const _FailurePlaceholder({this.message, required this.fallbackMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          message ?? fallbackMessage,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _EmptyLivePlaceholder extends StatelessWidget {
  final bool showingArchived;
  final bool hasAnyActivities;
  final AppLocalizations l10n;

  const _EmptyLivePlaceholder({
    required this.showingArchived,
    required this.hasAnyActivities,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final message = (!showingArchived && hasAnyActivities)
        ? l10n.dashboardEmptyLiveCaughtUp
        : l10n.dashboardEmptyLiveNoActivities;
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
