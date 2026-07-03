import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:dab_app/presentation/core/styles/app_theme.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/auth/auth_notifier.dart';
import 'package:dab_app/presentation/features/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/entities/system/app_settings.dart';
import 'presentation/core/localization/app_localizations.dart';
import 'presentation/core/navigation/app_router.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeOrgCalendar();

  await sl.init();

  runApp(
    ProviderScope(
      child: _AuthRouterRefresh(child: DabApp(appRouter: sl.appRouter)),
    ),
  );
}

/// Re-evaluates [GoRouter] redirects when session state changes.
class _AuthRouterRefresh extends ConsumerStatefulWidget {
  const _AuthRouterRefresh({required this.child});

  final Widget child;

  @override
  ConsumerState<_AuthRouterRefresh> createState() => _AuthRouterRefreshState();
}

class _AuthRouterRefreshState extends ConsumerState<_AuthRouterRefresh> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      sl.appRouter.router.refresh();
    });
    return widget.child;
  }
}

class DabApp extends ConsumerWidget {
  final AppRouter appRouter;

  const DabApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appNotifierProvider);

    return MaterialApp.router(
      title: lookupAppLocalizations(
        state.settings.resolvedLocale ?? const Locale('en'),
      ).appWindowTitle,
      routerConfig: appRouter.router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: state.settings.resolvedLocale,
      theme: AppTheme.themeFor(state.settings.appThemeVariant),
      themeMode: ThemeMode.light,
    );
  }
}
