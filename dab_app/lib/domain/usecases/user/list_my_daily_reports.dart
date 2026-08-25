import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Lists org-calendar dates with a saved daily report for the caller.
class ListMyDailyReports {
  final IUserRepository repository;

  ListMyDailyReports(this.repository);

  Future<Either<AppFailure, List<String>>> execute() =>
      repository.listMyDailyReports();
}
