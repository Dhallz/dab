import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Header-light status for Admin provider cards in personal/small-team mode.
/// CONTRACT: Green when the instance fields that personal mode actually uses
/// are present (OAuth app or workspace bot). Never probes org PATs or live ingest.
class PersonalProviderReadiness {
  const PersonalProviderReadiness({
    required this.status,
    required this.message,
  });

  final ViewStatus status;
  final String message;
}

String _setting(Map<String, dynamic> settings, List<String> keys) {
  for (final key in keys) {
    final value = settings[key];
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return '';
}

/// Readiness of [config] for personal Admin (OAuth Connect or shared bot).
PersonalProviderReadiness personalProviderReadiness(ProviderConfig config) {
  final id = config.id.trim().toLowerCase();
  final settings = config.settings;

  if (id.contains('slack')) {
    final token = _setting(settings, const ['botToken', 'api.token', 'token']);
    if (token.isNotEmpty) {
      return const PersonalProviderReadiness(
        status: ViewStatus.success,
        message: 'Workspace bot is configured',
      );
    }
    return const PersonalProviderReadiness(
      status: ViewStatus.failure,
      message: 'Add a Slack bot token',
    );
  }

  if (id.contains('discord')) {
    final token = _setting(settings, const ['botToken', 'api.token', 'token']);
    final guild = _setting(settings, const ['guildId']);
    if (token.isNotEmpty && guild.isNotEmpty) {
      return const PersonalProviderReadiness(
        status: ViewStatus.success,
        message: 'Discord bot is configured',
      );
    }
    return const PersonalProviderReadiness(
      status: ViewStatus.failure,
      message: 'Add a Discord bot token and guild ID',
    );
  }

  if (id.contains('phorge') || id.contains('phabricator')) {
    final url = _setting(settings, const ['instanceUrl']).isNotEmpty
        ? _setting(settings, const ['instanceUrl'])
        : config.baseUrl.trim();
    if (_isUsablePhorgeInstanceUrl(url)) {
      return const PersonalProviderReadiness(
        status: ViewStatus.success,
        message: 'Phorge instance URL is saved',
      );
    }
    return const PersonalProviderReadiness(
      status: ViewStatus.failure,
      message: 'Add the Phorge instance URL',
    );
  }

  final clientId = _setting(settings, const ['clientId', 'oauthClientId']);
  final clientSecret = _setting(settings, const [
    'clientSecret',
    'oauthClientSecret',
  ]);
  if (clientId.isNotEmpty && clientSecret.isNotEmpty) {
    return const PersonalProviderReadiness(
      status: ViewStatus.success,
      message: 'OAuth app is saved. Teammates connect from Settings.',
    );
  }
  return const PersonalProviderReadiness(
    status: ViewStatus.failure,
    message: 'Add OAuth client ID and secret',
  );
}

bool _isUsablePhorgeInstanceUrl(String url) {
  final trimmed = url.trim().replaceAll(RegExp(r'/+$'), '');
  if (trimmed.isEmpty) return false;
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) return false;
  if (uri.host == 'phorge.example.com') return false;
  return true;
}
