import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_data.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Maniphest task row surfaced from Conduit `maniphest.search`.
/// CONTRACT: Use [fromConduit] at the protocol boundary after JSON decode only.
/// CONSTRAINTS: Mappable for persistence/extension mapping; participates in [PhorgeTaskBundle].
@MappableClass()
class PhorgeTaskData with PhorgeTaskDataMappable {
  /// The numeric task ID (e.g., 123 for T123).
  final int id;
  
  /// The Phorge PHID (Global UID) for this task.
  final String phid;
  
  /// The summary title of the task.
  final String name;
  
  /// The direct URI to the task in Phorge.
  final String uri;
  
  /// The PHID of the user who currently owns this task.
  final String ownerPHID;
  
  /// The list of project/tag PHIDs associated with this task.
  final List<String> projectPHIDs;
  
  /// When the task was last modified in Phorge.
  final DateTime? dateModified;

  const PhorgeTaskData({
    required this.id,
    required this.phid,
    required this.name,
    required this.uri,
    required this.ownerPHID,
    required this.projectPHIDs,
    this.dateModified,
  });

  factory PhorgeTaskData.fromConduit(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};
    final attachments = json['attachments'] as Map<String, dynamic>? ?? {};
    final projectsAttachment =
        attachments['projects'] as Map<String, dynamic>? ?? {};
    final projectDict =
        projectsAttachment['projectPHIDs'] as List<dynamic>? ?? [];

    return PhorgeTaskData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phid: json['phid']?.toString() ?? '',
      name: fields['name'] as String? ?? 'Unknown',
      uri: fields['uri'] as String? ?? '',
      ownerPHID: fields['ownerPHID'] as String? ?? 'system',
      projectPHIDs: projectDict.map((e) => e.toString()).toList(),
      dateModified: fields['dateModified'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (int.tryParse(fields['dateModified'].toString()) ?? 0) * 1000,
              isUtc: true,
            )
          : null,
    );
  }
}
