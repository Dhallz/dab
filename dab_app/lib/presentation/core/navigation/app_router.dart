import 'package:dab_app/presentation/views/home/home_view.dart';
import 'package:dab_app/presentation/views/splash/splash_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_notifier.dart';
import 'app_route.dart';
import 'fade_transition_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.splash.path,

    redirect: (context, state) {
      final authState = ProviderScope.containerOf(
        context,
      ).read(authNotifierProvider);
      final isLoggedIn = authState.isAuthenticated;
      final location = state.matchedLocation;
      final isPublicRoute =
          location == AppRoute.splash.path || location == AppRoute.auth.path;

      // Splash stays on `/` for cold start; splash_view routes to auth/home after hold.
      if (!isLoggedIn && !isPublicRoute) {
        return AppRoute.auth.path;
      }

      if (isLoggedIn && location == AppRoute.auth.path) {
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
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const SplashView(),
        ),
      ),
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: AppRoute.auth.view(context, state),
        ),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => fadeTransitionPage(
          key: state.pageKey,
          child: HomeView(navigationShell: navigationShell),
        ),
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
