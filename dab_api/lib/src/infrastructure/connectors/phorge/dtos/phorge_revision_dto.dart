import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_revision_dto.mapper.dart';

@MappableClass()
class PhorgeRevisionDto with PhorgeRevisionDtoMappable {
  final int id;
  final String phid;
  final String title;
  final String uri;
  final String statusName;
  final DateTime dateModified;

  const PhorgeRevisionDto({
    required this.id,
    required this.phid,
    required this.title,
    required this.uri,
    required this.statusName,
    required this.dateModified,
  });

  factory PhorgeRevisionDto.fromConduit(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};
    final status = fields['status'] as Map<String, dynamic>? ?? {};
    return PhorgeRevisionDto(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phid: json['phid']?.toString() ?? '',
      title: fields['title'] as String? ?? 'Unknown',
      uri: fields['uri'] as String? ?? '',
      statusName: status['name'] as String? ?? 'Unknown',
      dateModified: DateTime.fromMillisecondsSinceEpoch(
        (int.tryParse(fields['dateModified']?.toString() ?? '0') ?? 0) * 1000,
      ),
    );
  }
}
