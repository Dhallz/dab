// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'group_type.dart';

class GroupTypeMapper extends EnumMapper<GroupType> {
  GroupTypeMapper._();

  static GroupTypeMapper? _instance;
  static GroupTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GroupTypeMapper._());
    }
    return _instance!;
  }

  static GroupType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  GroupType decode(dynamic value) {
    switch (value) {
      case r'custom':
        return GroupType.custom;
      case r'provider':
        return GroupType.provider;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(GroupType self) {
    switch (self) {
      case GroupType.custom:
        return r'custom';
      case GroupType.provider:
        return r'provider';
    }
  }
}

extension GroupTypeMapperExtension on GroupType {
  String toValue() {
    GroupTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<GroupType>(this) as String;
  }
}

