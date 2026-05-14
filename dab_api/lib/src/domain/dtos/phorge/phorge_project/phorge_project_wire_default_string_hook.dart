import 'package:dart_mappable/dart_mappable.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Decode hook for optional Conduit string fields that omit keys or send empty values.
class PhorgeProjectWireDefaultStringHook extends MappingHook {
  const PhorgeProjectWireDefaultStringHook(this.fallback);

  final String fallback;

  @override
  Object? afterDecode(Object? value) {
    if (value == null) return fallback;
    final string = value.toString();
    return string.isEmpty ? fallback : string;
  }
}
