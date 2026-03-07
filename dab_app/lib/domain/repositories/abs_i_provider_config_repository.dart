import 'package:fpdart/fpdart.dart';

import '../core/failures.dart';
import '../entities/provider_config.dart';

abstract interface class IProviderConfigRepository {
  Future<Either<AppFailure, List<ProviderConfig>>> getProviderConfigs();
}
