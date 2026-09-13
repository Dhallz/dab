import '../../../domain/contracts/ports/abs_i_push_wake_client.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Dev / missing-FCM wake sink. Stores tokens without sending.
class NoopPushWakeClient implements AbsIPushWakeClient {
  const NoopPushWakeClient();

  @override
  Future<void> sendWake({
    required List<String> tokens,
    required Map<String, String> data,
  }) async {}
}
