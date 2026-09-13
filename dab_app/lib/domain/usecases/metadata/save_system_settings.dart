import 'package:fpdart/fpdart.dart';
import '../../core/failures.dart';
import '../../repositories/abs_i_provider_config_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Saves key-value system settings using the repository.
class SaveSystemSettings {
  final IProviderConfigRepository _repository;

  SaveSystemSettings(this._repository);

  Future<Either<AppFailure, void>> execute(Map<String, String> settings) async {
    return _repository.saveSystemSettings(settings);
  }
}
