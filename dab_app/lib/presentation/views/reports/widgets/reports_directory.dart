import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/directory_selection_mode.dart';
import '../../../core/widgets/directory_panel.dart';
import '../../../core/widgets/filter_sidebar.dart';
import '../../../core/widgets/filter_sidebar_section_spec.dart';
import '../reports_notifier.dart';
import 'reports_date_list.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Reports sidebar — Directory (managers/admins) plus dated report index.
class ReportsDirectory extends ConsumerWidget {
  const ReportsDirectory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canBrowseTeam = ref.watch(
      reportsNotifierProvider.select((s) => s.canBrowseTeam),
    );
    final users = ref.watch(
      reportsNotifierProvider.select((s) => s.directoryUsers),
    );
    final viewedUserId = ref.watch(
      reportsNotifierProvider.select((s) => s.viewedUserId),
    );
    final dates = ref.watch(
      reportsNotifierProvider.select((s) => s.availableDates),
    );
    final selectedDate = ref.watch(
      reportsNotifierProvider.select((s) => s.date),
    );
    final todayDate = ref.watch(
      reportsNotifierProvider.select((s) => s.todayDate),
    );
    final notifier = ref.read(reportsNotifierProvider.notifier);
    final dateList = ReportsDateList(
      dates: dates,
      selectedDate: selectedDate,
      todayDate: todayDate,
      onSelect: notifier.selectDate,
    );

    return FilterSidebar(
      sections: [
        if (canBrowseTeam)
          FilterSidebarSectionSpec(
            title: context.l10n.explorerSectionDirectory,
            fillsRemainingSpace: true,
            child: DirectoryPanel(
              showGroups: false,
              selectionMode: DirectorySelectionMode.single,
              users: users,
              selectedUserId: viewedUserId,
              onUserTap: notifier.selectUser,
            ),
          ),
        FilterSidebarSectionSpec(
          title: context.l10n.reportsSectionReports,
          fillsRemainingSpace: !canBrowseTeam,
          child: canBrowseTeam
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: SingleChildScrollView(child: dateList),
                )
              : dateList,
        ),
      ],
    );
  }
}
