import '../../../domain/contracts/ports/abs_i_push_wake_gateway.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Dev / missing-FCM wake sink. Stores tokens without sending.
class NoopPushWakeGateway implements AbsIPushWakeGateway {
  const NoopPushWakeGateway();

  @override
  Future<void> sendWake({
    required List<String> tokens,
    required Map<String, String> data,
  }) async {}
}
