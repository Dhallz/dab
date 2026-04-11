// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'dab_view_tab.dart';

class DabViewTabMapper extends EnumMapper<DabViewTab> {
  DabViewTabMapper._();

  static DabViewTabMapper? _instance;
  static DabViewTabMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DabViewTabMapper._());
    }
    return _instance!;
  }

  static DabViewTab fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DabViewTab decode(dynamic value) {
    switch (value) {
      case r'feed':
        return DabViewTab.feed;
      case r'explorer':
        return DabViewTab.explorer;
      case r'insights':
        return DabViewTab.insights;
      case r'admin':
        return DabViewTab.admin;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DabViewTab self) {
    switch (self) {
      case DabViewTab.feed:
        return r'feed';
      case DabViewTab.explorer:
        return r'explorer';
      case DabViewTab.insights:
        return r'insights';
      case DabViewTab.admin:
        return r'admin';
    }
  }
}

extension DabViewTabMapperExtension on DabViewTab {
  String toValue() {
    DabViewTabMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DabViewTab>(this) as String;
  }
}

