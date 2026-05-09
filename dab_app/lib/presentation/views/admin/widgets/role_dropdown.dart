import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/entities/user/user_role.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';

class RoleDropdown extends StatelessWidget {
  final User user;
  final AdminNotifier notifier;

  const RoleDropdown({super.key, required this.user, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UserRole>(
          value: user.role,
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.onSurfaceVariantLow,
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
