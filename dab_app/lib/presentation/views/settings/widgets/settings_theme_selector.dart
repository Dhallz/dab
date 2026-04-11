import 'package:flutter/material.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Theme mode selector for settings.
class SettingsThemeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode?> onChanged;

  const SettingsThemeSelector({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
