import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_attachment_projects_dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_wire_attachments_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: `attachments` object on Maniphest task rows (optional `projects`).
@MappableClass()
class PhorgeTaskWireAttachmentsDto
    with PhorgeTaskWireAttachmentsDtoMappable {
  final PhorgeTaskWireAttachmentProjectsDto? projects;

  const PhorgeTaskWireAttachmentsDto({this.projects});
}
