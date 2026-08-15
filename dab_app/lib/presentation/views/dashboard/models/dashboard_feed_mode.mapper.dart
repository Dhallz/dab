// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'dashboard_feed_mode.dart';

class DashboardFeedModeMapper extends EnumMapper<DashboardFeedMode> {
  DashboardFeedModeMapper._();

  static DashboardFeedModeMapper? _instance;
  static DashboardFeedModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DashboardFeedModeMapper._());
    }
    return _instance!;
  }

  static DashboardFeedMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DashboardFeedMode decode(dynamic value) {
    switch (value) {
      case r'timeline':
        return DashboardFeedMode.timeline;
      case r'category':
        return DashboardFeedMode.category;
      case r'provider':
        return DashboardFeedMode.provider;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DashboardFeedMode self) {
    switch (self) {
      case DashboardFeedMode.timeline:
        return r'timeline';
      case DashboardFeedMode.category:
        return r'category';
      case DashboardFeedMode.provider:
        return r'provider';
    }
  }
}

extension DashboardFeedModeMapperExtension on DashboardFeedMode {
  String toValue() {
    DashboardFeedModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DashboardFeedMode>(this) as String;
  }
}

