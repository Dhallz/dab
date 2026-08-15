import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/ports/webhook_auth_input.dart';
import 'package:dab_api/src/domain/ports/webhook_auth_status.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/infrastructure/core/security/github_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/linear_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/phorge_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/shared_secret_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/slack_request_verifier.dart';
import 'package:dab_api/src/infrastructure/services/webhook_request_authenticator.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

void main() {
  late _MockConfigs configs;
  late WebhookRequestAuthenticator authenticator;

  setUp(() {
    configs = _MockConfigs();
    authenticator = WebhookRequestAuthenticator(
      configs,
      SlackRequestVerifier(),
      GitHubWebhookVerifier(),
      PhorgeWebhookVerifier(),
      LinearWebhookVerifier(),
      SharedSecretVerifier(),
    );
  });

  test('GitHub HMAC returns ok for a matching signature', () async {
    const body = '{"action":"push"}';
    const secret = 'webhook_secret';
    final digest = Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(body));
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        const ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
          settings: {'webhookSecret': secret},
        ),
      ]),
    );

    final status = await authenticator.authenticate(
      WebhookAuthInput(
        providerId: 'github',
        body: body,
        signatureHeader: 'sha256=$digest',
      ),
    );

    expect(status, WebhookAuthStatus.ok);
  });

  test('returns missingSecret when the provider has no Live secret', () async {
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        const ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
        ),
      ]),
    );

    final status = await authenticator.authenticate(
      const WebhookAuthInput(providerId: 'github', body: '{}'),
    );

    expect(status, WebhookAuthStatus.missingSecret);
  });

  test('GitLab shared token compares constant-time', () async {
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        const ProviderConfig(
          id: 'gitlab',
          name: 'GitLab',
          baseUrl: 'https://gitlab.com',
          settings: {'webhookSecret': 'gitlab-token'},
        ),
      ]),
    );

    final ok = await authenticator.authenticate(
      const WebhookAuthInput(
        providerId: 'gitlab',
        sharedSecretHeader: 'gitlab-token',
      ),
    );
    final invalid = await authenticator.authenticate(
      const WebhookAuthInput(
        providerId: 'gitlab',
        sharedSecretHeader: 'wrong',
      ),
    );

    expect(ok, WebhookAuthStatus.ok);
    expect(invalid, WebhookAuthStatus.invalid);
  });

  test('Jira accepts shared-secret fallback when HMAC is absent', () async {
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        const ProviderConfig(
          id: 'jira',
          name: 'Jira',
          baseUrl: 'https://example.atlassian.net',
          settings: {'webhookSecret': 'jira-secret'},
        ),
      ]),
    );

    final status = await authenticator.authenticate(
      const WebhookAuthInput(
        providerId: 'jira',
        body: '{"webhookEvent":"jira:issue_updated"}',
        sharedSecretQuery: 'jira-secret',
      ),
    );

    expect(status, WebhookAuthStatus.ok);
  });
}
