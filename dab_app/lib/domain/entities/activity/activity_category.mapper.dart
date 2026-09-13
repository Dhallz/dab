// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'activity_category.dart';

class ActivityCategoryMapper extends EnumMapper<ActivityCategory> {
  ActivityCategoryMapper._();

  static ActivityCategoryMapper? _instance;
  static ActivityCategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ActivityCategoryMapper._());
    }
    return _instance!;
  }

  static ActivityCategory fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ActivityCategory decode(dynamic value) {
    switch (value) {
      case r'commit':
        return ActivityCategory.commit;
      case r'revision':
        return ActivityCategory.revision;
      case r'task':
        return ActivityCategory.task;
      case r'message':
        return ActivityCategory.message;
      case r'generic':
        return ActivityCategory.generic;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ActivityCategory self) {
    switch (self) {
      case ActivityCategory.commit:
        return r'commit';
      case ActivityCategory.revision:
        return r'revision';
      case ActivityCategory.task:
        return r'task';
      case ActivityCategory.message:
        return r'message';
      case ActivityCategory.generic:
        return r'generic';
    }
  }
}

extension ActivityCategoryMapperExtension on ActivityCategory {
  String toValue() {
    ActivityCategoryMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ActivityCategory>(this) as String;
  }
}

