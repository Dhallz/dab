// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_identity_status.dart';

class UserIdentityStatusMapper extends EnumMapper<UserIdentityStatus> {
  UserIdentityStatusMapper._();

  static UserIdentityStatusMapper? _instance;
  static UserIdentityStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserIdentityStatusMapper._());
    }
    return _instance!;
  }

  static UserIdentityStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UserIdentityStatus decode(dynamic value) {
    switch (value) {
      case r'linked':
        return UserIdentityStatus.linked;
      case r'pending':
        return UserIdentityStatus.pending;
      case r'failed':
        return UserIdentityStatus.failed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserIdentityStatus self) {
    switch (self) {
      case UserIdentityStatus.linked:
        return r'linked';
      case UserIdentityStatus.pending:
        return r'pending';
      case UserIdentityStatus.failed:
        return r'failed';
    }
  }
}

extension UserIdentityStatusMapperExtension on UserIdentityStatus {
  String toValue() {
    UserIdentityStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UserIdentityStatus>(this) as String;
  }
}

