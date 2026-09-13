import 'package:dart_mappable/dart_mappable.dart';

part 'provider_metadata.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Categorical metadata for platform items (e.g. Phorge Tags, Jira Components).
/// CONTRACT: Used for visual decoration and filtering of activities.
/// CONSTRAINTS: Must be mapped from the provider's native metadata structure.
@MappableClass()
class ProviderMetadata with ProviderMetadataMappable {
  /// Unique external identifier (e.g. PHID).
  final String id;
  
  /// Display name (e.g. "Platform Feature").
  final String name;
  
  /// The parent provider key (e.g. 'phorge').
  final String provider;
  
  /// The category of metadata (e.g. 'project', 'tag', 'column').
  final String type;
  
  /// CSS/HEX color for UI representation.
  final String? color;
  
  /// Icon name or identifier.
  final String? icon;

  const ProviderMetadata({
    required this.id,
    required this.name,
    required this.provider,
    required this.type,
    this.color,
    this.icon,
  });
}
