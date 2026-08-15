import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dab_app/presentation/views/admin/models/admin_provider_field_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('GitHub fields are grouped into core, live, and polling sections', () {
    final manifest = ProviderFieldManifest.forProvider('github', l10n);

    final coreKeys = manifest[ProviderConfigSection.core]!
        .map((f) => f.key)
        .toList();
    final liveKeys = manifest[ProviderConfigSection.live]!
        .map((f) => f.key)
        .toList();
    final pollingKeys = manifest[ProviderConfigSection.polling]!
        .map((f) => f.key)
        .toList();

    expect(coreKeys, contains('api.token'));
    expect(liveKeys, containsAll(['webhookUrl', 'webhookSecret']));
    expect(pollingKeys, containsAll(['owner', 'repo', 'repos', 'branch']));
    expect(liveKeys, isNot(contains('owner')));
  });

  test('personal GitHub fields are OAuth client id/secret only', () {
    final manifest = ProviderFieldManifest.forProvider(
      'github',
      l10n,
      personal: true,
    );

    final coreKeys = manifest[ProviderConfigSection.core]!
        .map((f) => f.key)
        .toList();
    expect(coreKeys, containsAll(['clientId', 'clientSecret']));
    expect(coreKeys, isNot(contains('api.token')));
    expect(manifest[ProviderConfigSection.live], isEmpty);
    expect(manifest[ProviderConfigSection.polling], isEmpty);
  });

  test('personal GitLab includes instance URL; Slack keeps bot fields', () {
    final gitlab = ProviderFieldManifest.forProvider(
      'gitlab',
      l10n,
      personal: true,
    );
    expect(
      gitlab[ProviderConfigSection.core]!.map((f) => f.key),
      containsAll(['clientId', 'clientSecret', 'instanceUrl']),
    );

    final slack = ProviderFieldManifest.forProvider(
      'slack',
      l10n,
      personal: true,
    );
    expect(
      slack[ProviderConfigSection.core]!.map((f) => f.key),
      contains('botToken'),
    );
    expect(
      slack[ProviderConfigSection.polling]!.map((f) => f.key),
      contains('channels'),
    );
  });

  test('personal Jira client ID explains 3LO vs App ID', () {
    final jira = ProviderFieldManifest.forProvider(
      'jira',
      l10n,
      personal: true,
    );
    final clientId = jira[ProviderConfigSection.core]!.firstWhere(
      (f) => f.key == 'clientId',
    );
    expect(clientId.hint, l10n.adminFieldOauthClientIdJiraHint);
  });
}
