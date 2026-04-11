import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/admin_island_bar_model.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_refresh_tile.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_section_divider.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_stat_tile.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Admin body for [IslandBar] — system snapshot, provider connection health, refresh.
class AdminIslandBarContent extends StatelessWidget {
  const AdminIslandBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<AdminBloc, AdminState>(
      listenWhen: (previous, current) => false,
      listener: (context, state, bloc) {},
      buildWhen: (previous, current) =>
          previous.configs != current.configs ||
          previous.identities != current.identities ||
          previous.users != current.users ||
          previous.connectionStatuses != current.connectionStatuses ||
          previous.status != current.status,
      builder: (context, state, bloc) {
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
              ? AppColors.error
              : AppColors.onSurfaceVariant,
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
          iconColor: AppColors.tertiary,
        );
        final failedTile = AdminIslandStatTile(
          icon: AppIcons.error,
          title: 'Failed',
          value: '${m.connectionFailed}',
          tooltip: 'Connection failures',
          iconColor: m.connectionFailed > 0
              ? AppColors.error
              : AppColors.onSurfaceVariant,
        );
        final pendingTile = AdminIslandStatTile(
          icon: AppIcons.info,
          title: 'Pending',
          value: '${m.connectionUnknown}',
          tooltip: 'Untested or in progress',
        );
        final refreshTile = AdminIslandRefreshTile(
          loading: state.status == ViewStatus.loading,
          onPressed: state.status == ViewStatus.loading
              ? null
              : () => bloc.add(const AdminStarted()),
        );

        final gap = SizedBox(width: AppSpacing.s);
        const divider = AdminIslandSectionDivider();

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >=
                AdminIslandBarModel.expandBreakpointWidth) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: providersTile),
                  gap,
                  Expanded(child: unresolvedTile),
                  gap,
                  Expanded(child: usersTile),
                  gap,
                  divider,
                  gap,
                  Expanded(child: okTile),
                  gap,
                  Expanded(child: failedTile),
                  gap,
                  Expanded(child: pendingTile),
                  gap,
                  SizedBox(
                    width: AdminIslandBarModel.refreshTileWidth,
                    child: refreshTile,
                  ),
                ],
              );
            }

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
      },
    );
  }
}
