import 'package:dart_mappable/dart_mappable.dart';
import '../../../../domain/entities/system/app_settings.dart';

part 'app_state.mapper.dart';

@MappableClass()
class AppState with AppStateMappable {
  final AppSettings settings;
  final bool isLoading;

  const AppState({this.settings = const AppSettings(), this.isLoading = false});
}
