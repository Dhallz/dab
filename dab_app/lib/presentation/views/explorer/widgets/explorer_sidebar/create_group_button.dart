import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_colors.dart';
import '../../explorer_bloc.dart';
import '../create_group_dialog.dart';

class CreateGroupButton extends StatelessWidget {
  final List<dynamic> availableUsers;

  const CreateGroupButton({super.key, required this.availableUsers});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) => BlocProvider.value(
            value: context.read<ExplorerBloc>(),
            child: CreateGroupDialog(availableUsers: availableUsers as dynamic),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.accentIndigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 14,
                color: AppColors.accentIndigo,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Create Group',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentIndigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
