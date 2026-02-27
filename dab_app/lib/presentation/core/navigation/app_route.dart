import 'package:dab_app/presentation/views/login/login_view.dart';
import 'package:dab_app/presentation/views/settings/settings_view.dart';
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
    (context, state) => const Placeholder(),
  );
  static final login = AppRoute._(
    'login',
    '/login',
    (context, state) => const LoginView(),
  );
  static final home = AppRoute._(
    'home',
    '/home',
    (context, state) => const Placeholder(),
  );
  static final settings = AppRoute._(
    'settings',
    '/settings',
    (context, state) => const SettingsView(),
  );
}
