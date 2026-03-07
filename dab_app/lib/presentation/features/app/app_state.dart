import 'package:dart_mappable/dart_mappable.dart';
import '../../../../domain/entities/system/app_settings.dart';
import '../../../../domain/entities/provider_config.dart';

part 'app_state.mapper.dart';

@MappableClass()
class AppState with AppStateMappable {
  final AppSettings settings;
  final bool isLoading;
  final List<ProviderConfig> configs;

  const AppState({
    this.settings = const AppSettings(),
    this.isLoading = false,
    this.configs = const [],
  });
}
