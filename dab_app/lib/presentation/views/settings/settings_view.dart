import 'package:flutter/material.dart';
import '../../core/localization/l10n_extension.dart';

import 'layouts/settings_view_desktop.dart';
import 'layouts/settings_view_mobile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return const SettingsViewDesktop();
          }
          return const SettingsViewMobile();
        },
      ),
    );
  }
}
