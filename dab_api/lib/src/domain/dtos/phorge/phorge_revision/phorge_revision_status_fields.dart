import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_revision_status_fields.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields.status` object (`name`; extra Conduit keys ignored on decode).
@MappableClass()
class PhorgeRevisionStatusFields with PhorgeRevisionStatusFieldsMappable {
  final String name;

  const PhorgeRevisionStatusFields({required this.name});
}
