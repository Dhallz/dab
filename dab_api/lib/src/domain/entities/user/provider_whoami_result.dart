/// [ARCH: DOMAIN]
/// ROLE: Result of a provider whoami / connect probe.
class ProviderWhoamiResult {
  final String externalId;
  final String? externalUsername;
  final List<String> discoveredWatchList;

  const ProviderWhoamiResult({
    required this.externalId,
    this.externalUsername,
    this.discoveredWatchList = const [],
  });
}
