import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/containers/activity_usecases.dart';
import '../domain/containers/auth_usecases.dart';
import '../domain/containers/monitoring_usecases.dart';
import '../domain/containers/system_usecases.dart';
import '../domain/containers/presence_usecases.dart';
import '../infrastructure/core/local/objectbox_store.dart';
import '../infrastructure/core/local/token_storage.dart';
import '../infrastructure/core/remote/rest_api_client.dart';
import '../infrastructure/core/remote/web_socket_client.dart';
import '../infrastructure/datasources/auth_local_data_source.dart';
import '../infrastructure/datasources/auth_remote_data_source.dart';
import '../infrastructure/datasources/monitoring_remote_data_source.dart';
import '../infrastructure/datasources/system_local_data_source.dart';
import '../infrastructure/datasources/activity_remote_data_source.dart';
import '../infrastructure/datasources/presence_remote_data_source.dart';
import '../infrastructure/repositories/activity_repository.dart';
import '../infrastructure/repositories/auth_repository.dart';
import '../infrastructure/repositories/monitoring_repository.dart';
import '../infrastructure/repositories/system_repository.dart';
import '../infrastructure/repositories/presence_repository.dart';
import '../presentation/core/navigation/app_router.dart';

final sl = ServiceLocator();

/// Manages the instantiation and lifecycle of app dependencies.
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Infrastructure
  late final RestApiClient restApiClient;
  late final ObjectBoxStore objectBoxStore;
  late final TokenStorage tokenStorage;
  late final FlutterSecureStorage secureStorage;
  late final AppRouter appRouter;

  // Repositories
  late final AuthRepository authRepository;
  late final MonitoringRepository monitoringRepository;
  late final SystemRepository systemRepository;
  late final ActivityRepository activityRepository;
  late final PresenceRepository presenceRepository;

  // UseCase Containers
  late final AuthUseCases authUseCases;
  late final MonitoringUseCases monitoringUseCases;
  late final SystemUseCases systemUseCases;
  late final ActivityUseCases activityUseCases;
  late final PresenceUseCases presenceUseCases;

  /// Initializes all dependencies. Must be called at app boot.
  Future<void> init() async {
    // 1. Core Infrastructure
    restApiClient = RestApiClient(baseUrl: 'http://localhost:8081');
    objectBoxStore = await ObjectBoxStore.create();
    tokenStorage = TokenStorage();
    secureStorage = const FlutterSecureStorage();
    appRouter = AppRouter();

    // 2. Monitoring Context
    final monitoringRemoteDataSource = MonitoringRemoteDataSource(
      restApiClient,
    );
    monitoringRepository = MonitoringRepository(monitoringRemoteDataSource);
    monitoringUseCases = MonitoringUseCases(monitoringRepository);

    // 3. Auth Context
    final authRemoteDataSource = AuthRemoteDataSource(restApiClient);
    final authLocalDataSource = AuthLocalDataSource(objectBoxStore);
    authRepository = AuthRepository(
      authRemoteDataSource,
      authLocalDataSource,
      tokenStorage,
    );
    authUseCases = AuthUseCases(authRepository, monitoringRepository);

    // 4. System Context
    final systemLocalDataSource = SystemLocalDataSource(objectBoxStore);
    systemRepository = SystemRepository(systemLocalDataSource);
    systemUseCases = SystemUseCases(systemRepository);

    // 5. Activity Context
    final wsClient = WebSocketClient('ws://localhost:8081/ws');
    final activityRemoteDataSource = ActivityRemoteDataSource(
      restApiClient,
      wsClient,
    );
    activityRepository = ActivityRepository(activityRemoteDataSource);
    activityUseCases = ActivityUseCases(activityRepository);

    // 6. Presence Context
    final presenceRemoteDataSource = PresenceRemoteDataSource(wsClient);
    presenceRepository = PresenceRepository(presenceRemoteDataSource);
    presenceUseCases = PresenceUseCases(presenceRepository);
  }
}
