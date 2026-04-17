import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../services/service_locator.dart';
import 'dashboard_bloc.dart';
import 'dashboard_event.dart';
import 'layouts/dashboard_view_desktop.dart';
import 'layouts/dashboard_view_mobile.dart';

/// [ARCH: PRESENTATION_VIEW]
/// ROLE: Responsive entry point for the Activity Dashboard.
/// CONTRACT: Provides a [BlocProvider] for [DashboardBloc] and switches layout based on constraints.
/// CONSTRAINTS: Must adapt between Mobile (<900px) and Desktop views.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardBloc(sl.activityUseCases, sl.upcomingEventUseCases)
            ..add(const DashboardStarted()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return const DashboardViewDesktop();
          }
          return const DashboardViewMobile();
        },
      ),
    );
  }
}
