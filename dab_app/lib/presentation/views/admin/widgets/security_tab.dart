import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:flutter/material.dart';

import 'bootstrap_status_card.dart';
import 'user_tile.dart';

class SecurityTab extends StatelessWidget {
  final List<User> users;
  final AdminBloc bloc;

  const SecurityTab({super.key, required this.users, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BootstrapStatusCard(),
        const SizedBox(height: 32),
        const Text(
          'USER MANAGEMENT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceVariantLow,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child:
              users.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserTile(user: user, bloc: bloc);
                    },
                  ),
        ),
      ],
    );
  }
}
