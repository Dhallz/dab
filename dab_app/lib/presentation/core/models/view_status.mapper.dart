// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'view_status.dart';

class ViewStatusMapper extends EnumMapper<ViewStatus> {
  ViewStatusMapper._();

  static ViewStatusMapper? _instance;
  static ViewStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ViewStatusMapper._());
    }
    return _instance!;
  }

  static ViewStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ViewStatus decode(dynamic value) {
    switch (value) {
      case r'initial':
        return ViewStatus.initial;
      case r'loading':
        return ViewStatus.loading;
      case r'success':
        return ViewStatus.success;
      case r'failure':
        return ViewStatus.failure;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ViewStatus self) {
    switch (self) {
      case ViewStatus.initial:
        return r'initial';
      case ViewStatus.loading:
        return r'loading';
      case ViewStatus.success:
        return r'success';
      case ViewStatus.failure:
        return r'failure';
    }
  }
}

extension ViewStatusMapperExtension on ViewStatus {
  String toValue() {
    ViewStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ViewStatus>(this) as String;
  }
}

