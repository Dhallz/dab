import 'package:dab_app/presentation/views/admin/admin_view.dart';
import 'package:dab_app/presentation/views/auth/auth_view.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_view.dart';
import 'package:dab_app/presentation/views/explorer/explorer_view.dart';
import 'package:dab_app/presentation/views/insights/insights_view.dart';
import 'package:dab_app/presentation/views/reports/reports_view.dart';
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
  static final homeDashboard = AppRoute._(
    'home_dashboard',
    '/home/dashboard',
    (context, state) => const DashboardView(),
  );
  static final homeReports = AppRoute._(
    'home_reports',
    '/home/reports',
    (context, state) => const ReportsView(),
  );
  static final homeExplorer = AppRoute._(
    'home_explorer',
    '/home/explorer',
    (context, state) => const ExplorerView(),
  );
  static final homeInsight = AppRoute._(
    'home_insight',
    '/home/insight',
    (context, state) => const InsightsView(),
  );
  static final homeAdmin = AppRoute._(
    'home_admin',
    '/home/admin',
    (context, state) => const AdminView(),
  );
  static final settings = AppRoute._(
    'settings',
    '/settings',
    (context, state) => const SettingsView(),
  );
}
