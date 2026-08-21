import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_user/phorge_user_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Read-only Phorge Conduit facade — directory, sprint projects, tasks,
/// revisions. Delegates to per-resource sources; not a poll [AbsIActivityPort].
/// CONTRACT: Returned rows match Conduit DTO decoding (`user.search`,
/// `project.search`, …). Callers may compose multiple calls internally
/// (e.g. sprint tags) but expose API-shaped DTOs only.
/// CONSTRAINTS: No remote writes; errors return as [Either] left values.
abstract interface class AbsIPhorgeFacade {
  /// Active non-disabled rows from Conduit [`user.search`].
  Future<Either<Failure, List<PhorgeUserDto>>> fetchDirectoryUsers();

  /// Sprint-scoped [`project.search`] rows inferred from assigned open tasks plus tag metadata.
  Future<Either<Failure, List<PhorgeProjectDto>>> fetchActiveSprintProjects(
    String userPhid,
  );

  /// Looks up a project PHID by tag name (e.g. sprint label).
  Future<Either<Failure, String?>> fetchProjectPhidByTag(String tag);

  /// Transaction/task activity rows (Maniphest), bundled with sprint context tag per implementation policy.
  Future<Either<Failure, List<PhorgeTaskBundleDto>>> fetchTaskBundles({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  });

  /// Differential revision (`D…`) rows in the modification window.
  Future<Either<Failure, List<PhorgeRevisionDto>>> fetchRevisionDtos({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  });
}
