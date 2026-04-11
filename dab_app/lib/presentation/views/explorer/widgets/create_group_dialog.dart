import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/group/group.dart';
import '../../../../domain/entities/group/group_type.dart';
import '../../../../domain/entities/user/user.dart';
import '../explorer_bloc.dart';
import '../explorer_event.dart';

class CreateGroupDialog extends StatefulWidget {
  final List<User> availableUsers;
  const CreateGroupDialog({super.key, required this.availableUsers});

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final _nameController = TextEditingController();
  final Set<String> _selectedUserIds = {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Group',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'GROUP NAME',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'e.g. Mobile Team',
                hintStyle: const TextStyle(color: Color(0xFF475569)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'SELECT MEMBERS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 13,
                      ),
                    ),
                    secondary: user.avatarUrl != null
                        ? CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(user.avatarUrl!),
                          )
                        : null,
                    activeColor: const Color(0xFF4245F0),
                    checkColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
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
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _onCreate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4245F0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Create Group'),
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

    context.read<ExplorerBloc>().add(ExplorerGroupSaved(group));
    Navigator.pop(context);
  }
}
