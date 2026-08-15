import 'package:fpdart/fpdart.dart';

import '../../../domain/core/bitbucket_scope.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/github_scope.dart';
import '../../../domain/core/gitlab_scope.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/provider_whoami_result.dart';
import '../../../domain/entities/user/user_identity.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/entities/user/user_provider_credential.dart';
import '../../../domain/entities/user/user_provider_credential_status.dart';
import '../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../domain/contracts/ports/i_provider_identity_probe.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_provider_credential_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Saves a self-serve provider credential, verifies whoami, links identity.
class SaveUserProviderCredential {
  SaveUserProviderCredential(
    this._credentials,
    this._users,
    this._configs,
    this._probe,
  );

  final AbsIUserProviderCredentialRepository _credentials;
  final IUserRepository _users;
  final AbsIProviderConfigRepository _configs;
  final IProviderIdentityProbe _probe;

  Future<Either<Failure, UserProviderCredentialSummary>> execute({
    required String userId,
    required String providerId,
    required Map<String, dynamic> settings,
  }) async {
    final id = providerId.trim().toLowerCase();
    if (!isKnownProviderId(id)) {
      return const Left(ValidationFailure('Unknown provider'));
    }

    final configsResult = await _configs.getConfigs();
    final orgConfig = configsResult
        .getOrElse((_) => const <ProviderConfig>[])
        .where((c) => c.id == id)
        .firstOrNull;

    final merged = overlayProviderSecrets(
      orgSettings: orgConfig?.settings ?? const {},
      userSettings: settings,
    );
    // Incoming settings always win for secrets even when overlay skipped empty.
    settings.forEach((key, value) {
      if (value == null) return;
      if (kProviderSecretSettingKeys.contains(key) || key.startsWith('api.')) {
        merged[key] = value;
      }
      if (key == 'instanceUrl' ||
          key == 'apiBaseUrl' ||
          key == 'projectKeys' ||
          key == 'teamKeys' ||
          key == 'workspace' ||
          key == 'guildId' ||
          key == 'channels' ||
          key == 'tokenType' ||
          key == 'tokenExpiresAt' ||
          key == 'cloudId') {
        merged[key] = value;
      }
    });

    final probeResult = await _probe.probe(
      providerId: id,
      settings: merged,
      orgConfig: orgConfig,
    );
    if (probeResult.isLeft()) {
      return Left(probeResult.getLeft().toNullable()!);
    }
    final whoami = probeResult.getOrElse((l) => throw StateError(l.message));

    if (isBotSharedProvider(id)) {
      return _saveSharedBot(
        userId: userId,
        providerId: id,
        orgConfig: orgConfig,
        merged: merged,
        whoami: whoami,
      );
    }
    return _savePersonal(
      userId: userId,
      providerId: id,
      orgConfig: orgConfig,
      settings: settings,
      merged: merged,
      whoami: whoami,
    );
  }

  Future<Either<Failure, UserProviderCredentialSummary>> _savePersonal({
    required String userId,
    required String providerId,
    required ProviderConfig? orgConfig,
    required Map<String, dynamic> settings,
    required Map<String, dynamic> merged,
    required ProviderWhoamiResult whoami,
  }) async {
    final now = DateTime.now().toUtc();
    final existing = await _credentials.get(
      userId: userId,
      providerId: providerId,
    );
    final previous = existing.getOrElse((_) => null);
    final credential = UserProviderCredential(
      id: previous?.id ?? '${userId}_$providerId',
      userId: userId,
      providerId: providerId,
      settings: _secretOnly(settings),
      status: UserProviderCredentialStatus.connected,
      createdAt: previous?.createdAt ?? now,
      updatedAt: now,
    );
    final saved = await _credentials.save(credential);
    if (saved.isLeft()) return Left(saved.getLeft().toNullable()!);

    final identity = UserIdentity(
      id: '${userId}_$providerId',
      userId: userId,
      providerId: providerId,
      externalId: whoami.externalId,
      externalUsername: whoami.externalUsername?.trim().isEmpty == true
          ? null
          : whoami.externalUsername?.trim(),
      status: UserIdentityStatus.linked,
      createdAt: now,
      updatedAt: now,
    );
    await _users.linkIdentity(identity);

    await _ensureActiveConfig(
      providerId: providerId,
      orgConfig: orgConfig,
      merged: merged,
      discovered: whoami.discoveredWatchList,
    );

    return Right(
      UserProviderCredentialSummary(
        providerId: providerId,
        status: UserProviderCredentialStatus.connected,
        hasSecret: true,
        externalId: whoami.externalId,
        externalUsername: whoami.externalUsername,
        updatedAt: now,
      ),
    );
  }

  Future<Either<Failure, UserProviderCredentialSummary>> _saveSharedBot({
    required String userId,
    required String providerId,
    required ProviderConfig? orgConfig,
    required Map<String, dynamic> merged,
    required ProviderWhoamiResult whoami,
  }) async {
    final now = DateTime.now().toUtc();
    final base =
        orgConfig ??
        ProviderConfig(
          id: providerId,
          name: providerId,
          baseUrl: providerId == 'slack'
              ? 'https://slack.com'
              : 'https://discord.com',
          isActive: true,
        );
    final nextSettings = Map<String, dynamic>.from(base.settings)
      ..addAll({
        for (final key in [
          'botToken',
          'api.token',
          'token',
          'signingSecret',
          'workspaceId',
          'guildId',
          'channels',
          'apiBaseUrl',
        ])
          if (merged[key] != null) key: merged[key],
      });
    final savedConfig = await _configs.saveConfig(
      base.copyWith(settings: nextSettings, isActive: true),
    );
    if (savedConfig.isLeft()) {
      return Left(savedConfig.getLeft().toNullable()!);
    }

    final credential = UserProviderCredential(
      id: '${userId}_$providerId',
      userId: userId,
      providerId: providerId,
      settings: _secretOnly(merged),
      status: UserProviderCredentialStatus.connected,
      createdAt: now,
      updatedAt: now,
    );
    await _credentials.save(credential);

    return Right(
      UserProviderCredentialSummary(
        providerId: providerId,
        status: UserProviderCredentialStatus.connected,
        hasSecret: true,
        isSharedBot: true,
        externalId: whoami.externalId,
        externalUsername: whoami.externalUsername,
        updatedAt: now,
      ),
    );
  }

  Future<void> _ensureActiveConfig({
    required String providerId,
    required ProviderConfig? orgConfig,
    required Map<String, dynamic> merged,
    required List<String> discovered,
  }) async {
    final base =
        orgConfig ??
        ProviderConfig(
          id: providerId,
          name: providerId,
          baseUrl: _defaultBaseUrl(providerId, merged),
          isActive: true,
        );
    final next = Map<String, dynamic>.from(base.settings);
    if (merged['instanceUrl'] != null) {
      next['instanceUrl'] = merged['instanceUrl'];
    }
    if (merged['apiBaseUrl'] != null) {
      next['apiBaseUrl'] = merged['apiBaseUrl'];
    }
    if (merged['projectKeys'] != null) {
      next['projectKeys'] = merged['projectKeys'];
    }
    if (merged['workspace'] != null) {
      next['workspace'] = merged['workspace'];
    }

    if (discovered.isNotEmpty) {
      if (providerId == 'github') {
        final existing = extractConfiguredGithubRepos(next);
        if (existing.isEmpty) {
          next['repos'] = discovered.take(25).toList();
        }
      } else if (providerId == 'gitlab') {
        final existing = gitLabProjects(next);
        if (existing.isEmpty) {
          next['projects'] = discovered.take(25).toList();
        }
      } else if (providerId == 'bitbucket') {
        final existing = bitbucketRepos(next);
        if (existing.isEmpty) {
          next['repos'] = discovered.take(25).toList();
          final first = discovered.first;
          if (first.contains('/') &&
              (next['workspace'] == null ||
                  next['workspace'].toString().trim().isEmpty)) {
            next['workspace'] = first.split('/').first;
          }
        }
      } else if (providerId == 'linear') {
        final existing = (next['teamKeys'] ?? '').toString().trim();
        if (existing.isEmpty) {
          next['teamKeys'] = discovered.take(25).join('\n');
        }
      } else if (providerId == 'jira') {
        final existing = (next['projectKeys'] ?? '').toString().trim();
        if (existing.isEmpty) {
          next['projectKeys'] = discovered.take(25).join('\n');
        }
      }
    }

    var baseUrl = base.baseUrl;
    if (providerId == 'jira') {
      final instance = (merged['instanceUrl'] ?? '').toString().trim();
      if (instance.isNotEmpty) baseUrl = instance;
    }

    await _configs.saveConfig(
      base.copyWith(isActive: true, settings: next, baseUrl: baseUrl),
    );
  }

  Map<String, dynamic> _secretOnly(Map<String, dynamic> incoming) {
    final out = <String, dynamic>{};
    for (final key in incoming.keys) {
      if (kProviderSecretSettingKeys.contains(key) || key.startsWith('api.')) {
        final value = incoming[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          out[key] = value;
        }
      }
      if (key == 'instanceUrl' ||
          key == 'apiBaseUrl' ||
          key == 'projectKeys' ||
          key == 'teamKeys' ||
          key == 'workspace' ||
          key == 'guildId' ||
          key == 'channels' ||
          key == 'tokenType' ||
          key == 'tokenExpiresAt' ||
          key == 'cloudId') {
        final value = incoming[key];
        if (value != null) out[key] = value;
      }
    }
    return out;
  }

  String _defaultBaseUrl(String providerId, Map<String, dynamic> merged) {
    switch (providerId) {
      case 'github':
        return 'https://github.com';
      case 'gitlab':
        return (merged['instanceUrl'] ?? 'https://gitlab.com').toString();
      case 'bitbucket':
        return 'https://bitbucket.org';
      case 'jira':
        return (merged['instanceUrl'] ?? 'https://atlassian.net').toString();
      case 'linear':
        return 'https://linear.app';
      case 'phorge':
        return 'https://phorge.example.com';
      default:
        return 'https://example.com';
    }
  }
}
