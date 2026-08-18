import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/linear_team.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/contracts/ports/abs_i_credential_resolver.dart';
import '../../../domain/contracts/ports/abs_i_linear_team_catalog.dart';
import '../../../domain/contracts/ports/abs_i_oauth_credential_refresher.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists Linear teams the caller can see plus instance `teamKeys`.
class GetLinearTeamWatchList {
  GetLinearTeamWatchList(
    this._resolver,
    this._catalog,
    this._configs,
    this._oauth,
  );

  final AbsICredentialResolver _resolver;
  final AbsILinearTeamCatalog _catalog;
  final AbsIProviderConfigRepository _configs;
  final AbsIOauthCredentialRefresher _oauth;

  Future<Either<Failure, LinearTeamWatchList>> execute(String userId) async {
    var userSettingsResult = await _oauth.ensureFresh(
      userId: userId,
      providerId: 'linear',
    );
    if (userSettingsResult.isLeft()) {
      return Left(userSettingsResult.getLeft().toNullable()!);
    }
    var userSettings = userSettingsResult.getOrElse((_) => const {});
    if (userSettings.isEmpty) {
      return const Left(
        ValidationFailure('Connect Linear before choosing teams'),
      );
    }

    final orgConfigs = (await _configs.getConfigs()).getOrElse(
      (_) => const <ProviderConfig>[],
    );
    final org = orgConfigs.where((c) => c.id == 'linear').firstOrNull;

    Future<Either<Failure, List<LinearTeam>>> listWith(
      Map<String, dynamic> settings,
    ) {
      final merged = _resolver.overlay(
        orgSettings: org?.settings ?? const {},
        userSettings: settings,
      );
      return _catalog.listAccessible(settings: merged, orgConfig: org);
    }

    var listed = await listWith(userSettings);
    if (listed.isLeft() &&
        _isUnauthorized(listed.getLeft().toNullable()!) &&
        isOauthCredential(userSettings)) {
      userSettingsResult = await _oauth.ensureFresh(
        userId: userId,
        providerId: 'linear',
        force: true,
      );
      if (userSettingsResult.isRight()) {
        userSettings = userSettingsResult.getOrElse((_) => userSettings);
        listed = await listWith(userSettings);
      }
    }
    if (listed.isLeft()) {
      return Left(listed.getLeft().toNullable()!);
    }

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

bool _isUnauthorized(Failure failure) {
  final message = failure.message.toLowerCase();
  return message.contains('http 401') ||
      message.contains('http 403') ||
      message.contains('unauthorized');
}
