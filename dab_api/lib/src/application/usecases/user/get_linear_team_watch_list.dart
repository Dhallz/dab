import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/linear_team.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/ports/i_credential_resolver.dart';
import '../../../domain/ports/i_linear_team_catalog.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists Linear teams the caller can see plus instance `teamKeys`.
class GetLinearTeamWatchList {
  GetLinearTeamWatchList(this._resolver, this._catalog, this._configs);

  final ICredentialResolver _resolver;
  final ILinearTeamCatalog _catalog;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, LinearTeamWatchList>> execute(String userId) async {
    final userSettings = await _resolver.getUserSettings(
      userId: userId,
      providerId: 'linear',
    );
    if (userSettings == null || userSettings.isEmpty) {
      return const Left(
        ValidationFailure('Connect Linear before choosing teams'),
      );
    }

    final configs = (await _configs.getConfigs()).getOrElse(
      (_) => const <ProviderConfig>[],
    );
    final org = configs.where((c) => c.id == 'linear').firstOrNull;
    final merged = _resolver.overlay(
      orgSettings: org?.settings ?? const {},
      userSettings: userSettings,
    );

    final listed = await _catalog.listAccessible(
      settings: merged,
      orgConfig: org,
    );
    if (listed.isLeft()) return Left(listed.getLeft().toNullable()!);
    final available = listed.getOrElse((_) => const <LinearTeam>[]);
    final selected = parseLinearTeamKeys(org?.settings['teamKeys']);
    final byKey = {for (final team in available) team.key: team};
    for (final key in selected) {
      byKey.putIfAbsent(key, () => LinearTeam(key: key, name: key));
    }
    final mergedAvailable = byKey.values.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Right(
      LinearTeamWatchList(available: mergedAvailable, selected: selected),
    );
  }
}
