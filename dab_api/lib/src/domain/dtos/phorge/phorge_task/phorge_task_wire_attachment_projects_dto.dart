import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_string_list_hook.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_wire_attachment_projects.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: `attachments.projects` sub-object on `maniphest.search` rows.
@MappableClass()
class PhorgeTaskWireAttachmentProjects
    with PhorgeTaskWireAttachmentProjectsMappable {
  @MappableField(hook: PhorgeTaskWireStringListHook())
  final List<String> projectPHIDs;

  const PhorgeTaskWireAttachmentProjects({required this.projectPHIDs});
}
