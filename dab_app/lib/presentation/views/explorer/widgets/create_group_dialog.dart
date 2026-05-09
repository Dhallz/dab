import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../../domain/entities/group/group.dart';
import '../../../../domain/entities/group/group_type.dart';
import '../../../../domain/entities/user/user.dart';
import '../explorer_notifier.dart';

class CreateGroupDialog extends ConsumerStatefulWidget {
  final List<User> availableUsers;
  const CreateGroupDialog({super.key, required this.availableUsers});

  @override
  ConsumerState<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends ConsumerState<CreateGroupDialog> {
  final _nameController = TextEditingController();
  final Set<String> _selectedUserIds = {};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.explorerCreateNewGroupTitle,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.explorerGroupNameSectionLabel,
              style: textTheme.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: scheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              autofocus: true,
              style: textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: l10n.explorerGroupNameHintExample,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.explorerSelectMembersSectionLabel,
              style: textTheme.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: scheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.availableUsers.length,
                itemBuilder: (context, index) {
                  final user = widget.availableUsers[index];
                  final isSelected = _selectedUserIds.contains(user.id);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedUserIds.add(user.id);
                        } else {
                          _selectedUserIds.remove(user.id);
                        }
                      });
                    },
                    title: Text(
                      user.name,
                      style: textTheme.bodySmall,
                    ),
                    secondary: user.avatarUrl != null
                        ? CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(user.avatarUrl!),
                          )
                        : null,
                    activeColor: scheme.primary,
                    checkColor: scheme.onPrimary,
                    side: BorderSide(color: scheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.explorerCancel),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _onCreate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(l10n.explorerCreateGroupSubmit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCreate() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final members = widget.availableUsers
        .where((u) => _selectedUserIds.contains(u.id))
        .toList();

    final group = Group(
      id: '', // Backend will generate UUID if empty
      name: name,
      type: GroupType.custom,
      members: members,
    );

    ref.read(explorerNotifierProvider.notifier).saveGroup(group);
    Navigator.pop(context);
  }
}
