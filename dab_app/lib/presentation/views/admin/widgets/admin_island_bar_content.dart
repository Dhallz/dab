import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/admin_island_bar_model.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_refresh_tile.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_section_divider.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_stat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Admin body for [IslandBar] — system snapshot, provider connection health, refresh.
class AdminIslandBarContent extends ConsumerWidget {
  const AdminIslandBarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      adminNotifierProvider.select(
        (s) => (
          status: s.status,
          configs: s.configs,
          identities: s.identities,
          users: s.users,
          connectionStatuses: s.connectionStatuses,
        ),
      ),
    );
    final state = ref.read(adminNotifierProvider);
    final notifier = ref.read(adminNotifierProvider.notifier);
    final l10n = context.l10n;

    final m = state.islandBarModel;

    final isPersonal = ref.watch(
      appNotifierProvider.select((s) => s.isPersonalDeployment),
    );
    final providersTile = AdminIslandStatTile(
      icon: Icons.dns_outlined,
      title: l10n.adminIslandProvidersTitle,
      value: '${m.activeProviders} / ${m.totalProviders}',
      tooltip: l10n.adminIslandProvidersTooltip,
    );
    final unresolvedTile = AdminIslandStatTile(
      icon: AppIcons.warning,
      title: l10n.adminIslandUnresolvedTitle,
      value: '${m.unresolvedIdentities}',
      tooltip: l10n.adminIslandUnresolvedTooltip,
      iconColor: m.unresolvedIdentities > 0
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );
    final usersTile = AdminIslandStatTile(
      icon: AppIcons.profile,
      title: l10n.adminIslandUsersTitle,
      value: '${m.usersCount}',
      tooltip: l10n.adminIslandUsersTooltip,
    );
    final okTile = AdminIslandStatTile(
      icon: AppIcons.success,
      title: l10n.adminIslandLinksOkTitle,
      value: '${m.connectionOk}',
      tooltip: isPersonal
          ? l10n.adminIslandLinksOkTooltipPersonal
          : l10n.adminIslandLinksOkTooltip,
      iconColor: Theme.of(context).colorScheme.tertiary,
    );
    final failedTile = AdminIslandStatTile(
      icon: AppIcons.error,
      title: l10n.adminIslandFailedTitle,
      value: '${m.connectionFailed}',
      tooltip: isPersonal
          ? l10n.adminIslandFailedTooltipPersonal
          : l10n.adminIslandFailedTooltip,
      iconColor: m.connectionFailed > 0
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );
    final pendingTile = AdminIslandStatTile(
      icon: AppIcons.info,
      title: l10n.adminIslandPendingTitle,
      value: '${m.connectionUnknown}',
      tooltip: l10n.adminIslandPendingTooltip,
    );
    final refreshTile = AdminIslandRefreshTile(
      loading: state.status == ViewStatus.loading,
      onPressed: state.status == ViewStatus.loading ? null : notifier.start,
    );

    const divider = AdminIslandSectionDivider();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AdminIslandBarModel.expandBreakpointWidth) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DesktopIslandSlot(
                child: SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: providersTile,
                ),
              ),
              if (!isPersonal)
                _DesktopIslandSlot(
                  child: SizedBox(
                    width: AdminIslandBarModel.scrollTileWidth,
                    child: unresolvedTile,
                  ),
                ),
              _DesktopIslandSlot(
                child: SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: usersTile,
                ),
              ),
              const _DesktopIslandSlot(
                child: SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: divider,
                ),
              ),
              _DesktopIslandSlot(
                child: SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: okTile,
                ),
              ),
              _DesktopIslandSlot(
                child: SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: failedTile,
                ),
              ),
              _DesktopIslandSlot(
                child: SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: pendingTile,
                ),
              ),
              _DesktopIslandSlot(
                child: SizedBox(
                  width: AdminIslandBarModel.refreshTileWidth,
                  child: refreshTile,
                ),
              ),
            ],
          );
        }

        const gap = SizedBox(width: 10);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: constraints.maxHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: providersTile,
                ),
                if (!isPersonal) ...[
                  gap,
                  SizedBox(
                    width: AdminIslandBarModel.scrollTileWidth,
                    child: unresolvedTile,
                  ),
                ],
                gap,
                SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: usersTile,
                ),
                gap,
                divider,
                gap,
                SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: okTile,
                ),
                gap,
                SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: failedTile,
                ),
                gap,
                SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: pendingTile,
                ),
                gap,
                SizedBox(
                  width: AdminIslandBarModel.refreshTileWidth,
                  child: refreshTile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DesktopIslandSlot extends StatelessWidget {
  final Widget child;

  const _DesktopIslandSlot({required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: child));
  }
}
