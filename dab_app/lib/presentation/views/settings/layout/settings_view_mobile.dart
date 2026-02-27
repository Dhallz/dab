import 'package:flutter/material.dart';

import '../../../core/app_bloc_builder.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_text_styles.dart';
import '../settings_bloc.dart';
import '../settings_event.dart';
import '../settings_state.dart';

class SettingsViewMobile extends StatelessWidget {
  const SettingsViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state, bloc) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader(context, 'Appearance'),
            const SizedBox(height: 16),
            _buildThemeTile(
              context,
              title: 'Theme Mode',
              currentMode: state.settings.themeMode,
              onChanged: (mode) => bloc.add(SettingsThemeModeChanged(mode!)),
            ),
            const Divider(height: 32, color: AppColors.outline),
            _buildSectionHeader(context, 'About'),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(AppIcons.info, color: AppColors.secondary),
              title: const Text('Version', style: AppTextStyles.bodyMedium),
              trailing: const Text('1.0.0', style: AppTextStyles.caption),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.caption.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: AppColors.secondary,
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context, {
    required String title,
    required ThemeMode currentMode,
    required ValueChanged<ThemeMode?> onChanged,
  }) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('System Default', style: AppTextStyles.bodyMedium),
          value: ThemeMode.system,
          groupValue: currentMode,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light Mode', style: AppTextStyles.bodyMedium),
          value: ThemeMode.light,
          groupValue: currentMode,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark Mode', style: AppTextStyles.bodyMedium),
          value: ThemeMode.dark,
          groupValue: currentMode,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
