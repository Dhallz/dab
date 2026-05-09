import 'package:dab_app/domain/entities/user/user.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_layout.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../create_group_dialog.dart';

class CreateGroupButton extends StatelessWidget {
  final List<User> availableUsers;

  const CreateGroupButton({super.key, required this.availableUsers});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (dialogContext) =>
              CreateGroupDialog(availableUsers: availableUsers),
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
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppLayout.radiusSmall - 2),
              ),
              child: Icon(
                AppIcons.add,
                size: AppSpacing.s,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              context.l10n.explorerCreateGroup,
              style: AppTextStyles.labelMedium.copyWith(
                color: cs.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
