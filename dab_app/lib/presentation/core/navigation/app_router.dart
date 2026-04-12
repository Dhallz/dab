import 'package:dab_app/presentation/views/home/home_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_cubit.dart';
import 'app_route.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.splash.path,

    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;
      final isLoggedIn = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation == AppRoute.auth.path;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoute.auth.path;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoute.homeDashboard.path;
      }

      final redirectLog =
          '[${DateTime.timestamp()}] | [NAV] => ${state.matchedLocation}';

      debugPrint(
        '$redirectLog <===============================================================',
      );

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: AppRoute.splash.view,
      ),
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        builder: AppRoute.auth.view,
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.homeDashboard.path,
                name: AppRoute.homeDashboard.name,
                builder: AppRoute.homeDashboard.view,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.homeExplorer.path,
                name: AppRoute.homeExplorer.name,
                builder: AppRoute.homeExplorer.view,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.homeInsight.path,
                name: AppRoute.homeInsight.name,
                builder: AppRoute.homeInsight.view,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.homeAdmin.path,
                name: AppRoute.homeAdmin.name,
                builder: AppRoute.homeAdmin.view,
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        builder: AppRoute.settings.view,
      ),
    ],
  );
}
