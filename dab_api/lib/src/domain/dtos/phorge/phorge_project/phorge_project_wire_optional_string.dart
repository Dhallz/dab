/// [ARCH: DOMAIN_DTO]
/// ROLE: Normalize Conduit `project.search` polymorphic scalar tokens for display/metadata.
/// CONTRACT: Handles plain strings or `{ "key": "…" }` shaped maps from Phorge.
String? phorgeProjectWireOptionalString(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map && value.containsKey('key')) {
    return value['key']?.toString();
  }
  return value.toString();
}
