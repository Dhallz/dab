import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/entities/group/group.dart';
import '../../../../../domain/entities/user/user.dart';
import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../explorer_notifier.dart';
import '../../explorer_state.dart';
import '../../models/directory_type.dart';
import 'create_group_button.dart';
import 'selection_tile.dart';

class DirectoryList extends ConsumerWidget {
  final ExplorerState state;

  const DirectoryList({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(explorerNotifierProvider.notifier);
    final bool isUsers = state.directoryType == DirectoryType.users;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUsers)
          ...state.users.map((u) {
            final isSelected = state.selectedUserIds.contains(u.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: SelectionTile(
                label: u.name,
                isSelected: isSelected,
                avatarUrl: u.avatarUrl,
                iconData: u.avatarUrl == null ? AppIcons.user : null,
                onTap: () => notifier.toggleUser(u.id),
              ),
            );
          })
        else
          ...state.groups.map((g) {
            final isSelected = state.selectedGroupIds.contains(g.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: SelectionTile(
                label: g.name,
                isSelected: isSelected,
                iconData: AppIcons.users,
                trailing: _buildGroupActions(context, ref, g, state.users),
                onTap: () => notifier.toggleGroup(g.id),
              ),
            );
          }),
        if (!isUsers) ...[
          const SizedBox(height: AppSpacing.xs),
          CreateGroupButton(availableUsers: state.users),
        ],
      ],
    );
  }

  Widget _buildGroupActions(
    BuildContext context,
    WidgetRef ref,
    Group group,
    List<User> users,
  ) {
    final notifier = ref.read(explorerNotifierProvider.notifier);
    return PopupMenuButton<_GroupAction>(
      tooltip: context.l10n.explorerGroupActions,
      icon: Icon(AppIcons.settings, size: AppSpacing.s + 2),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _GroupAction.editMembers,
          child: Text(context.l10n.explorerEditGroupMembers),
        ),
        PopupMenuItem(
          value: _GroupAction.rename,
          child: Text(context.l10n.explorerRenameGroup),
        ),
        PopupMenuItem(
          value: _GroupAction.delete,
          child: Text(context.l10n.explorerDeleteGroup),
        ),
      ],
      onSelected: (action) {
        if (action == _GroupAction.editMembers) {
          _showEditMembersDialog(context, ref, group, users);
          return;
        }
        if (action == _GroupAction.rename) {
          _showRenameDialog(context, ref, group);
          return;
        }
        notifier.deleteGroup(group.id);
      },
    );
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    WidgetRef ref,
    Group group,
  ) async {
    final notifier = ref.read(explorerNotifierProvider.notifier);
    final controller = TextEditingController(text: group.name);
    final renamed = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.explorerRenameGroup),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: context.l10n.explorerGroupNamePlaceholder,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.explorerCancel),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, controller.text.trim()),
              child: Text(context.l10n.explorerSave),
            ),
          ],
        );
      },
    );

    final nextName = renamed?.trim() ?? '';
    if (nextName.isEmpty || nextName == group.name) return;
    if (!context.mounted) return;
    notifier.renameGroup(group.id, nextName);
  }

  Future<void> _showEditMembersDialog(
    BuildContext context,
    WidgetRef ref,
    Group group,
    List<User> users,
  ) async {
    final notifier = ref.read(explorerNotifierProvider.notifier);
    final selectedUserIds = group.members.map((member) => member.id).toSet();
    final updatedIds = await showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(context.l10n.explorerEditGroupMembers),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.explorerSelectGroupMembers),
                    const SizedBox(height: AppSpacing.s),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: users.map((user) {
                          final isSelected = selectedUserIds.contains(user.id);
                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: (next) {
                              setDialogState(() {
                                if (next == true) {
                                  selectedUserIds.add(user.id);
                                } else {
                                  selectedUserIds.remove(user.id);
                                }
                              });
                            },
                            title: Text(user.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(context.l10n.explorerCancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(
                    dialogContext,
                    Set<String>.from(selectedUserIds),
                  ),
                  child: Text(context.l10n.explorerSave),
                ),
              ],
            );
          },
        );
      },
    );

    if (updatedIds == null || !context.mounted) return;

    final updatedMembers = users
        .where((user) => updatedIds.contains(user.id))
        .toList();
    notifier.saveGroup(group.copyWith(members: updatedMembers));
  }
}

enum _GroupAction { editMembers, rename, delete }
