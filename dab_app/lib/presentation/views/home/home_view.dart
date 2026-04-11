import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'layouts/home_view_desktop.dart';
import 'layouts/home_view_mobile.dart';

class HomeView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return HomeViewDesktop(navigationShell: navigationShell);
        }
        return HomeViewMobile(navigationShell: navigationShell);
      },
    );
  }
}
