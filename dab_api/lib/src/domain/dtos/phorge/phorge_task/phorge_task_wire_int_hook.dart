import 'package:dart_mappable/dart_mappable.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Coerce Conduit numeric ids delivered as `int` or numeric `String`.
class PhorgeTaskWireIntHook extends MappingHook {
  const PhorgeTaskWireIntHook();

  @override
  Object? afterDecode(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
