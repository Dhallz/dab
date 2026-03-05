import 'package:dart_mappable/dart_mappable.dart';

part 'provider_metadata.mapper.dart';

@MappableClass()
class ProviderMetadata with ProviderMetadataMappable {
  final String id;
  final String name;
  final String provider;
  final String type;
  final String? color;
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
