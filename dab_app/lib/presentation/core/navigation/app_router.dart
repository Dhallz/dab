import 'package:go_router/go_router.dart';

import 'app_route.dart';

class AppRouter {
  late final router = GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: AppRoute.splash.view,
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: AppRoute.login.view,
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: AppRoute.home.view,
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        builder: AppRoute.settings.view,
      ),
    ],
  );
}
