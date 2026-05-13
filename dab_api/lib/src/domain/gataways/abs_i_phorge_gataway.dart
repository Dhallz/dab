import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision_data.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task_bundle.dart';
import 'package:dab_api/src/domain/entities/phorge/phorge_directory_user.dart';
import 'package:dab_api/src/domain/entities/phorge/phorge_project_summary.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Read-only Phorge Conduit contract — directory, sprint projects, tasks, revisions.
/// CONTRACT: Payloads mirror Conduit responses; implementations own protocol/auth and paging.
/// CONSTRAINTS: No remote writes; errors return as [Either] left values.
abstract interface class AbsIPhorgeGateway {
  /// All active directory users exposed by `user.search` (provision / identity workflows).
  Future<Either<Failure, List<PhorgeDirectoryUser>>> fetchDirectoryUsers();

  /// Sprint-scoped tags/projects inferred from assigned open tasks (`maniphest.search` + `project.search`).
  Future<Either<Failure, List<PhorgeProjectSummary>>> fetchActiveSprintProjects(
    String userPhid,
  );

  /// Looks up a project PHID by tag name (e.g. sprint label).
  Future<Either<Failure, String?>> fetchProjectPhidByTag(String tag);

  /// Transaction/task activity rows (Maniphest), bundled with sprint context tag per implementation policy.
  Future<Either<Failure, List<PhorgeTaskBundle>>> fetchTaskBundles({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  });

  /// Differential revision (`D…`) rows in the modification window.
  Future<Either<Failure, List<PhorgeRevisionData>>> fetchRevisionDtos({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  });
}
