import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failure.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Determines if the DAB platform is fully configured.
/// CONTRACT: Returns true if at least one Admin and one active Provider exist.
class GetSystemStatus {
  final AbsIAuthRepository _authRepo;
  final AbsIProviderConfigRepository _configRepo;

  GetSystemStatus(this._authRepo, this._configRepo);

  Future<Either<Failure, bool>> execute() async {
    try {
      final adminCountResult = await _authRepo.countAdmins();
      final configCountResult = await _configRepo.countActiveConfigs();

      return adminCountResult.fold(
        (f) => Left(f),
        (adminCount) => configCountResult.fold(
          (f) => Left(f),
          (activeConfigCount) => Right(
            adminCount > 0 && activeConfigCount > 0,
          ),
        ),
      );
    } catch (e) {
      return Left(DatabaseFailure('Error checking system status: $e'));
    }
  }
}
