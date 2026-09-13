import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/models/directory_selection_mode.dart';
import '../../../../core/widgets/activity_category_checklist.dart';
import '../../../../core/widgets/directory_create_group_button.dart';
import '../../../../core/widgets/directory_group_actions.dart';
import '../../../../core/widgets/directory_panel.dart';
import '../../../../core/widgets/filter_sidebar.dart';
import '../../../../core/widgets/filter_sidebar_section_spec.dart';
import '../../../../core/widgets/provider_filter_checklist.dart';
import '../../explorer_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Explorer composer for [FilterSidebar] — Directory, Activities, Providers.
class ExplorerSidebar extends ConsumerWidget {
  const ExplorerSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      explorerNotifierProvider.select(
        (s) => (
          directoryType: s.directoryType,
          users: s.users,
          groups: s.groups,
          selectedUserIds: s.selectedUserIds,
          selectedGroupIds: s.selectedGroupIds,
          availableActivityCategories: s.availableActivityCategories,
          selectedActivityCategories: s.selectedActivityCategories,
          availableProviders: s.availableProviders,
          selectedProviders: s.selectedProviders,
        ),
      ),
    );
    final state = ref.read(explorerNotifierProvider);
    final notifier = ref.read(explorerNotifierProvider.notifier);

    return FilterSidebar(
      sections: [
        FilterSidebarSectionSpec(
          title: context.l10n.explorerSectionDirectory,
          fillsRemainingSpace: true,
          child: DirectoryPanel(
            showGroups: true,
            selectionMode: DirectorySelectionMode.multi,
            directoryType: state.directoryType,
            users: state.users,
            groups: state.groups,
            selectedUserIds: state.selectedUserIds,
            selectedGroupIds: state.selectedGroupIds,
            onDirectoryTypeChanged: notifier.setDirectoryType,
            onUserTap: notifier.toggleUser,
            onGroupTap: notifier.toggleGroup,
            userSubtitle: (user) {
              final missing = state.selectedProviders
                  .where(
                    (provider) => !user.linkedProviderIds.contains(provider),
                  )
                  .toList();
              if (missing.isEmpty) return null;
              return context.l10n.explorerUserNotConnected(missing.first);
            },
            groupTrailing: (group) => DirectoryGroupActions(
              group: group,
              users: state.users,
              onRename: notifier.renameGroup,
              onSaveMembers: notifier.saveGroup,
              onDelete: notifier.deleteGroup,
            ),
            groupsFooter: DirectoryCreateGroupButton(
              availableUsers: state.users,
              onCreated: notifier.saveGroup,
            ),
          ),
        ),
        FilterSidebarSectionSpec(
          title: context.l10n.explorerSectionActivities,
          child: ActivityCategoryChecklist(
            availableCategories: state.availableActivityCategories,
            selectedCategories: state.selectedActivityCategories,
            onToggle: notifier.toggleActivityCategory,
          ),
        ),
        FilterSidebarSectionSpec(
          title: context.l10n.explorerSectionProviders,
          child: ProviderFilterChecklist(
            availableProviders: state.availableProviders,
            selectedProviders: state.selectedProviders,
            onToggle: notifier.toggleProvider,
          ),
        ),
      ],
    );
  }
}
