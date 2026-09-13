import 'package:flutter/material.dart';

import '../../../domain/entities/activity/activity_category.dart';
import '../localization/l10n_extension.dart';
import '../styles/app_icons.dart';
import '../styles/app_spacing.dart';
import 'selection_tile.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Multi-select activity-category tiles for filter sidebars.
class ActivityCategoryChecklist extends StatelessWidget {
  final Set<ActivityCategory> availableCategories;
  final Set<ActivityCategory> selectedCategories;
  final ValueChanged<ActivityCategory> onToggle;

  const ActivityCategoryChecklist({
    super.key,
    required this.availableCategories,
    required this.selectedCategories,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final category in availableCategories)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SelectionTile(
              label: _labelFor(context, category),
              isSelected: selectedCategories.contains(category),
              iconData: _iconFor(category),
              onTap: () => onToggle(category),
            ),
          ),
      ],
    );
  }

  String _labelFor(BuildContext context, ActivityCategory category) {
    return switch (category) {
      ActivityCategory.commit => context.l10n.explorerActivityFilterCommit,
      ActivityCategory.revision => context.l10n.explorerActivityFilterRevision,
      ActivityCategory.task => context.l10n.explorerActivityFilterTask,
      ActivityCategory.message => context.l10n.explorerActivityFilterMessage,
      ActivityCategory.generic => context.l10n.explorerActivityFilterGeneric,
    };
  }

  IconData _iconFor(ActivityCategory category) {
    return switch (category) {
      ActivityCategory.commit => AppIcons.commit,
      ActivityCategory.revision => AppIcons.revision,
      ActivityCategory.task => AppIcons.task,
      ActivityCategory.message => AppIcons.chatMessage,
      ActivityCategory.generic => AppIcons.genericActivity,
    };
  }
}
