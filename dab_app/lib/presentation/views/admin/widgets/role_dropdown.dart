import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/entities/user/user_role.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';

class RoleDropdown extends StatelessWidget {
  final User user;
  final AdminNotifier notifier;

  const RoleDropdown({super.key, required this.user, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UserRole>(
          value: user.role,
          dropdownColor: cs.surfaceContainerHigh,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: cs.onSurfaceVariant,
            size: 18,
          ),
          items: UserRole.values.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (newRole) {
            if (newRole != null && newRole != user.role) {
              notifier.updateUserRole(user.id, newRole);
            }
          },
        ),
      ),
    );
  }
}
