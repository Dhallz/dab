import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Locale selector for settings.
class SettingsLanguageSelector extends StatelessWidget {
  final String? currentLocaleCode;
  final ValueChanged<String?> onChanged;

  const SettingsLanguageSelector({
    super.key,
    required this.currentLocaleCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: currentLocaleCode,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem<String?>(
          value: null,
          child: Text(
            context.l10n.settingsLanguageSystemDefault,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        DropdownMenuItem<String?>(
          value: 'en',
          child: Text(
            context.l10n.settingsLanguageEnglish,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        DropdownMenuItem<String?>(
          value: 'es',
          child: Text(
            context.l10n.settingsLanguageSpanish,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        DropdownMenuItem<String?>(
          value: 'fr',
          child: Text(
            context.l10n.settingsLanguageFrench,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        DropdownMenuItem<String?>(
          value: 'de',
          child: Text(
            context.l10n.settingsLanguageGerman,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        DropdownMenuItem<String?>(
          value: 'pt',
          child: Text(
            context.l10n.settingsLanguagePortuguese,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
      onChanged: (value) => onChanged(value),
    );
  }
}
