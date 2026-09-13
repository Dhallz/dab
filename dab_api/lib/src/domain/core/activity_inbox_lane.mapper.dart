// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'activity_inbox_lane.dart';

class ActivityInboxLaneMapper extends EnumMapper<ActivityInboxLane> {
  ActivityInboxLaneMapper._();

  static ActivityInboxLaneMapper? _instance;
  static ActivityInboxLaneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ActivityInboxLaneMapper._());
    }
    return _instance!;
  }

  static ActivityInboxLane fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ActivityInboxLane decode(dynamic value) {
    switch (value) {
      case r'directed':
        return ActivityInboxLane.directed;
      case r'follow':
        return ActivityInboxLane.follow;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ActivityInboxLane self) {
    switch (self) {
      case ActivityInboxLane.directed:
        return r'directed';
      case ActivityInboxLane.follow:
        return r'follow';
    }
  }
}

extension ActivityInboxLaneMapperExtension on ActivityInboxLane {
  String toValue() {
    ActivityInboxLaneMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ActivityInboxLane>(this) as String;
  }
}

