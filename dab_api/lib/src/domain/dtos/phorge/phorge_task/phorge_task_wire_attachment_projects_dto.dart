import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_wire_attachment_projects_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: `attachments.projects` sub-object on `maniphest.search` rows.
@MappableClass()
class PhorgeTaskWireAttachmentProjectsDto
    with PhorgeTaskWireAttachmentProjectsDtoMappable {
  final List<String>? projectPHIDs;

  const PhorgeTaskWireAttachmentProjectsDto({this.projectPHIDs});
}
