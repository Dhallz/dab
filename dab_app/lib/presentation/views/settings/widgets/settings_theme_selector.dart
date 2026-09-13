import 'package:dab_app/domain/entities/system/app_theme_variant.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Theme variant selector for settings (Light, DAB, grayscale Dark).
class SettingsThemeSelector extends StatelessWidget {
  final AppThemeVariant currentVariant;
  final ValueChanged<AppThemeVariant> onChanged;

  const SettingsThemeSelector({
    super.key,
    required this.currentVariant,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AppThemeVariant>(
      key: ValueKey(currentVariant),
      initialValue: currentVariant,
      decoration: const InputDecoration(),
      items: [
        DropdownMenuItem(
          value: AppThemeVariant.light,
          child: Text(
            context.l10n.settingsThemeLight,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        DropdownMenuItem(
          value: AppThemeVariant.dab,
          child: Text(
            context.l10n.settingsThemeDab,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        DropdownMenuItem(
          value: AppThemeVariant.greyscale,
          child: Text(
            context.l10n.settingsThemeDark,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
      onChanged: (variant) {
        if (variant != null) {
          onChanged(variant);
        }
      },
    );
  }
}
