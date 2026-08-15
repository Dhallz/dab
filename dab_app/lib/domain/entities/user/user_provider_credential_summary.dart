/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Masked per-user provider credential status from `GET /users/me/credentials`.
/// CONTRACT: Never includes secret values.
class UserProviderCredentialSummary {
  final String providerId;
  final String status;
  final bool hasSecret;
  final bool isSharedBot;
  final String? externalId;
  final String? externalUsername;
  final DateTime? updatedAt;

  const UserProviderCredentialSummary({
    required this.providerId,
    required this.status,
    required this.hasSecret,
    this.isSharedBot = false,
    this.externalId,
    this.externalUsername,
    this.updatedAt,
  });

  bool get isConnected => status == 'connected' && hasSecret;

  factory UserProviderCredentialSummary.fromMap(Map<String, dynamic> map) {
    final updatedRaw = map['updatedAt']?.toString();
    return UserProviderCredentialSummary(
      providerId: (map['providerId'] ?? '').toString(),
      status: (map['status'] ?? 'connected').toString(),
      hasSecret: map['hasSecret'] == true,
      isSharedBot: map['isSharedBot'] == true,
      externalId: map['externalId']?.toString(),
      externalUsername: map['externalUsername']?.toString(),
      updatedAt: updatedRaw == null || updatedRaw.isEmpty
          ? null
          : DateTime.tryParse(updatedRaw),
    );
  }
}
