import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_device_token.dart';
import '../../../domain/contracts/repositories/abs_i_user_device_token_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Upserts an FCM/APNs device token for the caller.
class SaveUserDeviceToken {
  SaveUserDeviceToken(this._tokens);

  final AbsIUserDeviceTokenRepository _tokens;
  static const _uuid = Uuid();

  Future<Either<Failure, UserDeviceToken>> execute({
    required String userId,
    required String platform,
    required String token,
  }) async {
    final platformId = platform.trim().toLowerCase();
    final value = token.trim();
    if (!platformId.isDeviceTokenPlatform) {
      return const Left(
        ValidationFailure('platform must be android or ios'),
      );
    }
    if (value.isEmpty || value.length > 4096) {
      return const Left(ValidationFailure('token is required'));
    }
    final now = DateTime.now().toUtc();
    return _tokens.upsert(
      UserDeviceToken(
        id: _uuid.v5(Namespace.url.value, 'device-token|$userId|$value'),
        userId: userId,
        platform: platformId,
        token: value,
        createdAt: now,
      ),
    );
  }
}
