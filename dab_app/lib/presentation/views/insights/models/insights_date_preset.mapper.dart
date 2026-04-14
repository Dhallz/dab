// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insights_date_preset.dart';

class InsightsDatePresetMapper extends EnumMapper<InsightsDatePreset> {
  InsightsDatePresetMapper._();

  static InsightsDatePresetMapper? _instance;
  static InsightsDatePresetMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InsightsDatePresetMapper._());
    }
    return _instance!;
  }

  static InsightsDatePreset fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  InsightsDatePreset decode(dynamic value) {
    switch (value) {
      case r'today':
        return InsightsDatePreset.today;
      case r'last7Days':
        return InsightsDatePreset.last7Days;
      case r'last30Days':
        return InsightsDatePreset.last30Days;
      case r'custom':
        return InsightsDatePreset.custom;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(InsightsDatePreset self) {
    switch (self) {
      case InsightsDatePreset.today:
        return r'today';
      case InsightsDatePreset.last7Days:
        return r'last7Days';
      case InsightsDatePreset.last30Days:
        return r'last30Days';
      case InsightsDatePreset.custom:
        return r'custom';
    }
  }
}

extension InsightsDatePresetMapperExtension on InsightsDatePreset {
  String toValue() {
    InsightsDatePresetMapper.ensureInitialized();
    return MapperContainer.globals.toValue<InsightsDatePreset>(this) as String;
  }
}

