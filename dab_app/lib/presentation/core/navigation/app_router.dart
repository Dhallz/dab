import 'package:dab_app/domain/entities/user/user_role.dart';
import 'package:dab_app/presentation/views/home/home_view.dart';
import 'package:dab_app/presentation/views/splash/splash_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_notifier.dart';
import 'app_route.dart';
import 'fade_transition_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Resolves auth/home redirects. Returns a path to go to, or `null` to stay.
String? resolveHomeRedirect({
  required bool isLoggedIn,
  required String location,
  UserRole? role,
}) {
  final isPublicRoute =
      location == AppRoute.splash.path || location == AppRoute.auth.path;
  if (!isLoggedIn && !isPublicRoute) {
    return AppRoute.auth.path;
  }
  if (isLoggedIn && location == AppRoute.auth.path) {
    return AppRoute.homeDashboard.path;
  }
  if (isLoggedIn &&
      location == AppRoute.homeAdmin.path &&
      role != UserRole.admin) {
    return AppRoute.homeDashboard.path;
  }
  return null;
}

class AppRouter {
  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.splash.path,

    redirect: (context, state) {
      final authState = ProviderScope.containerOf(
        context,
      ).read(authNotifierProvider);
      return resolveHomeRedirect(
        isLoggedIn: authState.isAuthenticated,
        location: state.matchedLocation,
        role: authState.user?.role,
      );
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
                path: AppRoute.homeReports.path,
                name: AppRoute.homeReports.name,
                builder: AppRoute.homeReports.view,
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
