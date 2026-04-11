import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dab_mesh_background.dart';
import '../widgets/home_top_nav.dart';

class HomeViewDesktop extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeViewDesktop({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: Column(
          children: [
            HomeTopNav(
              currentIndex: navigationShell.currentIndex,
              onTap: _onBranchTap,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      ),
    );
  }

  void _onBranchTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
