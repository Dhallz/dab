import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../explorer_bloc.dart';
import '../../explorer_event.dart';
import '../../models/directory_type.dart';
import 'directory_tile.dart';

class DirectoryToggle extends StatelessWidget {
  final DirectoryType directoryType;

  const DirectoryToggle({super.key, required this.directoryType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DirectoryTile(
          label: context.l10n.explorerDirectoryUsers,
          icon: AppIcons.user,
          isSelected: directoryType == DirectoryType.users,
          onTap: () => context.read<ExplorerBloc>().add(
            const ExplorerDirectoryTypeChanged(DirectoryType.users),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        DirectoryTile(
          label: context.l10n.explorerDirectoryGroups,
          icon: AppIcons.users,
          isSelected: directoryType == DirectoryType.groups,
          onTap: () => context.read<ExplorerBloc>().add(
            const ExplorerDirectoryTypeChanged(DirectoryType.groups),
          ),
        ),
      ],
    );
  }
}
