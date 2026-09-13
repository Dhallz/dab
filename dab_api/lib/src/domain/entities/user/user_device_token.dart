/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One FCM/APNs registration token for a DAB user.
/// CONTRACT: [platform] is `android` or `ios`. [token] is opaque.
class UserDeviceToken {
  final String id;
  final String userId;
  final String platform;
  final String token;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserDeviceToken({
    required this.id,
    required this.userId,
    required this.platform,
    required this.token,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toApiMap() => {
    'platform': platform,
    'token': token,
  };
}

/// [ARCH: DOMAIN]
/// ROLE: Allowed mobile platform ids for device tokens.
extension OnString on String {
  /// True when [this] is an allowed mobile platform id (`android` or `ios`).
  bool get isDeviceTokenPlatform {
    final value = trim().toLowerCase();
    return value == 'android' || value == 'ios';
  }
}
