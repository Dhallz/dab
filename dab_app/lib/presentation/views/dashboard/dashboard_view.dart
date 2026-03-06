import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/service_locator.dart';
import 'dashboard_bloc.dart';
import 'layout/dashboard_view_desktop.dart';
import 'layout/dashboard_view_mobile.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(sl.activityUseCases),
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
