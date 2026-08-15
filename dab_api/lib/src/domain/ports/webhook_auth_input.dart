/// [ARCH: DOMAIN_DTO]
/// ROLE: Raw request material needed to authenticate a provider webhook.
/// CONTRACT: Presentation supplies headers it already parsed; the
/// authenticator resolves the configured secret and runs HMAC / compare.
class WebhookAuthInput {
  /// Provider id (`slack`, `github`, `gitlab`, …).
  final String providerId;

  /// Exact raw request body (HMAC is over this string). Unused for GitLab.
  final String body;

  /// Provider signature header (HMAC or Slack `X-Slack-Signature`).
  final String signatureHeader;

  /// Slack `X-Slack-Request-Timestamp` (ignored by other providers).
  final String timestampHeader;

  /// GitLab `X-Gitlab-Token` or Jira `X-Webhook-Secret` fallback.
  final String sharedSecretHeader;

  /// Jira Bruno simulation `?secret=` fallback.
  final String sharedSecretQuery;

  /// Builds the authenticator input for one inbound request.
  const WebhookAuthInput({
    required this.providerId,
    this.body = '',
    this.signatureHeader = '',
    this.timestampHeader = '',
    this.sharedSecretHeader = '',
    this.sharedSecretQuery = '',
  });
}
