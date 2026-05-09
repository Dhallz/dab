import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../explorer_notifier.dart';
import '../../models/directory_type.dart';
import 'directory_tile.dart';

class DirectoryToggle extends ConsumerWidget {
  final DirectoryType directoryType;

  const DirectoryToggle({super.key, required this.directoryType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(explorerNotifierProvider.notifier);
    return Row(
      children: [
        DirectoryTile(
          label: context.l10n.explorerDirectoryUsers,
          icon: AppIcons.user,
          isSelected: directoryType == DirectoryType.users,
          onTap: () => notifier.setDirectoryType(DirectoryType.users),
        ),
        const SizedBox(width: AppSpacing.s),
        DirectoryTile(
          label: context.l10n.explorerDirectoryGroups,
          icon: AppIcons.users,
          isSelected: directoryType == DirectoryType.groups,
          onTap: () => notifier.setDirectoryType(DirectoryType.groups),
        ),
      ],
    );
  }
}
