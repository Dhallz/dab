import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Upserts a Dashboard object Follow pin for the caller.
class SaveMyActivityFollow {
  final IUserRepository repository;

  SaveMyActivityFollow(this.repository);

  Future<Either<AppFailure, ActivityFollow>> execute({
    required String providerId,
    required String objectKey,
    String? title,
    String? url,
  }) => repository.saveMyActivityFollow(
    providerId: providerId,
    objectKey: objectKey,
    title: title,
    url: url,
  );
}
