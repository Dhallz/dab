import 'package:dab_api/src/domain/dtos/phorge/phorge_user/phorge_user_wire_fields.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_user_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Parsed `user.search` row from Phorge Conduit.
/// CONTRACT: Decode with [PhorgeUserDtoMapper.fromMap] after JSON decode only.
/// CONSTRAINTS: Mapped to [PhorgeDirectoryUser] when provisioning/syncing identities.
@MappableClass()
class PhorgeUserDto with PhorgeUserDtoMappable {
  final String phid;
  final PhorgeUserWireFields fields;

  const PhorgeUserDto({required this.phid, required this.fields});

  /// Conduit exposes `fields.username`; this alias preserves existing callers.
  String get userName => fields.username;

  String? get realName => fields.realName;
}
