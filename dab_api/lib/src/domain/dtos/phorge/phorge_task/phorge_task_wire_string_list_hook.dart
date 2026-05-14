import 'package:dart_mappable/dart_mappable.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Decode `projectPHIDs` lists from loose Conduit JSON (missing or wrong type → empty).
class PhorgeTaskWireStringListHook extends MappingHook {
  const PhorgeTaskWireStringListHook();

  @override
  Object? afterDecode(Object? value) {
    if (value is! List) return <String>[];
    return value.map((e) => e.toString()).toList();
  }
}
