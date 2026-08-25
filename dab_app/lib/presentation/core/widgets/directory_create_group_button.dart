import 'package:flutter/material.dart';

import '../../../domain/entities/group/group.dart';
import '../../../domain/entities/user/user.dart';
import '../localization/l10n_extension.dart';
import '../styles/app_icons.dart';
import '../styles/app_layout.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';
import 'directory_create_group_dialog.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Opens the create-group dialog from a Directory groups list.
class DirectoryCreateGroupButton extends StatelessWidget {
  final List<User> availableUsers;
  final ValueChanged<Group> onCreated;

  const DirectoryCreateGroupButton({
    super.key,
    required this.availableUsers,
    required this.onCreated,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (dialogContext) => DirectoryCreateGroupDialog(
            availableUsers: availableUsers,
            onCreated: onCreated,
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
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppLayout.radiusSmall - 2),
              ),
              child: Icon(AppIcons.add, size: AppSpacing.s, color: cs.primary),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              context.l10n.explorerCreateGroup,
              style: AppTextStyles.labelMedium.copyWith(color: cs.primary),
            ),
          ],
        ),
      ),
    );
  }
}
