---
description: Scaffold a new DAB App with Clean Architecture, Bloc, and ObjectBox. Takes App name and Org name.
---
# Scaffold DAB App

This workflow will initialize a new Flutter project and configure it with the project's established Clean Architecture, including base Blocs, global state management, and a standardized directory structure.

**Instructions for the Assistant:** 
Before starting, ensure the user has provided the `{APP_NAME}` and `{ORG}` (e.g., `com.example`). If they have not, ask them for these values.
Once you have the `{APP_NAME}` and `{ORG}`, execute the following steps, replacing all instances of `{APP_NAME}` and `{ORG}` in the commands and file contents with the provided values.

// turbo-all

1. Create a new Flutter project:
```bash
flutter create --org {ORG} {APP_NAME}
```

2. Add the necessary dependencies:
```bash
cd {APP_NAME} && flutter pub add flutter_bloc go_router flutter_secure_storage fpdart dio dart_mappable objectbox objectbox_flutter_libs intl path path_provider && flutter pub add -d build_runner dart_mappable_builder objectbox_generator flutter_lints
```

3. Create the directory structure:
```bash
cd {APP_NAME} && mkdir -p lib/domain/core lib/domain/entities lib/domain/repositories/core lib/domain/usecases lib/domain/containers lib/infrastructure/core/remote lib/infrastructure/core/local lib/infrastructure/core/extensions lib/infrastructure/repositories/core lib/infrastructure/datasources lib/presentation/core/navigation lib/presentation/core/styles lib/presentation/core/widgets lib/presentation/core/localization lib/presentation/features/app lib/presentation/views/login/layout lib/presentation/views/settings/layout lib/services
```

4. Create the core architectural files:

Create `lib/presentation/core/abs_bloc.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/abs_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/app/app_cubit.dart';

abstract class AbsBloc<E, S> extends Bloc<E, S> {
  static late AppCubit appCubit;
  AbsBloc(super.initialState);
  AppCubit get app => appCubit;
}
EOF
```

Create `lib/presentation/core/abs_cubit.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/abs_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/app/app_cubit.dart';

abstract class AbsCubit<S> extends Cubit<S> {
  static late AppCubit appCubit;
  AbsCubit(super.initialState);
  AppCubit get app => appCubit;
}
EOF
```

Create `lib/presentation/core/app_bloc_builder.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/app_bloc_builder.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocBuilder<B extends StateStreamableSource<S>, S> extends StatefulWidget {
  final void Function(BuildContext context, B bloc)? onInit;
  final Widget Function(BuildContext context, S state, B bloc) builder;
  final bool Function(S previous, S current)? buildWhen;
  final bool withLogs;

  const AppBlocBuilder({super.key, required this.builder, this.onInit, this.buildWhen, this.withLogs = false});

  @override
  State<AppBlocBuilder<B, S>> createState() => _AppBlocBuilderState<B, S>();
}

class _AppBlocBuilderState<B extends StateStreamableSource<S>, S> extends State<AppBlocBuilder<B, S>> {
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<B>();
    widget.onInit?.call(context, _bloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: _bloc,
      buildWhen: widget.buildWhen,
      builder: (context, state) {
        if (widget.withLogs) debugPrint('🟢 [${_bloc.runtimeType}] State: $state');
        return widget.builder(context, state, _bloc);
      },
    );
  }
}
EOF
```

Create `lib/presentation/core/app_bloc_listener.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/app_bloc_listener.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocListener<B extends StateStreamableSource<S>, S> extends StatefulWidget {
  final void Function(BuildContext context, B bloc)? onInit;
  final void Function(BuildContext context, S state, B bloc) listener;
  final bool Function(S previous, S current)? listenWhen;
  final Widget child;

  const AppBlocListener({super.key, required this.listener, required this.child, this.onInit, this.listenWhen});

  @override
  State<AppBlocListener<B, S>> createState() => _AppBlocListenerState<B, S>();
}

class _AppBlocListenerState<B extends StateStreamableSource<S>, S> extends State<AppBlocListener<B, S>> {
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<B>();
    widget.onInit?.call(context, _bloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      bloc: _bloc,
      listenWhen: widget.listenWhen,
      listener: (context, state) => widget.listener(context, state, _bloc),
      child: widget.child,
    );
  }
}
EOF
```

Create `lib/presentation/core/app_bloc_consumer.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/app_bloc_consumer.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocConsumer<B extends StateStreamableSource<S>, S> extends StatefulWidget {
  final void Function(BuildContext context, B bloc)? onInit;
  final Widget Function(BuildContext context, S state, B bloc) builder;
  final void Function(BuildContext context, S state, B bloc) listener;
  final bool Function(S previous, S current)? buildWhen;
  final bool Function(S previous, S current)? listenWhen;
  final bool withLogs;

  const AppBlocConsumer({super.key, required this.builder, required this.listener, this.onInit, this.buildWhen, this.listenWhen, this.withLogs = false});

  @override
  State<AppBlocConsumer<B, S>> createState() => _AppBlocConsumerState<B, S>();
}

class _AppBlocConsumerState<B extends StateStreamableSource<S>, S> extends State<AppBlocConsumer<B, S>> {
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<B>();
    widget.onInit?.call(context, _bloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      bloc: _bloc,
      listenWhen: widget.listenWhen,
      listener: (context, state) => widget.listener(context, state, _bloc),
      buildWhen: widget.buildWhen,
      builder: (context, state) {
        if (widget.withLogs) debugPrint('🟢 [${_bloc.runtimeType}] State: $state');
        return widget.builder(context, state, _bloc);
      },
    );
  }
}
EOF
```

Create `lib/presentation/core/styles/app_colors.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/styles/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0e1929);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF7c8c9b);
  static const Color surface = Color(0xFF0a0f19);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFF5f6c79);
  static const Color shadow = Color(0xFF000000);
  static const Color error = Color(0xFFb00020);
  static const Color onError = Color(0xFFFFFFFF);
}
EOF
```

Create `lib/presentation/core/styles/app_text_styles.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/styles/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.onSurface);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.onSurface);
}
EOF
```

Create `lib/presentation/core/styles/app_theme.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/styles/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(primary: AppColors.primary, secondary: AppColors.secondary, surface: AppColors.surface, error: AppColors.error),
    scaffoldBackgroundColor: AppColors.surface,
  );
}
EOF
```

Create `lib/domain/core/failures.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/domain/core/failures.dart
import 'package:dart_mappable/dart_mappable.dart';
part 'failures.mapper.dart';

@MappableClass(discriminatorKey: 'type')
sealed class AppFailure with AppFailureMappable {
  final String message;
  const AppFailure(this.message);
}

@MappableClass()
class ServerFailure extends AppFailure with ServerFailureMappable {
  const ServerFailure({required String message}) : super(message);
}

@MappableClass()
class UnknownFailure extends AppFailure with UnknownFailureMappable {
  const UnknownFailure({String message = 'Unexpected error'}) : super(message);
}
EOF
```

Create `lib/infrastructure/core/remote/rest_api_client.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/infrastructure/core/remote/rest_api_client.dart
import 'package:dio/dio.dart';

class RestApiClient {
  final Dio dio;
  RestApiClient({required String baseUrl}) : dio = Dio(BaseOptions(baseUrl: baseUrl));
}
EOF
```

Create `lib/presentation/features/app/app_state.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/features/app/app_state.dart
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
part 'app_state.mapper.dart';

@MappableClass()
class AppState with AppStateMappable {
  final ThemeMode themeMode;
  const AppState({this.themeMode = ThemeMode.system});
}
EOF
```

Create `lib/presentation/features/app/app_cubit.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/features/app/app_cubit.dart
import 'package:flutter/material.dart';
import '../../core/abs_cubit.dart';
import 'app_state.dart';

class AppCubit extends AbsCubit<AppState> {
  AppCubit() : super(const AppState());
}
EOF
```

Create `lib/presentation/core/navigation/app_route.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/navigation/app_route.dart
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  final String name;
  final String path;
  final Widget Function(BuildContext, GoRouterState) view;
  const AppRoute._(this.name, this.path, this.view);
  static final splash = AppRoute._('splash', '/', (context, state) => const Placeholder());
}
EOF
```

Create `lib/presentation/core/navigation/app_router.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/presentation/core/navigation/app_router.dart
import 'package:go_router/go_router.dart';
import 'app_route.dart';

class AppRouter {
  late final router = GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(path: AppRoute.splash.path, name: AppRoute.splash.name, builder: AppRoute.splash.view),
    ],
  );
}
EOF
```

Create `lib/services/service_locator.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/services/service_locator.dart
import 'presentation/core/navigation/app_router.dart';
final sl = ServiceLocator();
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();
  late final AppRouter appRouter;
  Future<void> init() async {
    appRouter = AppRouter();
  }
}
EOF
```

Create `lib/main.dart`:
```bash
cd {APP_NAME} && cat << 'EOF' > lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/core/abs_bloc.dart';
import 'presentation/core/abs_cubit.dart';
import 'presentation/features/app/app_cubit.dart';
import 'presentation/features/app/app_state.dart';
import 'presentation/core/styles/app_theme.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sl.init();
  final appCubit = AppCubit();
  AbsBloc.appCubit = appCubit;
  AbsCubit.appCubit = appCubit;
  runApp(
    BlocProvider.value(
      value: appCubit,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return MaterialApp.router(
          routerConfig: sl.appRouter.router,
          theme: AppTheme.dark,
          themeMode: state.themeMode,
        );
      },
    );
  }
}
EOF
```

5. Finalize and run code generation:
```bash
cd {APP_NAME} && flutter pub run build_runner build --delete-conflicting-outputs
```
