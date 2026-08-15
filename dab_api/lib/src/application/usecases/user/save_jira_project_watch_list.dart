import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/jira_project.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/ports/i_credential_resolver.dart';
import '../../../domain/ports/i_jira_project_catalog.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Saves instance Jira `projectKeys` after the caller has connected Jira.
class SaveJiraProjectWatchList {
  SaveJiraProjectWatchList(this._resolver, this._catalog, this._configs);

  final ICredentialResolver _resolver;
  final IJiraProjectCatalog _catalog;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, JiraProjectWatchList>> execute({
    required String userId,
    required List<String> projectKeys,
  }) async {
    final userSettings = await _resolver.getUserSettings(
      userId: userId,
      providerId: 'jira',
    );
    if (userSettings == null || userSettings.isEmpty) {
      return const Left(ValidationFailure('Connect Jira before choosing projects'));
    }

    final configs = (await _configs.getConfigs())
        .getOrElse((_) => const <ProviderConfig>[]);
    final org = configs.where((c) => c.id == 'jira').firstOrNull;
    final merged = _resolver.overlay(
      orgSettings: org?.settings ?? const {},
      userSettings: userSettings,
    );
    final instanceUrl = (userSettings['instanceUrl'] ?? '').toString().trim();
    if (instanceUrl.isNotEmpty) {
      merged['instanceUrl'] = instanceUrl;
    }

    final listed = await _catalog.listAccessible(
      settings: merged,
      orgConfig: org,
    );
    if (listed.isLeft()) return Left(listed.getLeft().toNullable()!);
    final available = listed.getOrElse((_) => const <JiraProject>[]);
    final allowed = {for (final p in available) p.key};
    final selected = parseJiraProjectKeys(projectKeys)
        .where(allowed.contains)
        .toList();

    final nextSettings = Map<String, dynamic>.from(org?.settings ?? const {});
    nextSettings['projectKeys'] = selected.join('\n');
    if (instanceUrl.isNotEmpty) {
      nextSettings['instanceUrl'] = instanceUrl;
    }

    final base = org ??
        ProviderConfig(
          id: 'jira',
          name: 'Jira',
          baseUrl: instanceUrl.isNotEmpty ? instanceUrl : 'https://atlassian.net',
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
      JiraProjectWatchList(available: available, selected: selected),
    );
  }
}
