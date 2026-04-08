import 'package:dart_mappable/dart_mappable.dart';

part 'provider_config.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Static configuration for a Platform Provider (e.g., Phorge, GitHub).
/// CONTRACT: Provides endpoint URLs and branding assets.
/// CONSTRAINTS: Read-only at runtime for most services.
@MappableClass()
class ProviderConfig with ProviderConfigMappable {
  /// The unique string identifier for the provider (e.g. 'phorge').
  final String id;

  /// Display name for the provider.
  final String name;

  /// The root URL of the external platform.
  final String baseUrl;

  /// Whether this provider is enabled for data fetching and UI.
  final bool isActive;

  /// Optional branding icon for the UI.
  final String? iconUrl;

  /// Provider-specific configuration (e.g. client ID, secret).
  final Map<String, dynamic> settings;

  const ProviderConfig({
    required this.id,
    required this.name,
    required this.baseUrl,
    this.isActive = true,
    this.iconUrl,
    this.settings = const {},
  });
}
