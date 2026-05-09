import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../features/app/app_notifier.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_theme_selector.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Mobile-optimized layout for the settings view.
class SettingsViewMobile extends ConsumerWidget {
  const SettingsViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shell = ref.watch(
      appNotifierProvider.select(
        (s) => (status: s.status, themeMode: s.settings.themeMode),
      ),
    );

    if (shell.status == ViewStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SettingsSectionHeader(title: 'Appearance'),
        const SizedBox(height: 16),
        SettingsThemeSelector(
          currentMode: shell.themeMode,
          onChanged: (mode) =>
              ref.read(appNotifierProvider.notifier).updateThemeMode(mode!),
        ),
        const Divider(height: 32, color: AppColors.outline),
        const SettingsSectionHeader(title: 'About'),
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(AppIcons.info, color: AppColors.secondary),
          title: const Text('Version', style: AppTextStyles.bodyMedium),
          trailing: const Text('1.0.0', style: AppTextStyles.labelSmall),
        ),
      ],
    );
  }
}
