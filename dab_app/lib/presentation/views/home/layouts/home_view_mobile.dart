import 'package:dab_app/domain/entities/user/user_role.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/auth/auth_notifier.dart';
import 'package:dab_app/presentation/features/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dab_mesh_background.dart';
import '../widgets/home_mobile_header.dart';
import '../widgets/home_mobile_nav.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Mobile-optimized layout for the home view.
class HomeViewMobile extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomeViewMobile({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userName = _displayName(authState);
    final userInitials = _displayInitials(userName);

    final adminBadgeCount = ref.watch(
      appNotifierProvider.select((s) => s.unresolvedIdentityCount),
    );
    final showAdminTab = authState.user?.role == UserRole.admin;

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
                adminTabBadgeCount: adminBadgeCount,
                showAdminTab: showAdminTab,
                onBranchSelected: (index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                  if (index == 4) {
                    ref
                        .read(appNotifierProvider.notifier)
                        .refreshIdentityResolutionBadge(
                          ref.read(authNotifierProvider),
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
