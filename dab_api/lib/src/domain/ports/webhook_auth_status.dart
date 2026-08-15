/// Outcome of inbound webhook / Events API signature verification.
enum WebhookAuthStatus {
  /// Signature or shared secret matched the configured value.
  ok,

  /// Provider is inactive or has no Live signing secret configured.
  missingSecret,

  /// Header/body did not match the configured secret.
  invalid,
}
