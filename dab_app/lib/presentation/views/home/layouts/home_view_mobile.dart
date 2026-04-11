import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dab_mesh_background.dart';
import '../widgets/home_mobile_header.dart';
import '../widgets/home_mobile_nav.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Mobile-optimized layout for the home view.
class HomeViewMobile extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeViewMobile({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const HomeMobileHeader(),
              HomeMobileNav(navigationShell: navigationShell),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      ),
    );
  }
}
