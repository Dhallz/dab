import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dab_app/presentation/views/admin/models/admin_provider_field_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('GitHub fields are grouped into core, live, and polling sections', () {
    final manifest = ProviderFieldManifest.forProvider('github', l10n);

    final coreKeys =
        manifest[ProviderConfigSection.core]!.map((f) => f.key).toList();
    final liveKeys =
        manifest[ProviderConfigSection.live]!.map((f) => f.key).toList();
    final pollingKeys =
        manifest[ProviderConfigSection.polling]!.map((f) => f.key).toList();

    expect(coreKeys, contains('api.token'));
    expect(liveKeys, containsAll(['webhookUrl', 'webhookSecret']));
    expect(pollingKeys, containsAll(['owner', 'repo', 'repos', 'branch']));
    expect(liveKeys, isNot(contains('owner')));
  });
}
