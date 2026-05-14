import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_data.mapper.dart';

/// Coerces Conduit ids that may arrive as int or numeric string.
class _PhorgeWireIntHook extends MappingHook {
  const _PhorgeWireIntHook();

  @override
  Object? afterDecode(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class _WireDefaultStringHook extends MappingHook {
  const _WireDefaultStringHook(this.fallback);

  final String fallback;

  @override
  Object? afterDecode(Object? value) {
    if (value == null) return fallback;
    final string = value.toString();
    return string.isEmpty ? fallback : string;
  }
}

class _WireStringListHook extends MappingHook {
  const _WireStringListHook();

  @override
  Object? afterDecode(Object? value) {
    if (value is! List) return <String>[];
    return value.map((e) => e.toString()).toList();
  }
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: `attachments.projects` sub-object on `maniphest.search` rows.
@MappableClass()
class PhorgeTaskWireAttachmentProjects
    with PhorgeTaskWireAttachmentProjectsMappable {
  @MappableField(hook: _WireStringListHook())
  final List<String> projectPHIDs;

  const PhorgeTaskWireAttachmentProjects({required this.projectPHIDs});
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: `attachments` object on Maniphest task rows (optional `projects`).
@MappableClass()
class PhorgeTaskWireAttachments with PhorgeTaskWireAttachmentsMappable {
  final PhorgeTaskWireAttachmentProjects? projects;

  const PhorgeTaskWireAttachments({this.projects});
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` map from Conduit `maniphest.search` rows.
/// CONTRACT: [dateModified] is epoch seconds when present (`fields.dateModified` on wire).
@MappableClass()
class PhorgeTaskWireFields with PhorgeTaskWireFieldsMappable {
  @MappableField(hook: _WireDefaultStringHook('Unknown'))
  final String name;

  @MappableField(hook: _WireDefaultStringHook(''))
  final String uri;

  @MappableField(hook: _WireDefaultStringHook('system'))
  final String ownerPHID;

  /// Epoch seconds; absent keys decode as null (no synthetic DateTime until [PhorgeTaskData.dateModified] getter).
  final int? dateModified;

  const PhorgeTaskWireFields({
    required this.name,
    required this.uri,
    required this.ownerPHID,
    this.dateModified,
  });
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: One `maniphest.search` datum — matches Conduit top-level (`id`, `phid`, `fields`, `attachments`).
/// CONTRACT: Decode with [PhorgeTaskDataMapper.fromMap] after JSON decode only.
/// CONSTRAINTS: Mappable for persistence/extension mapping; participates in [PhorgeTaskBundle].
@MappableClass()
class PhorgeTaskData with PhorgeTaskDataMappable {
  /// The numeric task ID (e.g., 123 for T123).
  @MappableField(hook: _PhorgeWireIntHook())
  final int id;

  /// The Phorge PHID (global UID) for this task.
  @MappableField(hook: _WireDefaultStringHook(''))
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
