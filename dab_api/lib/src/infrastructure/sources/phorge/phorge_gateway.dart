import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision_data.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task_bundle.dart';
import 'package:dab_api/src/domain/entities/phorge/phorge_directory_user.dart';
import 'package:dab_api/src/domain/entities/phorge/phorge_project_summary.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/gataways/abs_i_phorge_gataway.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_project_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_user_source.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_GATEWAY]
/// ROLE: Consolidated Phorge Conduit read surface for domain [AbsIPhorgeGateway].
/// CONTRACT: Delegates to existing sources without remote writes.
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
  })  : _userSource = userSource,
        _taskSource = taskSource,
        _revisionSource = revisionSource,
        _projectSource = projectSource;

  @override
  Future<Either<Failure, List<PhorgeDirectoryUser>>> fetchDirectoryUsers() {
    return _userSource.fetchDirectoryUsers();
  }

  @override
  Future<Either<Failure, List<PhorgeProjectSummary>>> fetchActiveSprintProjects(
    String userPhid,
  ) async {
    try {
      final dtos = await _projectSource.fetchActiveSprintProjects(userPhid);
      return Right(
        dtos
            .map(
              (p) => PhorgeProjectSummary(
                id: p.id,
                phid: p.phid,
                name: p.name,
                color: p.color,
                icon: p.icon,
              ),
            )
            .toList(),
      );
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
  Future<Either<Failure, List<PhorgeTaskBundle>>> fetchTaskBundles({
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
  Future<Either<Failure, List<PhorgeRevisionData>>> fetchRevisionDtos({
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
