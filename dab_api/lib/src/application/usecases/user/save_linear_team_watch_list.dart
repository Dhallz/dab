import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/linear_team.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/ports/i_credential_resolver.dart';
import '../../../domain/ports/i_linear_team_catalog.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Saves instance Linear `teamKeys` after the caller has connected Linear.
class SaveLinearTeamWatchList {
  SaveLinearTeamWatchList(this._resolver, this._catalog, this._configs);

  final ICredentialResolver _resolver;
  final ILinearTeamCatalog _catalog;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, LinearTeamWatchList>> execute({
    required String userId,
    required List<String> teamKeys,
  }) async {
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
    final allowed = {for (final t in available) t.key};
    final selected = parseLinearTeamKeys(
      teamKeys,
    ).where(allowed.contains).toList();

    final nextSettings = Map<String, dynamic>.from(org?.settings ?? const {});
    nextSettings['teamKeys'] = selected.join('\n');

    final base =
        org ??
        const ProviderConfig(
          id: 'linear',
          name: 'Linear',
          baseUrl: 'https://linear.app',
          isActive: true,
        );
    final saved = await _configs.saveConfig(
      base.copyWith(isActive: true, settings: nextSettings),
    );
    if (saved.isLeft()) return Left(saved.getLeft().toNullable()!);

    return Right(LinearTeamWatchList(available: available, selected: selected));
  }
}
