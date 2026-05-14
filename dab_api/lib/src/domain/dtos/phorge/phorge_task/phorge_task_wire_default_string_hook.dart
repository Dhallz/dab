import 'package:dart_mappable/dart_mappable.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Decode optional Conduit string fields to [fallback] when absent or empty.
class PhorgeTaskWireDefaultStringHook extends MappingHook {
  const PhorgeTaskWireDefaultStringHook(this.fallback);

  final String fallback;

  @override
  Object? afterDecode(Object? value) {
    if (value == null) return fallback;
    final string = value.toString();
    return string.isEmpty ? fallback : string;
  }
}
