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

/// True when [raw] is an allowed mobile platform id.
bool isDeviceTokenPlatform(String raw) {
  final value = raw.trim().toLowerCase();
  return value == 'android' || value == 'ios';
}
