import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_user_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Parsed `user.search` row from Phorge Conduit.
/// CONTRACT: [fromConduit] maps wire JSON without transport dependencies.
/// CONSTRAINTS: Mapped to [PhorgeDirectoryUser] when provisioning/syncing identities.
@MappableClass()
class PhorgeUserDto with PhorgeUserDtoMappable {
  final String phid;
  final String userName;
  final String? realName;

  const PhorgeUserDto({
    required this.phid,
    required this.userName,
    this.realName,
  });

  factory PhorgeUserDto.fromConduit(Map<String, dynamic> json) {
    return PhorgeUserDto(
      phid: json['phid'] as String,
      userName:
          json['fields']?['username'] as String? ?? json['userName'] as String,
      realName: json['fields']?['realName'] as String?,
    );
  }
}
