// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'daily_report_line_role.dart';

class DailyReportLineRoleMapper extends EnumMapper<DailyReportLineRole> {
  DailyReportLineRoleMapper._();

  static DailyReportLineRoleMapper? _instance;
  static DailyReportLineRoleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DailyReportLineRoleMapper._());
    }
    return _instance!;
  }

  static DailyReportLineRole fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DailyReportLineRole decode(dynamic value) {
    switch (value) {
      case r'directed':
        return DailyReportLineRole.directed;
      case r'authored':
        return DailyReportLineRole.authored;
      case r'both':
        return DailyReportLineRole.both;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DailyReportLineRole self) {
    switch (self) {
      case DailyReportLineRole.directed:
        return r'directed';
      case DailyReportLineRole.authored:
        return r'authored';
      case DailyReportLineRole.both:
        return r'both';
    }
  }
}

extension DailyReportLineRoleMapperExtension on DailyReportLineRole {
  String toValue() {
    DailyReportLineRoleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DailyReportLineRole>(this) as String;
  }
}

