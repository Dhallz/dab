// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'explorer_date_mode.dart';

class ExplorerDateModeMapper extends EnumMapper<ExplorerDateMode> {
  ExplorerDateModeMapper._();

  static ExplorerDateModeMapper? _instance;
  static ExplorerDateModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerDateModeMapper._());
    }
    return _instance!;
  }

  static ExplorerDateMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ExplorerDateMode decode(dynamic value) {
    switch (value) {
      case r'singleDay':
        return ExplorerDateMode.singleDay;
      case r'range':
        return ExplorerDateMode.range;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ExplorerDateMode self) {
    switch (self) {
      case ExplorerDateMode.singleDay:
        return r'singleDay';
      case ExplorerDateMode.range:
        return r'range';
    }
  }
}

extension ExplorerDateModeMapperExtension on ExplorerDateMode {
  String toValue() {
    ExplorerDateModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ExplorerDateMode>(this) as String;
  }
}

