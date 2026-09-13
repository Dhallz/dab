import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/user/activity_follow.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Persistence for per-user Dashboard object Follow pins.
abstract interface class AbsIActivityFollowRepository {
  Future<Either<Failure, List<ActivityFollow>>> listForUser(String userId);

  Future<Either<Failure, ActivityFollow>> upsert(ActivityFollow follow);

  Future<Either<Failure, void>> delete({
    required String userId,
    required String providerId,
    required String objectKey,
  });

  Future<Either<Failure, List<String>>> userIdsFor({
    required String providerId,
    required String objectKey,
  });
}
