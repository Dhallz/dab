import 'package:dab_api/src/domain/dtos/phorge/phorge_user/phorge_user_wire_fields_dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_user_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Parsed `user.search` row from Phorge Conduit.
/// CONTRACT: Decode with [PhorgeUserDtoMapper.fromMap] after JSON decode only.
/// CONSTRAINTS: Consumed directly by gateways and provisioning ([SyncPhorgeUsers]); no secondary entity projection.
@MappableClass()
class PhorgeUserDto with PhorgeUserDtoMappable {
  final String phid;
  final PhorgeUserWireFieldsDto fields;

  const PhorgeUserDto({required this.phid, required this.fields});

  /// Conduit exposes `fields.username`; this alias preserves existing callers.
  String get userName => fields.username;

  String? get realName => fields.realName;
}
