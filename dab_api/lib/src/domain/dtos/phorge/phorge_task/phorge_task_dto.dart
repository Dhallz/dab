import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_attachments.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_default_string_hook.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_fields.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_int_hook.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_data.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: One `maniphest.search` datum — matches Conduit top-level (`id`, `phid`, `fields`, `attachments`).
/// CONTRACT: Decode with [PhorgeTaskDataMapper.fromMap] after JSON decode only.
/// CONSTRAINTS: Mappable for persistence/extension mapping; participates in [PhorgeTaskBundle].
@MappableClass()
class PhorgeTaskData with PhorgeTaskDataMappable {
  /// The numeric task ID (e.g., 123 for T123).
  @MappableField(hook: PhorgeTaskWireIntHook())
  final int id;

  /// The Phorge PHID (global UID) for this task.
  @MappableField(hook: PhorgeTaskWireDefaultStringHook(''))
  final String phid;

  final PhorgeTaskWireFields fields;

  final PhorgeTaskWireAttachments? attachments;

  const PhorgeTaskData({
    required this.id,
    required this.phid,
    required this.fields,
    this.attachments,
  });

  /// The summary title of the task.
  String get name => fields.name;

  /// The direct URI to the task in Phorge.
  String get uri => fields.uri;

  /// The PHID of the user who currently owns this task.
  String get ownerPHID => fields.ownerPHID;

  /// Project/tag PHIDs from `attachments.projects.projectPHIDs` when requested.
  List<String> get projectPHIDs =>
      attachments?.projects?.projectPHIDs ?? const [];

  /// Last modified instant when wire supplied `fields.dateModified` epoch seconds.
  DateTime? get dateModified => fields.dateModified != null
      ? DateTime.fromMillisecondsSinceEpoch(
          fields.dateModified! * 1000,
          isUtc: true,
        )
      : null;
}
