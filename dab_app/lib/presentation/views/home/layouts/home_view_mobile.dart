import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/features/app/app_cubit.dart';
import 'package:dab_app/presentation/features/app/app_state.dart';
import 'package:dab_app/presentation/features/auth/auth_cubit.dart';
import 'package:dab_app/presentation/features/auth/auth_state.dart';
import 'package:dab_app/presentation/core/navigation/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final authState = context.select<AuthCubit, AuthState>((cubit) => cubit.state);
    final userName = _displayName(authState);
    final userInitials = _displayInitials(userName);

    return AppBlocConsumer<AppCubit, AppState>(
      listenWhen: (p, c) => false,
      listener: (context, state, bloc) {},
      buildWhen: (p, c) =>
          p.unresolvedIdentityCount != c.unresolvedIdentityCount,
      builder: (context, appState, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: DabMeshBackground(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  HomeMobileHeader(userInitials: userInitials),
                  HomeMobileNav(
                    navigationShell: navigationShell,
                    adminTabBadgeCount: appState.unresolvedIdentityCount,
                    onBranchSelected: (index) {
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
                        context.read<AppCubit>().refreshIdentityResolutionBadge(
                          context.read<AuthCubit>().state,
                        );
                      }
                    },
                  ),
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ),
        );
      },
    );
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
