/// [ARCH: DOMAIN]
/// ROLE: Catalog of providers that users connect via OAuth authorization code.
library;

/// Providers that support per-user OAuth (not Phorge, Slack, or Discord).
const kOauthProviderIds = {
  'github',
  'gitlab',
  'linear',
  'bitbucket',
  'jira',
  'figma',
};

bool isOauthUserProvider(String providerId) =>
    kOauthProviderIds.contains(providerId.trim().toLowerCase());

/// Static OAuth endpoints, scopes, and token-mapping for one provider.
class OauthProviderSpec {
  const OauthProviderSpec({
    required this.providerId,
    required this.authorizeUrl,
    required this.tokenUrl,
    required this.scopes,
    required this.accessTokenSettingKey,
    this.usePkce = true,
    this.useBasicClientAuth = false,
    this.tokenRequestJson = false,
    this.refreshUrl,
    this.extraAuthorizeParams = const {},
  });

  final String providerId;
  final String authorizeUrl;
  final String tokenUrl;
  final List<String> scopes;
  final String accessTokenSettingKey;
  final bool usePkce;
  final bool useBasicClientAuth;
  final bool tokenRequestJson;

  /// Token refresh endpoint when it differs from [tokenUrl] (Figma).
  final String? refreshUrl;
  final Map<String, String> extraAuthorizeParams;

  /// POST target for [grantType] (`authorization_code` vs `refresh_token`).
  String tokenEndpointForGrant(String grantType) {
    if (grantType == 'refresh_token' &&
        refreshUrl != null &&
        refreshUrl!.trim().isNotEmpty) {
      return refreshUrl!.trim();
    }
    return tokenUrl;
  }
}

/// Resolves OAuth endpoints for [providerId]. [instanceUrl] is used for GitLab.
OauthProviderSpec? oauthSpecFor(String providerId, {String instanceUrl = ''}) {
  switch (providerId.trim().toLowerCase()) {
    case 'github':
      return const OauthProviderSpec(
        providerId: 'github',
        authorizeUrl: 'https://github.com/login/oauth/authorize',
        tokenUrl: 'https://github.com/login/oauth/access_token',
        scopes: ['read:user', 'repo'],
        accessTokenSettingKey: 'api.token',
      );
    case 'gitlab':
      final base = gitlabWebBase(instanceUrl);
      return OauthProviderSpec(
        providerId: 'gitlab',
        authorizeUrl: '$base/oauth/authorize',
        tokenUrl: '$base/oauth/token',
        scopes: ['read_api'],
        accessTokenSettingKey: 'apiToken',
      );
    case 'linear':
      return const OauthProviderSpec(
        providerId: 'linear',
        authorizeUrl: 'https://linear.app/oauth/authorize',
        tokenUrl: 'https://api.linear.app/oauth/token',
        scopes: ['read'],
        accessTokenSettingKey: 'apiKey',
        extraAuthorizeParams: {'actor': 'user'},
      );
    case 'bitbucket':
      return const OauthProviderSpec(
        providerId: 'bitbucket',
        authorizeUrl: 'https://bitbucket.org/site/oauth2/authorize',
        tokenUrl: 'https://bitbucket.org/site/oauth2/access_token',
        scopes: ['account', 'repository'],
        accessTokenSettingKey: 'apiToken',
        useBasicClientAuth: true,
      );
    case 'jira':
      return const OauthProviderSpec(
        providerId: 'jira',
        authorizeUrl: 'https://auth.atlassian.com/authorize',
        tokenUrl: 'https://auth.atlassian.com/oauth/token',
        scopes: ['read:jira-work', 'read:jira-user', 'offline_access'],
        accessTokenSettingKey: 'apiToken',
        tokenRequestJson: true,
        extraAuthorizeParams: {
          'audience': 'api.atlassian.com',
          'prompt': 'consent',
        },
      );
    case 'figma':
      return const OauthProviderSpec(
        providerId: 'figma',
        authorizeUrl: 'https://www.figma.com/oauth',
        tokenUrl: 'https://api.figma.com/v1/oauth/token',
        refreshUrl: 'https://api.figma.com/v1/oauth/refresh',
        scopes: [
          'current_user:read',
          'file_comments:read',
          'file_metadata:read',
        ],
        accessTokenSettingKey: 'api.token',
        useBasicClientAuth: true,
      );
    default:
      return null;
  }
}

/// GitLab web origin (no `/api/v4`) used for `/oauth/authorize` and `/oauth/token`.
String gitlabWebBase(String instanceUrl) {
  var raw = instanceUrl.trim();
  if (raw.isEmpty) return 'https://gitlab.com';
  if (!raw.startsWith('http')) raw = 'https://$raw';
  final uri = Uri.tryParse(raw);
  if (uri == null || uri.host.isEmpty) return 'https://gitlab.com';
  var path = uri.path.replaceAll(RegExp(r'/api/v4/?$'), '');
  if (path == '/') path = '';
  final port = uri.hasPort ? ':${uri.port}' : '';
  return '${uri.scheme}://${uri.host}$port$path'.replaceAll(RegExp(r'/+$'), '');
}
