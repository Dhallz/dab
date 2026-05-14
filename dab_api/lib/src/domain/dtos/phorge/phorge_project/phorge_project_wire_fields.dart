import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_wire_default_string_hook.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_project_wire_fields.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` map from Conduit `project.search` (`name`, polymorphic `color` / `icon`).
@MappableClass()
class PhorgeProjectWireFields with PhorgeProjectWireFieldsMappable {
  @MappableField(hook: PhorgeProjectWireDefaultStringHook('Unknown'))
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
