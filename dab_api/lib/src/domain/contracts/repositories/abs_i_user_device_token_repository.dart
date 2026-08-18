import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/user/user_device_token.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Persistence for per-user mobile push device tokens.
abstract interface class AbsIUserDeviceTokenRepository {
  Future<Either<Failure, UserDeviceToken>> upsert(UserDeviceToken token);

  Future<Either<Failure, void>> delete({
    required String userId,
    required String token,
  });

  /// Opaque FCM/APNs tokens for [userId].
  Future<Either<Failure, List<String>>> listTokensForUser(String userId);
}
