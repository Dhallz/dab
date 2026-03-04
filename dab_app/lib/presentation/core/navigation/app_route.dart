import 'package:dab_app/presentation/views/auth/auth_view.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_view.dart';
import 'package:dab_app/presentation/views/settings/settings_view.dart';
import 'package:dab_app/presentation/views/splash/splash_view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  final String name;
  final String path;
  final Widget Function(BuildContext, GoRouterState) view;

  const AppRoute._(this.name, this.path, this.view);

  static final splash = AppRoute._(
    'splash',
    '/',
    (context, state) => const SplashView(),
  );
  static final auth = AppRoute._(
    'auth',
    '/auth',
    (context, state) => const AuthView(),
  );
  static final home = AppRoute._(
    'home',
    '/home',
    (context, state) => const DashboardView(),
  );
  static final settings = AppRoute._(
    'settings',
    '/settings',
    (context, state) => const SettingsView(),
  );
}
