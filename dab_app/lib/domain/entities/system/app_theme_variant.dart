import 'package:dart_mappable/dart_mappable.dart';

part 'app_theme_variant.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Persisted visual theme choice for the Flutter client.
/// CONTRACT: [light] is the white-first scheme; [dab] is the branded dark palette;
/// [greyscale] is a neutral dark scheme (user-facing “Dark”).
@MappableEnum()
enum AppThemeVariant {
  light,
  dab,
  greyscale,
}
