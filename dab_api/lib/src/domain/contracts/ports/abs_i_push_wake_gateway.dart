/// [ARCH: DOMAIN_PORT]
/// ROLE: Sends a data-only inbox wake to device tokens (FCM HTTP v1 in prod).
/// CONTRACT: [data] must be [inboxWakeData] — never activity title or body.
abstract interface class AbsIPushWakeGateway {
  /// Delivers [data] to each token. Empty [tokens] is a no-op.
  Future<void> sendWake({
    required List<String> tokens,
    required Map<String, String> data,
  });
}
