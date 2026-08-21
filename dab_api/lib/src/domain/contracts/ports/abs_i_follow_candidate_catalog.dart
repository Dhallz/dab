import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/user/follow_candidate.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Read-only catalog of Follow picker rows for one provider.
abstract interface class AbsIFollowCandidateCatalog {
  String get providerId;

  /// Involved/open issues when [query] is empty; any matching issue otherwise.
  Future<Either<Failure, List<FollowCandidate>>> list({
    required String userId,
    required String query,
  });
}
