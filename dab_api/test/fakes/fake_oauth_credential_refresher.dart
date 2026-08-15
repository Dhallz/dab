import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/contracts/ports/i_oauth_credential_refresher.dart';
import 'package:fpdart/fpdart.dart';

/// Test double that returns preloaded per-user settings without hitting a token endpoint.
class FakeOauthCredentialRefresher implements IOauthCredentialRefresher {
  FakeOauthCredentialRefresher([this.userSettings = const {}]);

  final Map<String, Map<String, dynamic>> userSettings;
  int calls = 0;
  bool forced = false;

  @override
  Future<Either<Failure, Map<String, dynamic>>> ensureFresh({
    required String userId,
    required String providerId,
    bool force = false,
  }) async {
    calls += 1;
    forced = forced || force;
    return Right(Map<String, dynamic>.from(userSettings[userId] ?? const {}));
  }
}
