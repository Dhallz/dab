import 'package:dart_mappable/dart_mappable.dart';

part 'provider_config.mapper.dart';

@MappableClass()
class ProviderConfig with ProviderConfigMappable {
  final String id;
  final String baseUrl;
  final String? iconUrl;

  const ProviderConfig({required this.id, required this.baseUrl, this.iconUrl});
}
