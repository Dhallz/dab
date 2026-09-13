import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Saves which Jira projects DAB should fetch issues from.
class SaveMyJiraProjects {
  final IUserRepository repository;

  SaveMyJiraProjects(this.repository);

  Future<Either<AppFailure, JiraProjectWatchList>> execute({
    required List<String> projectKeys,
  }) =>
      repository.saveMyJiraProjects(projectKeys: projectKeys);
}
