import 'package:dart_mappable/dart_mappable.dart';

part 'provider_config.mapper.dart';

@MappableClass()
class ProviderConfig with ProviderConfigMappable {
  final String id;
  final String name;
  final String baseUrl;
  final String? iconUrl;
  final bool isActive;
  final Map<String, dynamic> settings;

  const ProviderConfig({
    required this.id,
    required this.name,
    required this.baseUrl,
    this.iconUrl,
    required this.isActive,
    this.settings = const {},
  });
}
