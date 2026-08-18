import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/widgets/dab_island_stat.dart';
import '../../../core/widgets/dab_toggle_chip.dart';
import '../../../core/widgets/view_toolbar.dart';
import '../dashboard_notifier.dart';
import '../dashboard_state.dart';
import '../models/dashboard_feed_mode.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Dashboard toolbar — feed mode chips, last sync, and archive toggle;
/// counts on compact widths.
class DashboardIslandBarContent extends ConsumerWidget {
  /// When true (mobile), live/archived counts sit in this toolbar.
  final bool showCounts;

  const DashboardIslandBarContent({super.key, this.showCounts = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      dashboardNotifierProvider.select(
        (s) => (
          activities: s.activities,
          showArchived: s.showArchivedActivities,
          lastSyncedAt: s.lastSyncedAt,
          feedMode: s.feedMode,
          follows: s.follows,
        ),
      ),
    );
    final state = ref.read(dashboardNotifierProvider);
    final notifier = ref.read(dashboardNotifierProvider.notifier);
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    final archiveLabel = state.showArchivedActivities
        ? l10n.dashboardArchiveHide
        : state.archivedCount == 0
        ? l10n.dashboardArchiveShow
        : l10n.dashboardArchiveShowCount(state.archivedCount);

    return ViewToolbar(
      children: [
        DabToggleChip(
          label: l10n.dashboardFeedModeTimeline,
          isSelected: state.feedMode == DashboardFeedMode.timeline,
          icon: AppIcons.history,
          onTap: () => notifier.setFeedMode(DashboardFeedMode.timeline),
        ),
        DabToggleChip(
          label: l10n.dashboardFeedModeCategory,
          isSelected: state.feedMode == DashboardFeedMode.category,
          icon: AppIcons.filter,
          onTap: () => notifier.setFeedMode(DashboardFeedMode.category),
        ),
        DabToggleChip(
          label: l10n.dashboardFeedModeProvider,
          isSelected: state.feedMode == DashboardFeedMode.provider,
          icon: AppIcons.providers,
          onTap: () => notifier.setFeedMode(DashboardFeedMode.provider),
        ),
        if (showCounts) ...[
          DabIslandStat(
            compact: true,
            icon: AppIcons.dashboard,
            title: l10n.dashboardIslandDirected,
            value: '${state.directedVisible.length}',
          ),
          DabIslandStat(
            compact: true,
            icon: AppIcons.following,
            title: l10n.dashboardIslandFollowing,
            value: '${state.followedFeed.length}',
          ),
          DabIslandStat(
            compact: true,
            icon: AppIcons.delete,
            title: l10n.dashboardIslandArchived,
            value: '${state.archivedCount}',
          ),
        ],
        Text(
          state.lastSyncedAt == null
              ? l10n.dashboardNoSyncYet
              : l10n.dashboardLastSync(_formatSyncTime(state.lastSyncedAt!)),
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        DabToggleChip(
          label: archiveLabel,
          isSelected: state.showArchivedActivities,
          icon: state.showArchivedActivities
              ? AppIcons.visibilityOff
              : AppIcons.visibility,
          onTap: state.archivedCount == 0 && !state.showArchivedActivities
              ? null
              : notifier.toggleArchivedVisibility,
        ),
      ],
    );
  }

  String _formatSyncTime(DateTime dateTime) {
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mm = dateTime.minute.toString().padLeft(2, '0');
    final ss = dateTime.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}
