/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Provides static provider ingestion/live capability metadata.
/// CONTRACT: Returns normalized capability maps keyed by provider id.
/// CONSTRAINTS: Read-only catalog used for API metadata exposure.
class ProviderCapabilityCatalog {
  static const Map<String, Map<String, dynamic>> _capabilities = {
    'phorge': {
      'ingestionMode': 'hybrid',
      'supportsWebhook': true,
      'supportsWebSocket': false,
      'supportsPolling': true,
    },
    'github': {
      'ingestionMode': 'hybrid',
      'supportsWebhook': true,
      'supportsWebSocket': false,
      'supportsPolling': true,
    },
    'gitlab': {
      'ingestionMode': 'hybrid',
      'supportsWebhook': true,
      'supportsWebSocket': false,
      'supportsPolling': true,
    },
    'bitbucket': {
      'ingestionMode': 'hybrid',
      'supportsWebhook': true,
      'supportsWebSocket': false,
      'supportsPolling': true,
    },
    'jira': {
      'ingestionMode': 'hybrid',
      'supportsWebhook': true,
      'supportsWebSocket': false,
      'supportsPolling': true,
    },
    'linear': {
      'ingestionMode': 'hybrid',
      'supportsWebhook': true,
      'supportsWebSocket': false,
      'supportsPolling': true,
    },
    'slack': {
      'ingestionMode': 'hybrid',
      'supportsWebhook': true,
      'supportsWebSocket': false,
      'supportsPolling': true,
    },
    'discord': {
      'ingestionMode': 'hybrid',
      'supportsWebhook': false,
      'supportsWebSocket': true,
      'supportsPolling': true,
    },
  };

  List<Map<String, dynamic>> all({
    Set<String>? filterProviderIds,
    Set<String>? activeProviderIds,
  }) {
    final ids = (filterProviderIds == null || filterProviderIds.isEmpty)
        ? _capabilities.keys
        : _capabilities.keys.where(filterProviderIds.contains);

    return ids
        .map((providerId) {
          final capability = _capabilities[providerId]!;
          return {
            'providerId': providerId,
            'ingestionMode': capability['ingestionMode'],
            'supportsWebhook': capability['supportsWebhook'],
            'supportsWebSocket': capability['supportsWebSocket'],
            'supportsPolling': capability['supportsPolling'],
            'isActive': activeProviderIds?.contains(providerId) ?? false,
          };
        })
        .toList(growable: false);
  }
}
