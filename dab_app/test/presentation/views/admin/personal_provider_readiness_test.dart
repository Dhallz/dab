import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/admin/models/personal_provider_readiness.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GitHub is ready when OAuth client id and secret are saved', () {
    const config = ProviderConfig(
      id: 'github',
      name: 'GitHub',
      baseUrl: 'https://github.com',
      isActive: true,
      settings: {'clientId': 'iv1.abc', 'clientSecret': 's3cret'},
    );
    final ready = personalProviderReadiness(config);
    expect(ready.status, ViewStatus.success);
  });

  test('GitHub is not ready with only an org PAT leftover', () {
    const config = ProviderConfig(
      id: 'github',
      name: 'GitHub',
      baseUrl: 'https://github.com',
      isActive: true,
      settings: {'api.token': 'ghp_not_used_in_personal'},
    );
    final ready = personalProviderReadiness(config);
    expect(ready.status, ViewStatus.failure);
  });

  test('Slack is ready from a bot token, not a user PAT', () {
    const config = ProviderConfig(
      id: 'slack',
      name: 'Slack',
      baseUrl: 'https://slack.com',
      isActive: true,
      settings: {'botToken': 'xoxb-test'},
    );
    expect(personalProviderReadiness(config).status, ViewStatus.success);
  });

  test('Discord needs bot token and guild id', () {
    const missingGuild = ProviderConfig(
      id: 'discord',
      name: 'Discord',
      baseUrl: 'https://discord.com',
      isActive: true,
      settings: {'botToken': 'bot'},
    );
    expect(personalProviderReadiness(missingGuild).status, ViewStatus.failure);

    const complete = ProviderConfig(
      id: 'discord',
      name: 'Discord',
      baseUrl: 'https://discord.com',
      isActive: true,
      settings: {'botToken': 'bot', 'guildId': '123'},
    );
    expect(personalProviderReadiness(complete).status, ViewStatus.success);
  });

  test('Phorge is ready when a real instance URL is saved', () {
    const placeholder = ProviderConfig(
      id: 'phorge',
      name: 'Phorge',
      baseUrl: 'https://phorge.example.com',
      isActive: true,
    );
    expect(personalProviderReadiness(placeholder).status, ViewStatus.failure);

    const configured = ProviderConfig(
      id: 'phorge',
      name: 'Phorge',
      baseUrl: 'https://phorge.example.com',
      isActive: true,
      settings: {'instanceUrl': 'https://secure.phorge.internal'},
    );
    expect(personalProviderReadiness(configured).status, ViewStatus.success);
  });
}
