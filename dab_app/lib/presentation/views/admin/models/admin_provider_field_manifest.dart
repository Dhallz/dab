import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'admin_config_field.dart';

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Groups Admin provider config fields into Core / Live / Polling sections.
enum ProviderConfigSection { core, live, polling }

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Field manifest per provider id for sectioned Admin cards.
class ProviderFieldManifest {
  static AdminConfigField webhookEndpointField(AppLocalizations l10n) {
    return AdminConfigField(
      key: 'webhookUrl',
      label: l10n.adminFieldWebhookEndpointUrl,
    );
  }

  static Map<ProviderConfigSection, List<AdminConfigField>> forProvider(
    String providerId,
    AppLocalizations l10n,
  ) {
    final lowerId = providerId.toLowerCase();

    if (lowerId.contains('phorge') || lowerId.contains('phabricator')) {
      return {
        ProviderConfigSection.core: [
          AdminConfigField(key: 'api.token', label: l10n.adminFieldApiTokenOrSecret, isSecret: true),
        ],
        ProviderConfigSection.live: [
          webhookEndpointField(l10n),
          AdminConfigField(key: 'webhookHmacKey', label: 'Webhook HMAC Key', isSecret: true),
        ],
        ProviderConfigSection.polling: [
          AdminConfigField(key: 'project', label: 'Project PHID / Tag'),
        ],
      };
    }
    if (lowerId.contains('slack')) {
      return {
        ProviderConfigSection.core: [
          AdminConfigField(key: 'botToken', label: l10n.adminFieldBotToken, isSecret: true),
          AdminConfigField(key: 'workspaceId', label: l10n.adminFieldWorkspaceTeamId),
          AdminConfigField(key: 'apiBaseUrl', label: l10n.adminFieldSlackApiBaseOptional),
        ],
        ProviderConfigSection.live: [
          webhookEndpointField(l10n),
          AdminConfigField(key: 'signingSecret', label: l10n.adminFieldSigningSecret, isSecret: true),
        ],
        ProviderConfigSection.polling: [
          AdminConfigField(key: 'channels', label: l10n.adminFieldChannelIdsOnePerLine),
        ],
      };
    }
    if (lowerId.contains('discord')) {
      return {
        ProviderConfigSection.core: [
          AdminConfigField(key: 'botToken', label: l10n.adminFieldBotToken, isSecret: true),
          AdminConfigField(key: 'guildId', label: l10n.adminFieldGuildServerId),
        ],
        ProviderConfigSection.live: const [],
        ProviderConfigSection.polling: [
          AdminConfigField(key: 'channels', label: l10n.adminFieldChannelIdsOnePerLine),
        ],
      };
    }
    if (lowerId.contains('github')) {
      return {
        ProviderConfigSection.core: [
          AdminConfigField(key: 'api.token', label: l10n.adminFieldPersonalAccessToken, isSecret: true),
          AdminConfigField(key: 'apiBaseUrl', label: l10n.adminFieldGithubApiBaseOptional),
        ],
        ProviderConfigSection.live: [
          webhookEndpointField(l10n),
          AdminConfigField(key: 'webhookSecret', label: l10n.adminFieldWebhookSecret, isSecret: true),
        ],
        ProviderConfigSection.polling: [
          AdminConfigField(key: 'owner', label: l10n.adminFieldRepositoryOwner),
          AdminConfigField(key: 'repo', label: l10n.adminFieldRepositoryName),
          AdminConfigField(key: 'repos', label: l10n.adminFieldRepositoriesOnePerLine),
          AdminConfigField(key: 'branch', label: l10n.adminFieldBranchOptional),
        ],
      };
    }
    if (lowerId.contains('gitlab')) {
      return {
        ProviderConfigSection.core: [
          AdminConfigField(key: 'apiToken', label: l10n.adminFieldApiToken, isSecret: true),
          AdminConfigField(key: 'instanceUrl', label: l10n.adminFieldGitLabInstanceUrl),
        ],
        ProviderConfigSection.live: [
          webhookEndpointField(l10n),
          AdminConfigField(key: 'webhookSecret', label: l10n.adminFieldWebhookSecret, isSecret: true),
        ],
        ProviderConfigSection.polling: [
          AdminConfigField(key: 'projects', label: 'Projects (group/project, one per line)'),
          AdminConfigField(key: 'branch', label: l10n.adminFieldBranchOptional),
        ],
      };
    }
    if (lowerId.contains('bitbucket')) {
      return {
        ProviderConfigSection.core: [
          AdminConfigField(key: 'username', label: 'Username'),
          AdminConfigField(key: 'apiToken', label: 'App password / API token', isSecret: true),
          AdminConfigField(key: 'workspace', label: 'Workspace'),
        ],
        ProviderConfigSection.live: [
          webhookEndpointField(l10n),
          AdminConfigField(key: 'webhookSecret', label: l10n.adminFieldWebhookSecret, isSecret: true),
        ],
        ProviderConfigSection.polling: [
          AdminConfigField(key: 'repos', label: l10n.adminFieldRepositoriesOnePerLine),
        ],
      };
    }
    if (lowerId.contains('jira')) {
      return {
        ProviderConfigSection.core: [
          AdminConfigField(key: 'apiToken', label: l10n.adminFieldApiToken, isSecret: true),
          AdminConfigField(key: 'email', label: 'Email'),
          AdminConfigField(key: 'instanceUrl', label: 'Instance URL'),
        ],
        ProviderConfigSection.live: [
          webhookEndpointField(l10n),
          AdminConfigField(key: 'webhookSecret', label: l10n.adminFieldWebhookSecret, isSecret: true),
        ],
        ProviderConfigSection.polling: [
          AdminConfigField(key: 'projectKeys', label: 'Project keys (one per line)'),
        ],
      };
    }
    if (lowerId.contains('linear')) {
      return {
        ProviderConfigSection.core: [
          AdminConfigField(key: 'apiKey', label: 'API Key', isSecret: true),
        ],
        ProviderConfigSection.live: [
          webhookEndpointField(l10n),
          AdminConfigField(key: 'webhookSecret', label: l10n.adminFieldWebhookSecret, isSecret: true),
        ],
        ProviderConfigSection.polling: const [],
      };
    }

    return {
      ProviderConfigSection.core: [
        AdminConfigField(key: 'token', label: l10n.adminFieldApiTokenOrSecret, isSecret: true),
      ],
      ProviderConfigSection.live: const [],
      ProviderConfigSection.polling: const [],
    };
  }
}
