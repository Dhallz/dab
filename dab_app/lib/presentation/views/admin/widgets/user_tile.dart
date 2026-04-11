import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:flutter/material.dart';

import 'role_dropdown.dart';

class UserTile extends StatelessWidget {
  final User user;
  final AdminBloc bloc;

  const UserTile({super.key, required this.user, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.accentIndigo.withValues(alpha: 0.1),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.accentIndigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariantLow,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          RoleDropdown(user: user, bloc: bloc),
        ],
      ),
    );
  }
}
