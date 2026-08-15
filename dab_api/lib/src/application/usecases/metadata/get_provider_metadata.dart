import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_metadata.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_provider_metadata_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves dynamic platform metadata (Tags, Projects, Columns).
/// CONTRACT: Returns [ProviderMetadata] for [userId], omitting inactive providers.
class GetProviderMetadata {
  final AbsIProviderMetadataRepository _metadataRepo;
  final AbsIProviderConfigRepository _configRepo;

  GetProviderMetadata(this._metadataRepo, this._configRepo);

  Future<Either<Failure, List<ProviderMetadata>>> execute(String userId) async {
    final result = await _metadataRepo.getMetadata(userId);
    if (result.isLeft()) {
      return Left(result.getLeft().toNullable()!);
    }
    final all = result.getRight().toNullable()!;

    final configsResult = await _configRepo.getConfigs();
    final activeIds = configsResult.fold(
      (_) => <String>{},
      (configs) => configs
          .where((c) => c.isActive)
          .map((c) => c.id.toLowerCase())
          .toSet(),
    );

    final filtered = all
        .where((m) => activeIds.contains(m.provider.toLowerCase()))
        .toList();
    return Right(filtered);
  }
}
