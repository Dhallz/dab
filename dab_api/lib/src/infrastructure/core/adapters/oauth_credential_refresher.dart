import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/oauth_providers.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/user_provider_credential.dart';
import '../../../domain/contracts/ports/abs_i_oauth_client_credential_resolver.dart';
import '../../../domain/contracts/ports/abs_i_oauth_credential_refresher.dart';
import '../../../domain/contracts/ports/abs_i_oauth_token_client.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_provider_credential_repository.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Refreshes expired OAuth access tokens and writes the new secrets back.
/// CONSTRAINTS: Never logs tokens. Skips non-OAuth credentials.
class OauthCredentialRefresher implements AbsIOauthCredentialRefresher {
  OauthCredentialRefresher(
    this._credentials,
    this._configs,
    this._apps,
    this._tokens, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AbsIUserProviderCredentialRepository _credentials;
  final AbsIProviderConfigRepository _configs;
  final AbsIOauthClientCredentialResolver _apps;
  final AbsIOauthTokenClient _tokens;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, Map<String, dynamic>>> ensureFresh({
    required String userId,
    required String providerId,
    bool force = false,
  }) async {
    final id = providerId.trim().toLowerCase();
    final got = await _credentials.get(userId: userId, providerId: id);
    if (got.isLeft()) return Left(got.getLeft().toNullable()!);
    final row = got.getOrElse((_) => null);
    if (row == null) return const Right({});

    final settings = Map<String, dynamic>.from(row.settings);
    if (!isOauthCredential(settings)) return Right(settings);

    final refreshToken = (settings['refreshToken'] ?? '').toString().trim();
    final expired = oauthAccessTokenIsExpired(settings, now: _now());
    final needsRefresh =
        force || oauthAccessTokenNeedsRefresh(settings, now: _now());

    if (!needsRefresh && !expired) return Right(settings);

    if (refreshToken.isEmpty) {
      if (expired || force) {
        return Left(ValidationFailure(_expiredMessage(id)));
      }
      return Right(settings);
    }

    final configs = (await _configs.getConfigs()).getOrElse(
      (_) => const <ProviderConfig>[],
    );
    final org = configs.where((c) => c.id == id).firstOrNull;
    final instanceUrl =
        (settings['instanceUrl'] ??
                org?.settings['instanceUrl'] ??
                org?.baseUrl ??
                '')
            .toString();
    final spec = oauthSpecFor(id, instanceUrl: instanceUrl);
    if (spec == null) return Right(settings);

    final apps = _apps.resolve(
      providerId: id,
      orgSettings: org?.settings ?? const {},
    );
    if (apps == null || apps.clientId.isEmpty) {
      return Left(ValidationFailure(_expiredMessage(id)));
    }

    final refreshed = await _tokens.refreshAccessToken(
      spec: spec,
      clientId: apps.clientId,
      clientSecret: apps.clientSecret,
      refreshToken: refreshToken,
    );
    if (refreshed.isLeft()) {
      return Left(ValidationFailure(_expiredMessage(id)));
    }
    final tokens = refreshed.getOrElse((l) => throw StateError(l.message));

    settings[spec.accessTokenSettingKey] = tokens.accessToken;
    if (tokens.refreshToken != null && tokens.refreshToken!.trim().isNotEmpty) {
      settings['refreshToken'] = tokens.refreshToken;
    }
    if (tokens.expiresIn != null) {
      settings['tokenExpiresAt'] = _now()
          .toUtc()
          .add(Duration(seconds: tokens.expiresIn!))
          .toIso8601String();
    }

    final saved = await _credentials.save(
      UserProviderCredential(
        id: row.id,
        userId: row.userId,
        providerId: row.providerId,
        settings: settings,
        status: row.status,
        createdAt: row.createdAt,
        updatedAt: _now().toUtc(),
      ),
    );
    if (saved.isLeft()) return Left(saved.getLeft().toNullable()!);
    return Right(settings);
  }

  String _expiredMessage(String providerId) {
    switch (providerId) {
      case 'jira':
        return 'Jira sign-in expired. Disconnect and Connect with Jira again.';
      case 'linear':
        return 'Linear sign-in expired. Disconnect and Connect with Linear again.';
      default:
        return 'Sign-in expired. Disconnect and Connect again.';
    }
  }
}
