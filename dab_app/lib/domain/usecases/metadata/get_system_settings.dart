import 'package:fpdart/fpdart.dart';
import '../../core/failures.dart';
import '../../repositories/abs_i_provider_config_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Fetches key-value system settings from the repository.
class GetSystemSettings {
  final IProviderConfigRepository _repository;

  GetSystemSettings(this._repository);

  Future<Either<AppFailure, Map<String, String>>> execute() async {
    return _repository.getSystemSettings();
  }
}
