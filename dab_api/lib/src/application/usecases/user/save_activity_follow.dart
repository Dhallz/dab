import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Upserts a Dashboard object Follow pin for the caller.
class SaveActivityFollow {
  SaveActivityFollow(this._follows);

  final AbsIActivityFollowRepository _follows;
  static const _uuid = Uuid();

  Future<Either<Failure, ActivityFollow>> execute({
    required String userId,
    required String providerId,
    required String objectKey,
  }) async {
    final parsed = _parseFollowTarget(providerId, objectKey);
    if (parsed == null) {
      return const Left(
        ValidationFailure(
          'Follow is only available for Phorge, Jira, Linear, Slack, and Discord',
        ),
      );
    }
    final now = DateTime.now().toUtc();
    final follow = ActivityFollow(
      id: _uuid.v5(
        Namespace.url.value,
        'follow|$userId|${parsed.providerId}|${parsed.objectKey}',
      ),
      userId: userId,
      providerId: parsed.providerId,
      objectKey: parsed.objectKey,
      createdAt: now,
    );
    return _follows.upsert(follow);
  }
}

({String providerId, String objectKey})? _parseFollowTarget(
  String providerId,
  String objectKey,
) {
  final id = providerId.trim().toLowerCase();
  final key = objectKey.trim();
  if (!isFollowableProviderId(id) || key.isEmpty) return null;
  return (providerId: id, objectKey: key);
}
