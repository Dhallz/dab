import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'get_linear_team_watch_list.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Saves instance Linear `teamKeys` after the caller has connected Linear.
class SaveLinearTeamWatchList {
  SaveLinearTeamWatchList(this._get, this._configs);

  final GetLinearTeamWatchList _get;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, LinearTeamWatchList>> execute({
    required String userId,
    required List<String> teamKeys,
  }) async {
    final listed = await _get.execute(userId);
    if (listed.isLeft()) return Left(listed.getLeft().toNullable()!);
    final watch = listed.getOrElse((_) => throw StateError('watch list'));
    final allowed = {for (final t in watch.available) t.key};
    final selected = parseLinearTeamKeys(
      teamKeys,
    ).where(allowed.contains).toList();

    final configs = (await _configs.getConfigs()).getOrElse(
      (_) => const <ProviderConfig>[],
    );
    final org = configs.where((c) => c.id == 'linear').firstOrNull;
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

    return Right(
      LinearTeamWatchList(available: watch.available, selected: selected),
    );
  }
}
