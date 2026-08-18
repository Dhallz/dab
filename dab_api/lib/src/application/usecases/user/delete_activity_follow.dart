import 'package:fpdart/fpdart.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Removes a Dashboard object Follow pin for the caller.
class DeleteActivityFollow {
  DeleteActivityFollow(this._follows);

  final AbsIActivityFollowRepository _follows;

  Future<Either<Failure, void>> execute({
    required String userId,
    required String providerId,
    required String objectKey,
  }) async {
    final id = providerId.trim().toLowerCase();
    final key = objectKey.trim();
    if (!isFollowableProviderId(id) || key.isEmpty) {
      return const Left(
        ValidationFailure(
          'Follow is only available for Phorge, Jira, Linear, Slack, Discord, '
          'and a GitHub/GitLab/Bitbucket repo branch',
        ),
      );
    }
    if (isGitFollowProviderId(id) && parseGitFollowObjectKey(key) == null) {
      return const Left(
        ValidationFailure('Git Follow requires owner/repo and a branch'),
      );
    }
    return _follows.delete(
      userId: userId,
      providerId: id,
      objectKey: key,
    );
  }
}
