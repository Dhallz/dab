import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_project_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Parsed `project.search` row from Phorge Conduit.
/// CONTRACT: [fromConduit] maps wire JSON only; no transport types.
@MappableClass()
class PhorgeProjectDto with PhorgeProjectDtoMappable {
  final int id;
  final String phid;
  final String name;
  final String? color;
  final String? icon;

  const PhorgeProjectDto({
    required this.id,
    required this.phid,
    required this.name,
    this.color,
    this.icon,
  });

  factory PhorgeProjectDto.fromConduit(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};

    String? extractString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map && value.containsKey('key')) {
        return value['key']?.toString();
      }
      return value.toString();
    }

    return PhorgeProjectDto(
      id: json['id'] as int,
      phid: json['phid'] as String,
      name: fields['name'] as String? ?? 'Unknown',
      color: extractString(fields['color']),
      icon: extractString(fields['icon']),
    );
  }
}
