import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/features/app/app_cubit.dart';
import 'package:dab_app/presentation/features/app/app_state.dart';
import 'package:dab_app/presentation/features/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dab_mesh_background.dart';
import '../widgets/home_top_nav.dart';

class HomeViewDesktop extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeViewDesktop({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<AppCubit, AppState>(
      listenWhen: (p, c) => false,
      listener: (context, state, bloc) {},
      buildWhen: (p, c) =>
          p.unresolvedIdentityCount != c.unresolvedIdentityCount,
      builder: (context, appState, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: DabMeshBackground(
            child: Column(
              children: [
                HomeTopNav(
                  currentIndex: navigationShell.currentIndex,
                  onTap: (i) => _onBranchTap(context, i),
                  adminTabBadgeCount: appState.unresolvedIdentityCount,
                ),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onBranchTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    if (index == 3) {
      context.read<AppCubit>().refreshIdentityResolutionBadge(
        context.read<AuthCubit>().state,
      );
    }
  }
}
