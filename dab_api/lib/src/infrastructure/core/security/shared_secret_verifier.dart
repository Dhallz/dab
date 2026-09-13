/// [ARCH: INFRASTRUCTURE_SECURITY]
/// ROLE: Validates inbound webhooks that authenticate with a plain shared
/// secret instead of an HMAC signature (Jira admin webhooks, GitLab
/// `X-Gitlab-Token`, …).
/// CONSTRAINTS: Constant-time comparison; empty values never match.
class SharedSecretVerifier {
  /// Returns true when [provided] equals [expected] (both non-empty).
  bool isValid({required String provided, required String expected}) {
    final a = provided.trim();
    final b = expected.trim();
    if (a.isEmpty || b.isEmpty) {
      return false;
    }
    return _constantTimeEquals(a, b);
  }

  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) {
      return false;
    }
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
