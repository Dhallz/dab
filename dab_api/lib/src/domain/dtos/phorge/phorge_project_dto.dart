import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_project_dto.mapper.dart';

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

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` map from Conduit `project.search` (`name`, polymorphic `color` / `icon`).
@MappableClass()
class PhorgeProjectWireFields with PhorgeProjectWireFieldsMappable {
  @MappableField(hook: _WireDefaultStringHook('Unknown'))
  final String name;

  /// Conduit may return a string literal or `{ "key": "…" }` token map.
  final Object? color;
  final Object? icon;

  const PhorgeProjectWireFields({
    required this.name,
    this.color,
    this.icon,
  });
}

String? _phorgeWireOptionalString(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map && value.containsKey('key')) {
    return value['key']?.toString();
  }
  return value.toString();
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: Parsed `project.search` row from Phorge Conduit.
/// CONTRACT: Decode with [PhorgeProjectDtoMapper.fromMap]; shape matches wire JSON.
/// CONSTRAINTS: Normalized strings for UI via [color] / [icon] getters.
@MappableClass()
class PhorgeProjectDto with PhorgeProjectDtoMappable {
  final int id;
  final String phid;
  final PhorgeProjectWireFields fields;

  const PhorgeProjectDto({
    required this.id,
    required this.phid,
    required this.fields,
  });

  String get name => fields.name;

  String? get color => _phorgeWireOptionalString(fields.color);

  String? get icon => _phorgeWireOptionalString(fields.icon);
}
