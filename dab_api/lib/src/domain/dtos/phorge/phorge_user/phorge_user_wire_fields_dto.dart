import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_user_wire_fields_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` object from Conduit `user.search` rows.
/// CONTRACT: Shape matches wire JSON (`fields.username`, `fields.realName`).
@MappableClass()
class PhorgeUserWireFieldsDto with PhorgeUserWireFieldsDtoMappable {
  final String username;
  final String? realName;

  const PhorgeUserWireFieldsDto({
    required this.username,
    this.realName,
  });
}
