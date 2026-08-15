import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/core/widgets/dab_island_stat.dart';
import 'package:dab_app/presentation/core/widgets/dab_toggle_chip.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/admin_island_bar_model.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_refresh_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Admin Island Bar — system snapshot + refresh; section chips on compact widths.
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
          selectedSection: s.selectedSection,
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
    final cs = Theme.of(context).colorScheme;

    final providersStat = DabIslandStat(
      icon: AppIcons.providers,
      title: l10n.adminIslandProvidersTitle,
      value: '${m.activeProviders} / ${m.totalProviders}',
      tooltip: l10n.adminIslandProvidersTooltip,
    );
    final usersStat = DabIslandStat(
      icon: AppIcons.profile,
      title: l10n.adminIslandUsersTitle,
      value: '${m.usersCount}',
      tooltip: l10n.adminIslandUsersTooltip,
    );
    final failedStat = DabIslandStat(
      icon: AppIcons.error,
      title: l10n.adminIslandFailedTitle,
      value: '${m.connectionFailed}',
      tooltip: isPersonal
          ? l10n.adminIslandFailedTooltipPersonal
          : l10n.adminIslandFailedTooltip,
      iconColor: m.connectionFailed > 0 ? cs.error : cs.onSurfaceVariant,
    );
    final unresolvedStat = DabIslandStat(
      icon: AppIcons.warning,
      title: l10n.adminIslandUnresolvedTitle,
      value: '${m.unresolvedIdentities}',
      tooltip: l10n.adminIslandUnresolvedTooltip,
      iconColor: m.unresolvedIdentities > 0 ? cs.error : cs.onSurfaceVariant,
    );
    final refreshTile = AdminIslandRefreshTile(
      loading: state.status == ViewStatus.loading,
      onPressed: state.status == ViewStatus.loading ? null : notifier.start,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxWidth < AdminIslandBarModel.expandBreakpointWidth;
        if (compact) {
          return Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final section in adminSectionsFor(
                        isPersonal: isPersonal,
                      )) ...[
                        DabToggleChip(
                          label: section.localizedTitle(l10n),
                          isSelected: section == state.selectedSection,
                          onTap: () => notifier.setSection(section),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: AdminIslandBarModel.refreshTileWidth,
                child: refreshTile,
              ),
            ],
          );
        }

        return Row(
          children: [
            providersStat,
            const SizedBox(width: AppSpacing.m),
            usersStat,
            const SizedBox(width: AppSpacing.m),
            failedStat,
            if (!isPersonal && m.unresolvedIdentities > 0) ...[
              const SizedBox(width: AppSpacing.m),
              unresolvedStat,
            ],
            const Spacer(),
            refreshTile,
          ],
        );
      },
    );
  }
}
