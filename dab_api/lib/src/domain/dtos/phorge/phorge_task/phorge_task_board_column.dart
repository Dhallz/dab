/// [ARCH: DOMAIN_DTO]
/// ROLE: Normalize Phorge board column payloads on `transaction.search` (`columns` events).
String? phorgeTaskBoardColumnFromWire(dynamic value) {
  if (value is List && value.isNotEmpty) {
    final first = value.first;
    if (first is Map) {
      return first['columnPHID']?.toString();
    }
  }
  return value?.toString();
}
