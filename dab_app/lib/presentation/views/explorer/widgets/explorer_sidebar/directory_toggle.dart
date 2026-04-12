import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_icons.dart';
import '../../explorer_bloc.dart';
import '../../explorer_event.dart';
import '../../models/directory_type.dart';
import 'directory_tile.dart';

class DirectoryToggle extends StatelessWidget {
  final DirectoryType directoryType;

  const DirectoryToggle({super.key, required this.directoryType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DIRECTORY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.outlineVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            DirectoryTile(
              label: 'Users',
              icon: AppIcons.user,
              isSelected: directoryType == DirectoryType.users,
              onTap: () => context.read<ExplorerBloc>().add(
                const ExplorerDirectoryTypeChanged(DirectoryType.users),
              ),
            ),
            const SizedBox(width: 12),
            DirectoryTile(
              label: 'Groups',
              icon: AppIcons.users,
              isSelected: directoryType == DirectoryType.groups,
              onTap: () => context.read<ExplorerBloc>().add(
                const ExplorerDirectoryTypeChanged(DirectoryType.groups),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
