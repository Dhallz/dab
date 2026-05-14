import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_wire_fields.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_wire_optional_string.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_project_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Parsed `project.search` row from Phorge Conduit.
/// CONTRACT: Decode with [PhorgeProjectDtoMapper.fromMap]; top-level mirrors ApplicationSearch (`id`, `phid`, `fields`, optional `attachments`).
/// CONSTRAINTS: Normalized [`color`] / [`icon`] strings preserve existing Gateway mapping; verbatim maps stay on [`fields`] / [`attachments`].
@MappableClass()
class PhorgeProjectDto with PhorgeProjectDtoMappable {
  final int id;

  final String phid;

  final PhorgeProjectWireFields fields;

  /// Present when the caller passes `attachments: { …: true }` on `project.search`.
  final Map<String, dynamic>? attachments;

  const PhorgeProjectDto({
    required this.id,
    required this.phid,
    required this.fields,
    this.attachments,
  });

  String get name => fields.name;

  String? get color => phorgeProjectWireOptionalString(fields.color);

  String? get icon => phorgeProjectWireOptionalString(fields.icon);
}
