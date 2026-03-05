import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../entities/provider_metadata.dart';

abstract interface class AbsIProviderMetadataRepository {
  Future<Either<Failure, List<ProviderMetadata>>> getMetadata(String userId);
}
