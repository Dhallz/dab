import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/settings_view_desktop.dart';
import 'layout/settings_view_mobile.dart';
import 'settings_bloc.dart';
import 'settings_event.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc()..add(const SettingsStarted()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return const SettingsViewDesktop();
            }
            return const SettingsViewMobile();
          },
        ),
      ),
    );
  }
}
