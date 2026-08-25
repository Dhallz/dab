import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Lists saved daily-report dates for a teammate (or the caller).
/// CONTRACT: Server returns 403 when a standard user lists someone else.
class ListUserDailyReports {
  final IUserRepository repository;

  ListUserDailyReports(this.repository);

  Future<Either<AppFailure, List<String>>> execute({
    required String userId,
  }) => repository.listUserDailyReports(userId: userId);
}
