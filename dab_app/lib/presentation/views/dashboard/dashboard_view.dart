import 'package:flutter/material.dart';

import 'layouts/dashboard_view_desktop.dart';
import 'layouts/dashboard_view_mobile.dart';

/// [ARCH: PRESENTATION_VIEW]
/// ROLE: Responsive entry point for the Activity Dashboard.
/// CONTRACT: Switches layout based on constraints; dashboard state is scoped by [dashboardNotifierProvider].
/// CONSTRAINTS: Must adapt between Mobile (<900px) and Desktop views.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const DashboardViewDesktop();
        }
        return const DashboardViewMobile();
      },
    );
  }
}
