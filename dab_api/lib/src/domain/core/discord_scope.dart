/// [ARCH: DOMAIN]
/// ROLE: Parses Discord channel allow-lists from provider settings.
/// CONTRACT: Pure parse. Bot token extraction uses [extractProviderToken].
library;

/// Extracts the configured channel allow-list (list or comma/newline string).
List<String> discordChannelIds(Map<String, dynamic> settings) {
  final raw = settings['channels'];
  if (raw is List) {
    return raw
        .map((e) => e.toString().trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  final str = (raw ?? '').toString();
  if (str.trim().isEmpty) return const [];
  return str
      .split(RegExp(r'[\n,]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}
