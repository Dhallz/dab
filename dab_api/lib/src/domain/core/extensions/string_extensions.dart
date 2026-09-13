import 'package:uuid/uuid.dart';

final _uuid = const Uuid();

extension OnObjectNullable on Object? {
  /// Conduit polymorphic wires (e.g. project `fields.color` / `fields.icon`): plain string,
  /// `{ "key": "…" }`, or fallback `toString()`.
  String? get phorgeWireOptionalString {
    final value = this;
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map && value.containsKey('key')) {
      return value['key']?.toString();
    }
    return value.toString();
  }
}

/// [ARCH: DOMAIN]
/// ROLE: Deterministic IDs from opaque source strings (`Namespace.url` RFC 9562 UUID v5).
extension OnString on String {
  String get v5Uuid => _uuid.v5(Namespace.url.value, this);
}
