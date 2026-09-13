// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_theme_variant.dart';

class AppThemeVariantMapper extends EnumMapper<AppThemeVariant> {
  AppThemeVariantMapper._();

  static AppThemeVariantMapper? _instance;
  static AppThemeVariantMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppThemeVariantMapper._());
    }
    return _instance!;
  }

  static AppThemeVariant fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AppThemeVariant decode(dynamic value) {
    switch (value) {
      case r'light':
        return AppThemeVariant.light;
      case r'dab':
        return AppThemeVariant.dab;
      case r'greyscale':
        return AppThemeVariant.greyscale;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AppThemeVariant self) {
    switch (self) {
      case AppThemeVariant.light:
        return r'light';
      case AppThemeVariant.dab:
        return r'dab';
      case AppThemeVariant.greyscale:
        return r'greyscale';
    }
  }
}

extension AppThemeVariantMapperExtension on AppThemeVariant {
  String toValue() {
    AppThemeVariantMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AppThemeVariant>(this) as String;
  }
}

