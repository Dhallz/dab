import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/widgets/dab_island_stat.dart';
import 'package:dab_app/presentation/core/widgets/dab_toggle_chip.dart';
import 'package:dab_app/presentation/core/widgets/view_toolbar.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Admin toolbar — system snapshot + refresh; section chips on compact widths.
class AdminIslandBarContent extends ConsumerWidget {
  /// When true (mobile/tablet), section chips replace the stats row.
  final bool showSectionChips;

  const AdminIslandBarContent({super.key, this.showSectionChips = false});

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
    final isIndividual = ref.watch(
      appNotifierProvider.select((s) => s.isIndividualDeployment),
    );
    final cs = Theme.of(context).colorScheme;
    final isLoading = state.status == ViewStatus.loading;

    final refreshButton = IconButton(
      tooltip: l10n.adminIslandRefreshTooltip,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: isLoading ? null : notifier.start,
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(AppIcons.refresh, size: AppLayout.iconMedium),
    );

    if (showSectionChips) {
      return ViewToolbar(
        children: [
          for (final section in adminSectionsFor(isIndividual: isIndividual))
            DabToggleChip(
              label: section.localizedTitle(l10n),
              isSelected: section == state.selectedSection,
              onTap: () => notifier.setSection(section),
            ),
          refreshButton,
        ],
      );
    }

    return ViewToolbar(
      children: [
        DabIslandStat(
          compact: true,
          icon: AppIcons.providers,
          title: l10n.adminIslandProvidersTitle,
          value: '${m.activeProviders} / ${m.totalProviders}',
          tooltip: l10n.adminIslandProvidersTooltip,
        ),
        DabIslandStat(
          compact: true,
          icon: AppIcons.profile,
          title: l10n.adminIslandUsersTitle,
          value: '${m.usersCount}',
          tooltip: l10n.adminIslandUsersTooltip,
        ),
        DabIslandStat(
          compact: true,
          icon: AppIcons.error,
          title: l10n.adminIslandFailedTitle,
          value: '${m.connectionFailed}',
          tooltip: isIndividual
              ? l10n.adminIslandFailedTooltipPersonal
              : l10n.adminIslandFailedTooltip,
          iconColor: m.connectionFailed > 0 ? cs.error : cs.onSurfaceVariant,
        ),
        if (!isIndividual && m.unresolvedIdentities > 0)
          DabIslandStat(
            compact: true,
            icon: AppIcons.warning,
            title: l10n.adminIslandUnresolvedTitle,
            value: '${m.unresolvedIdentities}',
            tooltip: l10n.adminIslandUnresolvedTooltip,
            iconColor: cs.error,
          ),
        refreshButton,
      ],
    );
  }
}
