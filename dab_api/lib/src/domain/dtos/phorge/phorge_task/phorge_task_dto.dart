import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_attachments_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_fields_dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: One `maniphest.search` datum — matches Conduit top-level (`id`, `phid`, `fields`, optional `attachments`).
/// CONTRACT: Decode with [PhorgeTaskDtoMapper.fromMap]; nulls preserve absent wire keys. Convenience getters on [OnPhorgeTaskDto].
/// CONSTRAINTS: Mappable-generated decode only; participates in [PhorgeTaskBundleDto].
@MappableClass()
class PhorgeTaskDto with PhorgeTaskDtoMappable {
  final int? id;

  final String? phid;

  final PhorgeTaskWireFieldsDto fields;

  final PhorgeTaskWireAttachmentsDto? attachments;

  const PhorgeTaskDto({
    this.id,
    this.phid,
    required this.fields,
    this.attachments,
  });
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: Resolved scalars / lists for infra and [`Activity`] mapping (summaries ignore null wire gaps).
extension OnPhorgeTaskDto on PhorgeTaskDto {
  int get conduitTaskId => id ?? 0;

  /// Non-null PHID token for [`PhorgeTaskProvider`] when upstream omits `phid`.
  String get conduitPhid => phid ?? '';

  String get name {
    final n = fields.title?.trim();
    if (n != null && n.isNotEmpty) return n;
    return 'Unknown';
  }

  String get uri => fields.uri ?? '';

  String get ownerPHID => fields.ownerPHID ?? 'system';

  List<String> get projectPHIDs {
    final p = attachments?.projects?.projectPHIDs;
    return p ?? const [];
  }

  DateTime? get dateModified => fields.dateModified != null
      ? DateTime.fromMillisecondsSinceEpoch(
          fields.dateModified! * 1000,
          isUtc: true,
        )
      : null;
}
