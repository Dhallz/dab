import 'package:dab_app/presentation/core/navigation/app_route.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/auth/auth_notifier.dart';
import 'package:dab_app/presentation/features/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dab_mesh_background.dart';
import '../widgets/home_top_nav.dart';

class HomeViewDesktop extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomeViewDesktop({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userName = _displayName(authState);
    final userInitials = _displayInitials(userName);

    final adminBadgeCount = ref.watch(
      appNotifierProvider.select((s) => s.unresolvedIdentityCount),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: Column(
          children: [
            HomeTopNav(
              currentIndex: navigationShell.currentIndex,
              onTap: (i) => _onBranchTap(context, ref, i),
              adminTabBadgeCount: adminBadgeCount,
              userName: userName,
              userInitials: userInitials,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      ),
    );
  }

  void _onBranchTap(BuildContext context, WidgetRef ref, int index) {
    final previousIndex = navigationShell.currentIndex;
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    if (previousIndex != index &&
        navigationShell.currentIndex == previousIndex) {
      final targetPath = switch (index) {
        0 => AppRoute.homeDashboard.path,
        1 => AppRoute.homeExplorer.path,
        2 => AppRoute.homeInsight.path,
        _ => AppRoute.homeAdmin.path,
      };
      context.go(targetPath);
    }
    if (index == 3) {
      ref
          .read(appNotifierProvider.notifier)
          .refreshIdentityResolutionBadge(ref.read(authNotifierProvider));
    }
  }

  String _displayName(AuthState state) {
    final name = state.user?.name.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    final email = state.user?.email.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }
    return 'User';
  }

  String _displayInitials(String value) {
    final parts = value
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
