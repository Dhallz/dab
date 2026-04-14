import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/core/failures.dart';
import '../domain/containers/activity_usecases.dart';
import '../domain/containers/auth_usecases.dart';
import '../domain/containers/metadata_usecases.dart';
import '../domain/containers/monitoring_usecases.dart';
import '../domain/containers/presence_usecases.dart';
import '../domain/containers/system_usecases.dart';
import '../domain/containers/user_usecases.dart';
import '../domain/repositories/abs_i_user_repository.dart';
import '../infrastructure/core/local/objectbox_store.dart';
import '../infrastructure/core/local/token_storage.dart';
import '../infrastructure/core/remote/auth_interceptor.dart';
import '../infrastructure/core/remote/rest_api_client.dart';
import '../infrastructure/core/remote/web_socket_client.dart';
import '../infrastructure/datasources/activity_remote_data_source.dart';
import '../infrastructure/datasources/activity_local_data_source.dart';
import '../infrastructure/datasources/auth_local_data_source.dart';
import '../infrastructure/datasources/auth_remote_data_source.dart';
import '../infrastructure/datasources/monitoring_remote_data_source.dart';
import '../infrastructure/datasources/presence_remote_data_source.dart';
import '../infrastructure/datasources/provider_config_remote_data_source.dart';
import '../infrastructure/datasources/system_local_data_source.dart';
import '../infrastructure/repositories/activity_repository.dart';
import '../infrastructure/repositories/auth_repository.dart';
import '../infrastructure/repositories/monitoring_repository.dart';
import '../infrastructure/repositories/presence_repository.dart';
import '../infrastructure/repositories/provider_config_repository.dart';
import '../infrastructure/repositories/system_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
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
  late final ProviderConfigRepository providerConfigRepository;
  late final IUserRepository userRepository;

  // UseCase Containers
  late final AuthUseCases authUseCases;
  late final MonitoringUseCases monitoringUseCases;
  late final SystemUseCases systemUseCases;
  late final ActivityUseCases activityUseCases;
  late final PresenceUseCases presenceUseCases;
  late final MetadataUseCases metadataUseCases;
  late final UserUseCases userUseCases;

  /// Initializes all dependencies. Must be called at app boot.
  Future<void> init() async {
    // 1. Core Infrastructure
    restApiClient = RestApiClient(baseUrl: 'http://localhost:8080');
    tokenStorage = TokenStorage();
    final authInterceptor = AuthInterceptor(tokenStorage);
    restApiClient.addInterceptor(authInterceptor);

    objectBoxStore = await ObjectBoxStore.create();
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

    authInterceptor.onRefreshToken = () async {
      final result = await authRepository.refreshToken();
      result.fold((failure) {
        if (failure is AuthFailure &&
            failure.message == 'No refresh token available') {
          return;
        }
        throw Exception(failure.message);
      }, (_) {});
    };

    // 4. System Context
    final systemLocalDataSource = SystemLocalDataSource(objectBoxStore);
    systemRepository = SystemRepository(systemLocalDataSource);
    systemUseCases = SystemUseCases(systemRepository);

    // 5. Activity Context
    final wsClient = WebSocketClient('ws://localhost:8080/ws');
    final activityRemoteDataSource = ActivityRemoteDataSource(
      restApiClient,
      wsClient,
    );
    final activityLocalDataSource = ActivityLocalDataSource(objectBoxStore);
    activityRepository = ActivityRepository(
      activityRemoteDataSource,
      activityLocalDataSource,
    );
    activityUseCases = ActivityUseCases(activityRepository);

    // 6. Presence Context
    final presenceRemoteDataSource = PresenceRemoteDataSource(wsClient);
    presenceRepository = PresenceRepository(presenceRemoteDataSource);
    presenceUseCases = PresenceUseCases(presenceRepository);

    // 7. Metadata Context
    final providerConfigRemoteDataSource = ProviderConfigRemoteDataSource(
      restApiClient,
    );
    providerConfigRepository = ProviderConfigRepository(
      providerConfigRemoteDataSource,
    );
    metadataUseCases = MetadataUseCases(providerConfigRepository);

    // 8. User Context
    userRepository = UserRepository(restApiClient);
    userUseCases = UserUseCases(userRepository);
  }
}
