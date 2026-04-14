import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/entities/activity/activity_category.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../explorer_bloc.dart';
import '../../explorer_event.dart';
import 'selection_tile.dart';

class ActivityFilterChecklist extends StatelessWidget {
  final Set<ActivityCategory> availableCategories;
  final Set<ActivityCategory> selectedCategories;

  const ActivityFilterChecklist({
    super.key,
    required this.availableCategories,
    required this.selectedCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: availableCategories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: SelectionTile(
            label: _labelFor(context, category),
            isSelected: selectedCategories.contains(category),
            iconData: _iconFor(category),
            onTap: () => context.read<ExplorerBloc>().add(
              ExplorerActivityCategoryToggled(category),
            ),
          ),
        );
      }).toList(),
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
