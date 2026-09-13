import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_revision_status_fields_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields.status` object (`name`; extra Conduit keys ignored on decode).
@MappableClass()
class PhorgeRevisionStatusFieldsDto
    with PhorgeRevisionStatusFieldsDtoMappable {
  final String name;

  const PhorgeRevisionStatusFieldsDto({required this.name});
}
