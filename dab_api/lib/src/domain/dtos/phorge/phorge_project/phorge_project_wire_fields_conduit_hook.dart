import 'package:dart_mappable/dart_mappable.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Normalize sparse `fields` maps from Conduit before field decode (defaults match prior DTO behaviour).
class PhorgeProjectWireFieldsConduitHook extends MappingHook {
  const PhorgeProjectWireFieldsConduitHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is! Map<String, dynamic>) return value;
    final m = Map<String, dynamic>.from(value);

    final name = m['name'];
    if (name == null || name.toString().isEmpty) {
      m['name'] = 'Unknown';
    }

    final depthRaw = m['depth'];
    if (depthRaw == null) {
      m['depth'] = 0;
    } else if (depthRaw is! int) {
      m['depth'] = int.tryParse(depthRaw.toString()) ?? 0;
    }

    return m;
  }
}
