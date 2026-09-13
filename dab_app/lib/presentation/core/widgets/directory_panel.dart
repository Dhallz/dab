import 'package:flutter/material.dart';

import '../../../domain/entities/group/group.dart';
import '../../../domain/entities/user/user.dart';
import '../models/directory_selection_mode.dart';
import '../models/directory_type.dart';
import '../styles/app_spacing.dart';
import 'directory_list.dart';
import 'directory_toggle.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Shared Directory body — optional Users/Groups toggle plus the list.
class DirectoryPanel extends StatelessWidget {
  final bool showGroups;
  final DirectorySelectionMode selectionMode;
  final DirectoryType directoryType;
  final List<User> users;
  final List<Group> groups;
  final Set<String> selectedUserIds;
  final String? selectedUserId;
  final Set<String> selectedGroupIds;
  final ValueChanged<DirectoryType>? onDirectoryTypeChanged;
  final ValueChanged<String> onUserTap;
  final ValueChanged<String>? onGroupTap;
  final Widget Function(Group group)? groupTrailing;
  final Widget? groupsFooter;
  final String? Function(User user)? userSubtitle;

  const DirectoryPanel({
    super.key,
    this.showGroups = false,
    this.selectionMode = DirectorySelectionMode.multi,
    this.directoryType = DirectoryType.users,
    required this.users,
    this.groups = const [],
    this.selectedUserIds = const {},
    this.selectedUserId,
    this.selectedGroupIds = const {},
    this.onDirectoryTypeChanged,
    required this.onUserTap,
    this.onGroupTap,
    this.groupTrailing,
    this.groupsFooter,
    this.userSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final type = showGroups ? directoryType : DirectoryType.users;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showGroups && onDirectoryTypeChanged != null) ...[
          DirectoryToggle(
            directoryType: type,
            onChanged: onDirectoryTypeChanged!,
          ),
          const SizedBox(height: AppSpacing.m),
        ],
        DirectoryList(
          directoryType: type,
          selectionMode: selectionMode,
          users: users,
          groups: groups,
          selectedUserIds: selectedUserIds,
          selectedUserId: selectedUserId,
          selectedGroupIds: selectedGroupIds,
          onUserTap: onUserTap,
          onGroupTap: onGroupTap,
          groupTrailing: groupTrailing,
          groupsFooter: groupsFooter,
          userSubtitle: userSubtitle,
        ),
      ],
    );
  }
}
