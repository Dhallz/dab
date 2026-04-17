// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'dashboard_banner_severity.dart';

class DashboardBannerSeverityMapper
    extends EnumMapper<DashboardBannerSeverity> {
  DashboardBannerSeverityMapper._();

  static DashboardBannerSeverityMapper? _instance;
  static DashboardBannerSeverityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardBannerSeverityMapper._(),
      );
    }
    return _instance!;
  }

  static DashboardBannerSeverity fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DashboardBannerSeverity decode(dynamic value) {
    switch (value) {
      case r'info':
        return DashboardBannerSeverity.info;
      case r'warning':
        return DashboardBannerSeverity.warning;
      case r'critical':
        return DashboardBannerSeverity.critical;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DashboardBannerSeverity self) {
    switch (self) {
      case DashboardBannerSeverity.info:
        return r'info';
      case DashboardBannerSeverity.warning:
        return r'warning';
      case DashboardBannerSeverity.critical:
        return r'critical';
    }
  }
}

extension DashboardBannerSeverityMapperExtension on DashboardBannerSeverity {
  String toValue() {
    DashboardBannerSeverityMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DashboardBannerSeverity>(this)
        as String;
  }
}

