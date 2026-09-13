// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'admin_section.dart';

class AdminSectionMapper extends EnumMapper<AdminSection> {
  AdminSectionMapper._();

  static AdminSectionMapper? _instance;
  static AdminSectionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminSectionMapper._());
    }
    return _instance!;
  }

  static AdminSection fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AdminSection decode(dynamic value) {
    switch (value) {
      case r'providers':
        return AdminSection.providers;
      case r'identities':
        return AdminSection.identities;
      case r'security':
        return AdminSection.security;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AdminSection self) {
    switch (self) {
      case AdminSection.providers:
        return r'providers';
      case AdminSection.identities:
        return r'identities';
      case AdminSection.security:
        return r'security';
    }
  }
}

extension AdminSectionMapperExtension on AdminSection {
  String toValue() {
    AdminSectionMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AdminSection>(this) as String;
  }
}

