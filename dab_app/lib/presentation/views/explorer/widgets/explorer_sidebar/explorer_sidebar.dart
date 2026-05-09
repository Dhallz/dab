import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../explorer_notifier.dart';
import '../../explorer_state.dart';
import 'activity_filter_checklist.dart';
import 'directory_list.dart';
import 'directory_toggle.dart';
import 'explorer_sidebar_section.dart';
import 'provider_filter_checklist.dart';

class ExplorerSidebar extends ConsumerStatefulWidget {
  const ExplorerSidebar({super.key});

  @override
  ConsumerState<ExplorerSidebar> createState() => _ExplorerSidebarState();
}

class _ExplorerSidebarState extends ConsumerState<ExplorerSidebar> {
  bool _isDirectoryExpanded = true;
  bool _isActivitiesExpanded = true;
  bool _isProvidersExpanded = true;

  void _toggleDirectory() {
    setState(() => _isDirectoryExpanded = !_isDirectoryExpanded);
  }

  void _toggleActivities() {
    setState(() => _isActivitiesExpanded = !_isActivitiesExpanded);
  }

  void _toggleProviders() {
    setState(() => _isProvidersExpanded = !_isProvidersExpanded);
  }

  List<_SidebarSectionConfig> _buildSections(ExplorerState state) {
    return [
      _SidebarSectionConfig(
        title: context.l10n.explorerSectionDirectory,
        isExpanded: _isDirectoryExpanded,
        onToggle: _toggleDirectory,
        child: Column(
          children: [
            DirectoryToggle(directoryType: state.directoryType),
            const SizedBox(height: AppSpacing.m),
            DirectoryList(state: state),
          ],
        ),
      ),
      _SidebarSectionConfig(
        title: context.l10n.explorerSectionActivities,
        isExpanded: _isActivitiesExpanded,
        onToggle: _toggleActivities,
        child: ActivityFilterChecklist(
          availableCategories: state.availableActivityCategories,
          selectedCategories: state.selectedActivityCategories,
        ),
      ),
      _SidebarSectionConfig(
        title: context.l10n.explorerSectionProviders,
        isExpanded: _isProvidersExpanded,
        onToggle: _toggleProviders,
        child: ProviderFilterChecklist(
          availableProviders: state.availableProviders,
          selectedProviders: state.selectedProviders,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild when directory or filter selections change, not on date/items alone.
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

    final sections = _buildSections(state);
    final directorySection = sections.first;
    final activitiesSection = sections[1];
    final providersSection = sections[2];

    return AppSidebar(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (directorySection.isExpanded)
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: ExplorerSidebarSection(
                      title: directorySection.title,
                      isExpanded: directorySection.isExpanded,
                      onToggle: directorySection.onToggle,
                      child: directorySection.child,
                    ),
                  ),
                ),
              if (!directorySection.isExpanded) ...[
                ExplorerSidebarSection(
                  title: directorySection.title,
                  isExpanded: directorySection.isExpanded,
                  onToggle: directorySection.onToggle,
                  child: directorySection.child,
                ),
                const Expanded(child: SizedBox.shrink()),
              ],
              const SizedBox(height: AppSpacing.l),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExplorerSidebarSection(
                    title: activitiesSection.title,
                    isExpanded: activitiesSection.isExpanded,
                    onToggle: activitiesSection.onToggle,
                    child: activitiesSection.child,
                  ),
                  const SizedBox(height: AppSpacing.l),
                  ExplorerSidebarSection(
                    title: providersSection.title,
                    isExpanded: providersSection.isExpanded,
                    onToggle: providersSection.onToggle,
                    child: providersSection.child,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarSectionConfig {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;

  const _SidebarSectionConfig({
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });
}
