// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'directory_type.dart';

class DirectoryTypeMapper extends EnumMapper<DirectoryType> {
  DirectoryTypeMapper._();

  static DirectoryTypeMapper? _instance;
  static DirectoryTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DirectoryTypeMapper._());
    }
    return _instance!;
  }

  static DirectoryType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DirectoryType decode(dynamic value) {
    switch (value) {
      case r'users':
        return DirectoryType.users;
      case r'groups':
        return DirectoryType.groups;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DirectoryType self) {
    switch (self) {
      case DirectoryType.users:
        return r'users';
      case DirectoryType.groups:
        return r'groups';
    }
  }
}

extension DirectoryTypeMapperExtension on DirectoryType {
  String toValue() {
    DirectoryTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DirectoryType>(this) as String;
  }
}

