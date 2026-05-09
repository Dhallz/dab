library;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Contract for GraphQL-over-HTTP (POST JSON body, response envelope).
/// CONSTRAINTS: Implementations throw [GraphqlProtocolException] on transport or
/// non-empty `errors`; callers build [Uri] and auth headers from [ProviderConfig].

abstract interface class GraphqlProtocol {
  /// Default timeout used when per-call [timeout] is omitted.
  Duration get defaultTimeout;

  /// POSTs a GraphQL document; returns the **`data`** object from the envelope.
  ///
  /// On HTTP failure, malformed JSON, or a non-empty top-level `errors` array,
  /// throws [GraphqlProtocolException].
  Future<Map<String, dynamic>> execute(
    Uri endpoint, {
    required String bearerToken,
    required String document,
    Map<String, dynamic>? variables,
    Duration? timeout,
  });
}
