import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/github/github_commit_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Read-only GitHub REST contract — returns commit DTOs only (no `Activity` mapping).
/// CONTRACT: Implementations resolve config, credentials, and repos in infrastructure;
/// [users] must be the DAB users relevant to this fetch; [start]/[end] bound the window.
/// CONSTRAINTS: No mutations on GitHub; failures are non-throwing via [Either].
abstract interface class AbsIGithubGateway {
  /// Fetches GitHub commit payloads for [users] in \[start, end\].
  /// [authoredOnly] restricts to commits whose author matches linked GitHub identities.
  Future<Either<Failure, List<GitHubCommitDto>>> fetchCommitDtos({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  });
}
