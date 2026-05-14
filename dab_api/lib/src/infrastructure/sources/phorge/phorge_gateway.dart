import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_user/phorge_user_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/gataways/abs_i_phorge_gataway.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_project_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_user_source.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_GATEWAY]
/// ROLE: Consolidated Phorge Conduit read surface for domain [AbsIPhorgeGateway].
/// CONTRACT: Delegates to sources; returns decoded Conduit row DTOs without secondary projections.
/// CONSTRAINTS: No remote writes.
class PhorgeGateway implements AbsIPhorgeGateway {
  final PhorgeUserSource _userSource;
  final PhorgeTaskSource _taskSource;
  final PhorgeRevisionSource _revisionSource;
  final PhorgeProjectSource _projectSource;

  PhorgeGateway({
    required PhorgeUserSource userSource,
    required PhorgeTaskSource taskSource,
    required PhorgeRevisionSource revisionSource,
    required PhorgeProjectSource projectSource,
  }) : _userSource = userSource,
       _taskSource = taskSource,
       _revisionSource = revisionSource,
       _projectSource = projectSource;

  @override
  Future<Either<Failure, List<PhorgeUserDto>>> fetchDirectoryUsers() {
    return _userSource.fetchDirectoryUsers();
  }

  @override
  Future<Either<Failure, List<PhorgeProjectDto>>> fetchActiveSprintProjects(
    String userPhid,
  ) async {
    try {
      final dtos = await _projectSource.fetchActiveSprintProjects(userPhid);
      return Right(dtos);
    } catch (e) {
      return Left(DatabaseFailure('Phorge sprint project fetch failed: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> fetchProjectPhidByTag(String tag) async {
    try {
      final phid = await _projectSource.fetchProjectPhidByTag(tag);
      return Right(phid);
    } catch (e) {
      return Left(DatabaseFailure('Phorge project tag lookup failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PhorgeTaskBundleDto>>> fetchTaskBundles({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  }) async {
    try {
      final bundles = await _taskSource.fetchRawData(
        users,
        start,
        end,
        authoredOnly,
      );
      return Right(bundles);
    } catch (e) {
      return Left(DatabaseFailure('Phorge task bundle fetch failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PhorgeRevisionDto>>> fetchRevisionDtos({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  }) async {
    try {
      final rows = await _revisionSource.fetchRawData(
        users,
        start,
        end,
        authoredOnly,
      );
      return Right(rows);
    } catch (e) {
      return Left(DatabaseFailure('Phorge revision fetch failed: $e'));
    }
  }
}
