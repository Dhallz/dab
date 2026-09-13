import 'package:flutter/material.dart';

import '../../../domain/entities/group/group.dart';
import '../../../domain/entities/user/user.dart';
import '../models/directory_selection_mode.dart';
import '../models/directory_type.dart';
import '../styles/app_icons.dart';
import '../styles/app_spacing.dart';
import 'selection_tile.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Directory people or groups as [SelectionTile] rows.
class DirectoryList extends StatelessWidget {
  final DirectoryType directoryType;
  final DirectorySelectionMode selectionMode;
  final List<User> users;
  final List<Group> groups;
  final Set<String> selectedUserIds;
  final String? selectedUserId;
  final Set<String> selectedGroupIds;
  final ValueChanged<String> onUserTap;
  final ValueChanged<String>? onGroupTap;
  final Widget Function(Group group)? groupTrailing;
  final Widget? groupsFooter;
  final String? Function(User user)? userSubtitle;

  const DirectoryList({
    super.key,
    required this.directoryType,
    required this.selectionMode,
    required this.users,
    this.groups = const [],
    this.selectedUserIds = const {},
    this.selectedUserId,
    this.selectedGroupIds = const {},
    required this.onUserTap,
    this.onGroupTap,
    this.groupTrailing,
    this.groupsFooter,
    this.userSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (directoryType == DirectoryType.users) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final user in users)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: SelectionTile(
                label: user.name,
                isSelected: _userSelected(user.id),
                avatarUrl: user.avatarUrl,
                iconData: user.avatarUrl == null ? AppIcons.user : null,
                subtitle: userSubtitle?.call(user),
                onTap: () => onUserTap(user.id),
              ),
            ),
        ],
      );
    }
    final onGroup = onGroupTap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SelectionTile(
              label: group.name,
              isSelected: selectedGroupIds.contains(group.id),
              iconData: AppIcons.users,
              trailing: groupTrailing?.call(group),
              onTap: onGroup == null ? () {} : () => onGroup(group.id),
            ),
          ),
        if (groupsFooter != null) ...[
          const SizedBox(height: AppSpacing.xs),
          groupsFooter!,
        ],
      ],
    );
  }

  bool _userSelected(String userId) {
    if (selectionMode == DirectorySelectionMode.single) {
      return userId == selectedUserId;
    }
    return selectedUserIds.contains(userId);
  }
}
