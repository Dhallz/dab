import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Loads Jira projects for the Settings watch-list picker.
class ListMyJiraProjects {
  final IUserRepository repository;

  ListMyJiraProjects(this.repository);

  Future<Either<AppFailure, JiraProjectWatchList>> execute() =>
      repository.listMyJiraProjects();
}
