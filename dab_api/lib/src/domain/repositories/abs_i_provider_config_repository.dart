import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../entities/provider_config.dart';

abstract interface class AbsIProviderConfigRepository {
  Future<Either<Failure, List<ProviderConfig>>> getConfigs();
}
