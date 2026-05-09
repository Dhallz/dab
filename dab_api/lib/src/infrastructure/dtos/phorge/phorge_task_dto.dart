import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_dto.mapper.dart';

@MappableClass()
class PhorgeTaskDto with PhorgeTaskDtoMappable {
  final int id;
  final String phid;
  final String name;
  final String uri;
  final String ownerPHID;
  final List<String> projectPHIDs;

  const PhorgeTaskDto({
    required this.id,
    required this.phid,
    required this.name,
    required this.uri,
    required this.ownerPHID,
    required this.projectPHIDs,
  });

  factory PhorgeTaskDto.fromConduit(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};
    final attachments = json['attachments'] as Map<String, dynamic>? ?? {};
    final projectsAttachment =
        attachments['projects'] as Map<String, dynamic>? ?? {};
    final projectDict =
        projectsAttachment['projectPHIDs'] as List<dynamic>? ?? [];

    return PhorgeTaskDto(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phid: json['phid']?.toString() ?? '',
      name: fields['name'] as String? ?? 'Unknown',
      uri: fields['uri'] as String? ?? '',
      ownerPHID: fields['ownerPHID'] as String? ?? 'system',
      projectPHIDs: projectDict.map((e) => e.toString()).toList(),
    );
  }
}
