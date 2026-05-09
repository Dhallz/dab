import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
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

    final m = state.islandBarModel;

    final providersTile = AdminIslandStatTile(
      icon: Icons.dns_outlined,
      title: 'Providers',
      value: '${m.activeProviders} / ${m.totalProviders}',
      tooltip: 'Active / total providers',
    );
    final unresolvedTile = AdminIslandStatTile(
      icon: AppIcons.warning,
      title: 'Unresolved',
      value: '${m.unresolvedIdentities}',
      tooltip: 'Identities not linked',
      iconColor: m.unresolvedIdentities > 0
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );
    final usersTile = AdminIslandStatTile(
      icon: AppIcons.profile,
      title: 'Users',
      value: '${m.usersCount}',
      tooltip: 'Registered users',
    );
    final okTile = AdminIslandStatTile(
      icon: AppIcons.success,
      title: 'Links OK',
      value: '${m.connectionOk}',
      tooltip: 'Active providers with successful connection test',
      iconColor: Theme.of(context).colorScheme.tertiary,
    );
    final failedTile = AdminIslandStatTile(
      icon: AppIcons.error,
      title: 'Failed',
      value: '${m.connectionFailed}',
      tooltip: 'Connection failures',
      iconColor: m.connectionFailed > 0
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );
    final pendingTile = AdminIslandStatTile(
      icon: AppIcons.info,
      title: 'Pending',
      value: '${m.connectionUnknown}',
      tooltip: 'Untested or in progress',
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
                gap,
                SizedBox(
                  width: AdminIslandBarModel.scrollTileWidth,
                  child: unresolvedTile,
                ),
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
