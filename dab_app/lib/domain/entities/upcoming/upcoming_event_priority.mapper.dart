// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'upcoming_event_priority.dart';

class UpcomingEventPriorityMapper extends EnumMapper<UpcomingEventPriority> {
  UpcomingEventPriorityMapper._();

  static UpcomingEventPriorityMapper? _instance;
  static UpcomingEventPriorityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UpcomingEventPriorityMapper._());
    }
    return _instance!;
  }

  static UpcomingEventPriority fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UpcomingEventPriority decode(dynamic value) {
    switch (value) {
      case r'low':
        return UpcomingEventPriority.low;
      case r'normal':
        return UpcomingEventPriority.normal;
      case r'high':
        return UpcomingEventPriority.high;
      case r'critical':
        return UpcomingEventPriority.critical;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UpcomingEventPriority self) {
    switch (self) {
      case UpcomingEventPriority.low:
        return r'low';
      case UpcomingEventPriority.normal:
        return r'normal';
      case UpcomingEventPriority.high:
        return r'high';
      case UpcomingEventPriority.critical:
        return r'critical';
    }
  }
}

extension UpcomingEventPriorityMapperExtension on UpcomingEventPriority {
  String toValue() {
    UpcomingEventPriorityMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UpcomingEventPriority>(this)
        as String;
  }
}

