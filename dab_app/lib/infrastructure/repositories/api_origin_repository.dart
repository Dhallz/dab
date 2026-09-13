import 'package:fpdart/fpdart.dart';

import '../../domain/core/api_origin.dart';
import '../../domain/core/failures.dart';
import '../../domain/repositories/abs_i_api_origin_repository.dart';
import '../core/local/api_origin_storage.dart';
import '../core/local/token_storage.dart';
import '../core/remote/api_base_url.dart';
import '../core/remote/rest_api_client.dart';
import '../core/remote/web_socket_client.dart';
import 'core/repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Apply a DAB API origin to REST, WebSocket, and local persistence.
class ApiOriginRepository extends Repository implements IApiOriginRepository {
  ApiOriginRepository(
    this._storage,
    this._restApiClient,
    this._webSocketClient,
    this._tokenStorage,
  );

  final ApiOriginStorage _storage;
  final RestApiClient _restApiClient;
  final WebSocketClient _webSocketClient;
  final TokenStorage _tokenStorage;

  @override
  Future<Either<AppFailure, String>> getOrigin() {
    return guardedCall(() async {
      return await _storage.read() ?? ApiBaseUrl.fromEnvironment;
    });
  }

  @override
  Future<Either<AppFailure, String>> setOrigin(String raw) {
    return ApiOrigin.parse(raw).fold(
      (failure) => Future.value(Left(failure)),
      (origin) => guardedCall(() async {
        final previous = await _storage.read() ?? ApiBaseUrl.fromEnvironment;
        if (origin != previous) {
          await _tokenStorage.clear();
        }
        await _storage.write(origin);
        _restApiClient.setBaseUrl(origin);
        _webSocketClient.setUrl(ApiBaseUrl.webSocket(origin));
        return origin;
      }),
    );
  }
}
