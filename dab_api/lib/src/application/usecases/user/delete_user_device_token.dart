import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_user_device_token_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Removes an FCM/APNs device token for the caller.
class DeleteUserDeviceToken {
  DeleteUserDeviceToken(this._tokens);

  final AbsIUserDeviceTokenRepository _tokens;

  Future<Either<Failure, void>> execute({
    required String userId,
    required String token,
  }) async {
    final value = token.trim();
    if (value.isEmpty) {
      return const Left(ValidationFailure('token is required'));
    }
    return _tokens.delete(userId: userId, token: value);
  }
}
