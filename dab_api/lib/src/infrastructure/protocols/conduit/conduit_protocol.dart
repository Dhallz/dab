library;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Contract for Conduit (Phabricator/Phorge) RPC-over-form HTTP calls.
/// CONSTRAINTS: Read-only wire adapter; implementations own TLS/client lifecycle.
///
/// Conduit protocol adapter — [`call`] performs `POST .../api/<method>` with form encoding.
abstract interface class ConduitProtocol {
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    String? apiToken,
  });

  void dispose();
}
