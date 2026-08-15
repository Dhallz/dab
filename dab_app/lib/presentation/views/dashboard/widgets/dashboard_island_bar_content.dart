import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/widgets/dab_island_stat.dart';
import '../../../core/widgets/dab_toggle_chip.dart';
import '../dashboard_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Dashboard Island Bar — live/archived counts, last sync, archive toggle.
class DashboardIslandBarContent extends ConsumerWidget {
  const DashboardIslandBarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      dashboardNotifierProvider.select(
        (s) => (
          activities: s.activities,
          showArchived: s.showArchivedActivities,
          lastSyncedAt: s.lastSyncedAt,
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

    return Row(
      children: [
        DabIslandStat(
          icon: AppIcons.dashboard,
          title: l10n.dashboardIslandLive,
          value: '${state.visibleActivities.length}',
        ),
        const SizedBox(width: AppSpacing.m),
        DabIslandStat(
          icon: AppIcons.delete,
          title: l10n.dashboardIslandArchived,
          value: '${state.archivedCount}',
        ),
        const Spacer(),
        Flexible(
          child: Text(
            state.lastSyncedAt == null
                ? l10n.dashboardNoSyncYet
                : l10n.dashboardLastSync(_formatSyncTime(state.lastSyncedAt!)),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: AppSpacing.s),
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
