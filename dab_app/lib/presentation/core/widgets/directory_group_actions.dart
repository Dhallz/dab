import 'package:flutter/material.dart';

import '../../../domain/entities/group/group.dart';
import '../../../domain/entities/user/user.dart';
import '../localization/l10n_extension.dart';
import '../styles/app_icons.dart';
import '../styles/app_spacing.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Overflow menu to rename, edit members, or delete a Directory group.
class DirectoryGroupActions extends StatelessWidget {
  final Group group;
  final List<User> users;
  final void Function(String groupId, String name) onRename;
  final void Function(Group group) onSaveMembers;
  final void Function(String groupId) onDelete;

  const DirectoryGroupActions({
    super.key,
    required this.group,
    required this.users,
    required this.onRename,
    required this.onSaveMembers,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_DirectoryGroupAction>(
      tooltip: context.l10n.explorerGroupActions,
      icon: Icon(AppIcons.settings, size: AppSpacing.s + 2),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _DirectoryGroupAction.editMembers,
          child: Text(context.l10n.explorerEditGroupMembers),
        ),
        PopupMenuItem(
          value: _DirectoryGroupAction.rename,
          child: Text(context.l10n.explorerRenameGroup),
        ),
        PopupMenuItem(
          value: _DirectoryGroupAction.delete,
          child: Text(context.l10n.explorerDeleteGroup),
        ),
      ],
      onSelected: (action) {
        switch (action) {
          case _DirectoryGroupAction.editMembers:
            _showEditMembersDialog(context);
          case _DirectoryGroupAction.rename:
            _showRenameDialog(context);
          case _DirectoryGroupAction.delete:
            onDelete(group.id);
        }
      },
    );
  }

  Future<void> _showRenameDialog(BuildContext context) async {
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
    controller.dispose();
    final nextName = renamed?.trim() ?? '';
    if (nextName.isEmpty || nextName == group.name) return;
    if (!context.mounted) return;
    onRename(group.id, nextName);
  }

  Future<void> _showEditMembersDialog(BuildContext context) async {
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
    onSaveMembers(group.copyWith(members: updatedMembers));
  }
}

enum _DirectoryGroupAction { editMembers, rename, delete }
