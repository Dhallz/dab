import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_route.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_text_styles.dart';
import '../settings_notifier.dart';
import '../widgets/settings_island_bar_visibility_section.dart';
import '../widgets/settings_language_selector.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_theme_selector.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Mobile-optimized layout for the settings view.
class SettingsViewMobile extends ConsumerStatefulWidget {
  const SettingsViewMobile({super.key});

  @override
  ConsumerState<SettingsViewMobile> createState() => _SettingsViewMobileState();
}

class _SettingsViewMobileState extends ConsumerState<SettingsViewMobile> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    if (state.status == ViewStatus.loading || state.status == ViewStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    final draft = state.draftSettings;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            OutlinedButton(
              onPressed: () => context.go(AppRoute.homeDashboard.path),
              child: Text(context.l10n.settingsClose),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: state.isDirty
                  ? () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final savedMessage = context.l10n.settingsSavedMessage;
                      await notifier.save();
                      if (!mounted) {
                        return;
                      }
                      messenger.showSnackBar(
                        SnackBar(content: Text(savedMessage)),
                      );
                    }
                  : null,
              child: Text(context.l10n.settingsSave),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SettingsSectionHeader(title: context.l10n.settingsSectionAppearance),
        const SizedBox(height: 16),
        SettingsThemeSelector(
          currentVariant: draft.appThemeVariant,
          onChanged: notifier.setThemeVariant,
        ),
        const Divider(height: 32, color: AppColors.outline),
        SettingsSectionHeader(title: context.l10n.settingsSectionLanguage),
        const SizedBox(height: 16),
        SettingsLanguageSelector(
          currentLocaleCode: draft.localeCode,
          onChanged: notifier.setLocaleCode,
        ),
        const Divider(height: 32, color: AppColors.outline),
        SettingsSectionHeader(title: context.l10n.settingsSectionIslandBar),
        const SizedBox(height: 8),
        SettingsIslandBarVisibilitySection(
          settings: draft,
          onSelectionChanged: notifier.setIslandBarItems,
        ),
        const Divider(height: 32, color: AppColors.outline),
        SettingsSectionHeader(title: context.l10n.settingsSectionAbout),
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(AppIcons.info, color: AppColors.secondary),
          title: Text(
            context.l10n.settingsVersionLabel,
            style: AppTextStyles.bodyMedium,
          ),
          trailing: Text(
            context.l10n.settingsVersionPlaceholder,
            style: AppTextStyles.labelSmall,
          ),
        ),
      ],
    );
  }
}
