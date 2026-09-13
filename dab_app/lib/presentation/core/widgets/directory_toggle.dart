import 'package:flutter/material.dart';

import '../localization/l10n_extension.dart';
import '../models/directory_type.dart';
import '../styles/app_icons.dart';
import '../styles/app_spacing.dart';
import 'directory_tile.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Users / Groups switch at the top of a Directory.
class DirectoryToggle extends StatelessWidget {
  final DirectoryType directoryType;
  final ValueChanged<DirectoryType> onChanged;

  const DirectoryToggle({
    super.key,
    required this.directoryType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DirectoryTile(
          label: context.l10n.explorerDirectoryUsers,
          icon: AppIcons.user,
          isSelected: directoryType == DirectoryType.users,
          onTap: () => onChanged(DirectoryType.users),
        ),
        const SizedBox(width: AppSpacing.s),
        DirectoryTile(
          label: context.l10n.explorerDirectoryGroups,
          icon: AppIcons.users,
          isSelected: directoryType == DirectoryType.groups,
          onTap: () => onChanged(DirectoryType.groups),
        ),
      ],
    );
  }
}
