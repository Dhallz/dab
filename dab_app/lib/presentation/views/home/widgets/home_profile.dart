import 'package:flutter/material.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: User profile display with name and avatar.
class HomeProfile extends StatelessWidget {
  final bool showName;
  final String userName;
  final String userInitials;
  final VoidCallback onOpenSettings;

  const HomeProfile({
    super.key,
    this.showName = true,
    required this.userName,
    required this.userInitials,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showName) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 112),
              child: Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s),
          ],
          PopupMenuButton<_HomeProfileMenuAction>(
            tooltip: context.l10n.settingsTitle,
            onSelected: (action) {
              switch (action) {
                case _HomeProfileMenuAction.settings:
                  onOpenSettings();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<_HomeProfileMenuAction>(
                value: _HomeProfileMenuAction.settings,
                child: Text(context.l10n.settingsTitle),
              ),
            ],
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primary.withValues(alpha: 0.2),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Center(
                child: Text(
                  userInitials,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _HomeProfileMenuAction { settings }
