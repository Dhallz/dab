import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_wire_fields.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_project_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Parsed `project.search` row from Phorge Conduit.
/// CONTRACT: Decode with [PhorgeProjectDtoMapper.fromMap]; top-level mirrors ApplicationSearch (`id`, `phid`, `fields`, optional `attachments`).
/// CONSTRAINTS: Verbatim polymorphic wires stay on [fields.color] / [fields.icon]; normalized UI helpers on [OnPhorgeProjectDto].
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
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: Convenience accessors for gateways and summaries (scalar strings / non-null display name).
extension OnPhorgeProjectDto on PhorgeProjectDto {
  /// Label for [`PhorgeProjectSummary`] when Conduit omits [`fields.name`].
  String get name {
    final n = fields.name?.trim();
    if (n != null && n.isNotEmpty) return n;
    return 'Unknown';
  }

  String? get color => _phorgeProjectWireOptionalString(fields.color);

  String? get icon => _phorgeProjectWireOptionalString(fields.icon);
}

String? _phorgeProjectWireOptionalString(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map && value.containsKey('key')) {
    return value['key']?.toString();
  }
  return value.toString();
}
