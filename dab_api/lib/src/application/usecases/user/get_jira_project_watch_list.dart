import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/jira_project.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/ports/i_credential_resolver.dart';
import '../../../domain/ports/i_jira_project_catalog.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists Jira projects the caller can see plus instance `projectKeys`.
class GetJiraProjectWatchList {
  GetJiraProjectWatchList(this._resolver, this._catalog, this._configs);

  final ICredentialResolver _resolver;
  final IJiraProjectCatalog _catalog;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, JiraProjectWatchList>> execute(String userId) async {
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
    final selected = parseJiraProjectKeys(org?.settings['projectKeys']);
    final byKey = {for (final project in available) project.key: project};
    for (final key in selected) {
      byKey.putIfAbsent(key, () => JiraProject(key: key, name: key));
    }
    final mergedAvailable = byKey.values.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Right(
      JiraProjectWatchList(available: mergedAvailable, selected: selected),
    );
  }
}
