// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_provider_credential_status.dart';

class UserProviderCredentialStatusMapper
    extends EnumMapper<UserProviderCredentialStatus> {
  UserProviderCredentialStatusMapper._();

  static UserProviderCredentialStatusMapper? _instance;
  static UserProviderCredentialStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = UserProviderCredentialStatusMapper._(),
      );
    }
    return _instance!;
  }

  static UserProviderCredentialStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UserProviderCredentialStatus decode(dynamic value) {
    switch (value) {
      case r'connected':
        return UserProviderCredentialStatus.connected;
      case r'failed':
        return UserProviderCredentialStatus.failed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserProviderCredentialStatus self) {
    switch (self) {
      case UserProviderCredentialStatus.connected:
        return r'connected';
      case UserProviderCredentialStatus.failed:
        return r'failed';
    }
  }
}

extension UserProviderCredentialStatusMapperExtension
    on UserProviderCredentialStatus {
  String toValue() {
    UserProviderCredentialStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UserProviderCredentialStatus>(this)
        as String;
  }
}

