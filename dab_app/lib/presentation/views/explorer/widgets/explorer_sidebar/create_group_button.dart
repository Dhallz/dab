import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_layout.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../../../core/styles/app_text_styles.dart';
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
      borderRadius: BorderRadius.circular(AppLayout.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppSpacing.xxs,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxs),
              decoration: BoxDecoration(
                color: AppColors.accentIndigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppLayout.radiusSmall - 2),
              ),
              child: Icon(
                AppIcons.add,
                size: AppSpacing.s,
                color: AppColors.accentIndigo,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              context.l10n.explorerCreateGroup,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.accentIndigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
