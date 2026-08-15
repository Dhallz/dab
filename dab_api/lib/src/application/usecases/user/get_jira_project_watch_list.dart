import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/jira_project.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/ports/i_credential_resolver.dart';
import '../../../domain/ports/i_jira_project_catalog.dart';
import '../../../domain/ports/i_oauth_credential_refresher.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists Jira projects the caller can see plus instance `projectKeys`.
class GetJiraProjectWatchList {
  GetJiraProjectWatchList(
    this._resolver,
    this._catalog,
    this._configs,
    this._oauth,
  );

  final ICredentialResolver _resolver;
  final IJiraProjectCatalog _catalog;
  final AbsIProviderConfigRepository _configs;
  final IOauthCredentialRefresher _oauth;

  Future<Either<Failure, JiraProjectWatchList>> execute(String userId) async {
    var userSettingsResult = await _oauth.ensureFresh(
      userId: userId,
      providerId: 'jira',
    );
    if (userSettingsResult.isLeft()) {
      return Left(userSettingsResult.getLeft().toNullable()!);
    }
    var userSettings = userSettingsResult.getOrElse((_) => const {});
    if (userSettings.isEmpty) {
      return const Left(
        ValidationFailure('Connect Jira before choosing projects'),
      );
    }

    final orgConfigs = (await _configs.getConfigs()).getOrElse(
      (_) => const <ProviderConfig>[],
    );
    final org = orgConfigs.where((c) => c.id == 'jira').firstOrNull;

    Future<Either<Failure, List<JiraProject>>> listWith(
      Map<String, dynamic> settings,
    ) {
      final merged = _resolver.overlay(
        orgSettings: org?.settings ?? const {},
        userSettings: settings,
      );
      final instanceUrl = (settings['instanceUrl'] ?? '').toString().trim();
      if (instanceUrl.isNotEmpty) {
        merged['instanceUrl'] = instanceUrl;
      }
      return _catalog.listAccessible(settings: merged, orgConfig: org);
    }

    var listed = await listWith(userSettings);
    if (listed.isLeft() &&
        _isUnauthorized(listed.getLeft().toNullable()!) &&
        isOauthCredential(userSettings)) {
      userSettingsResult = await _oauth.ensureFresh(
        userId: userId,
        providerId: 'jira',
        force: true,
      );
      if (userSettingsResult.isRight()) {
        userSettings = userSettingsResult.getOrElse((_) => userSettings);
        listed = await listWith(userSettings);
      }
    }
    if (listed.isLeft()) {
      final failure = listed.getLeft().toNullable()!;
      if (_isUnauthorized(failure)) {
        return const Left(
          ValidationFailure(
            'Jira could not list projects. Add read:jira-work on the Atlassian app, then Connect with Jira again.',
          ),
        );
      }
      return Left(failure);
    }

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

bool _isUnauthorized(Failure failure) {
  final message = failure.message.toLowerCase();
  return message.contains('http 401') ||
      message.contains('http 403') ||
      message.contains('unauthorized');
}
