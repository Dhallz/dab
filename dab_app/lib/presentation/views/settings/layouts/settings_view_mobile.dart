import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_text_styles.dart';
import '../settings_bloc.dart';
import '../settings_event.dart';
import '../settings_state.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_theme_selector.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Mobile-optimized layout for the settings view.
class SettingsViewMobile extends StatelessWidget {
  const SettingsViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) => false,
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        if (state.status == ViewStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SettingsSectionHeader(title: 'Appearance'),
            const SizedBox(height: 16),
            SettingsThemeSelector(
              currentMode: state.settings.themeMode,
              onChanged: (mode) => bloc.add(SettingsThemeModeChanged(mode!)),
            ),
            const Divider(height: 32, color: AppColors.outline),
            const SettingsSectionHeader(title: 'About'),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(AppIcons.info, color: AppColors.secondary),
              title: Text('Version', style: AppTextStyles.bodyMedium),
              trailing: Text('1.0.0', style: AppTextStyles.labelSmall),
            ),
          ],
        );
      },
    );
  }
}
