import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/user/follow_candidate.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Read-only catalog of Follow picker rows for one provider.
abstract interface class IFollowCandidateCatalog {
  String get providerId;

  /// Involved/open issues, or title/key matches for [query].
  Future<Either<Failure, List<FollowCandidate>>> list({
    required String userId,
    required String query,
  });
}
