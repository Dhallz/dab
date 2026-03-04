import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/service_locator.dart';
import 'bloc/dashboard_bloc.dart';
import 'layout/dashboard_view_desktop.dart';
import 'layout/dashboard_view_mobile.dart';
import 'widgets/dab_top_menu.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DabViewTab _activeTab = DabViewTab.feed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(sl.activityUseCases),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return DashboardViewDesktop(
              activeTab: _activeTab,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
            );
          }
          return DashboardViewMobile(
            activeTab: _activeTab,
            onTabChanged: (tab) => setState(() => _activeTab = tab),
          );
        },
      ),
    );
  }
}
