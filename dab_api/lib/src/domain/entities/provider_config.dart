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
  
  /// The root URL of the external platform.
  final String baseUrl;
  
  /// Optional branding icon for the UI.
  final String? iconUrl;

  const ProviderConfig({required this.id, required this.baseUrl, this.iconUrl});
}
