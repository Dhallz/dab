import 'package:dab_app/presentation/core/styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/repositories/abs_i_auth_repository.dart';
import 'domain/repositories/abs_i_monitoring_repository.dart';
import 'presentation/core/abs_bloc.dart';
import 'presentation/core/abs_cubit.dart';
import 'presentation/core/navigation/app_router.dart';
import 'presentation/features/app/app_cubit.dart';
import 'presentation/features/app/app_state.dart';
import 'presentation/features/auth/auth_cubit.dart';
import 'presentation/views/dashboard/dashboard_bloc.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies via the transversal ServiceLocator
  await sl.init();

  final appCubit = AppCubit(
    sl.systemUseCases,
    sl.metadataUseCases,
    sl.userRepository,
  )..init();

  // Initialize base class resolvers
  AbsBloc.appCubit = appCubit;
  AbsCubit.appCubit = appCubit;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: sl.objectBoxStore),
        RepositoryProvider<IAuthRepository>.value(value: sl.authRepository),
        RepositoryProvider<IMonitoringRepository>.value(
          value: sl.monitoringRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: appCubit),
          BlocProvider(
            create: (context) => AuthCubit(sl.authUseCases)..checkAuth(),
          ),
          BlocProvider(create: (context) => DashboardBloc(sl.activityUseCases)),
        ],
        child: DabApp(appRouter: sl.appRouter),
      ),
    ),
  );
}

class DabApp extends StatelessWidget {
  final AppRouter appRouter;

  const DabApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'DAB App',
          routerConfig: appRouter.router,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark, // We can define a light theme later
          darkTheme: AppTheme.dark,
          themeMode: state.settings.themeMode,
        );
      },
    );
  }
}
