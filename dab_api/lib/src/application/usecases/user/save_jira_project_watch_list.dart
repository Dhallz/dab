import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/contracts/ports/abs_i_credential_resolver.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'get_jira_project_watch_list.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Saves instance Jira `projectKeys` after the caller has connected Jira.
class SaveJiraProjectWatchList {
  SaveJiraProjectWatchList(this._get, this._configs, this._resolver);

  final GetJiraProjectWatchList _get;
  final AbsIProviderConfigRepository _configs;
  final AbsICredentialResolver _resolver;

  Future<Either<Failure, JiraProjectWatchList>> execute({
    required String userId,
    required List<String> projectKeys,
  }) async {
    final listed = await _get.execute(userId);
    if (listed.isLeft()) return Left(listed.getLeft().toNullable()!);
    final watch = listed.getOrElse((_) => throw StateError('watch list'));
    final allowed = {for (final p in watch.available) p.key};
    final selected = (projectKeys as Object?).parseJiraProjectKeys().where(allowed.contains).toList();

    final configs = (await _configs.getConfigs()).getOrElse(
      (_) => const <ProviderConfig>[],
    );
    final org = configs.where((c) => c.id == 'jira').firstOrNull;
    final userSettings = await _resolver.getUserSettings(
      userId: userId,
      providerId: 'jira',
    );
    final instanceUrl = (userSettings?['instanceUrl'] ?? '').toString().trim();

    final nextSettings = Map<String, dynamic>.from(org?.settings ?? const {});
    nextSettings['projectKeys'] = selected.join('\n');
    if (instanceUrl.isNotEmpty) {
      nextSettings['instanceUrl'] = instanceUrl;
    }

    final base =
        org ??
        ProviderConfig(
          id: 'jira',
          name: 'Jira',
          baseUrl: instanceUrl.isNotEmpty
              ? instanceUrl
              : 'https://atlassian.net',
          isActive: true,
        );
    final saved = await _configs.saveConfig(
      base.copyWith(
        isActive: true,
        settings: nextSettings,
        baseUrl: instanceUrl.isNotEmpty ? instanceUrl : base.baseUrl,
      ),
    );
    if (saved.isLeft()) return Left(saved.getLeft().toNullable()!);

    return Right(
      JiraProjectWatchList(available: watch.available, selected: selected),
    );
  }
}
