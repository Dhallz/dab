// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'upcoming_event.dart';

class UpcomingEventMapper extends ClassMapperBase<UpcomingEvent> {
  UpcomingEventMapper._();

  static UpcomingEventMapper? _instance;
  static UpcomingEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UpcomingEventMapper._());
      UpcomingEventPriorityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UpcomingEvent';

  static String _$id(UpcomingEvent v) => v.id;
  static const Field<UpcomingEvent, String> _f$id = Field('id', _$id);
  static String _$title(UpcomingEvent v) => v.title;
  static const Field<UpcomingEvent, String> _f$title = Field('title', _$title);
  static DateTime _$startsAt(UpcomingEvent v) => v.startsAt;
  static const Field<UpcomingEvent, DateTime> _f$startsAt = Field(
    'startsAt',
    _$startsAt,
  );
  static String? _$url(UpcomingEvent v) => v.url;
  static const Field<UpcomingEvent, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static String _$source(UpcomingEvent v) => v.source;
  static const Field<UpcomingEvent, String> _f$source = Field(
    'source',
    _$source,
    opt: true,
    def: 'Calendar',
  );
  static UpcomingEventPriority _$priority(UpcomingEvent v) => v.priority;
  static const Field<UpcomingEvent, UpcomingEventPriority> _f$priority = Field(
    'priority',
    _$priority,
    opt: true,
    def: UpcomingEventPriority.normal,
  );

  @override
  final MappableFields<UpcomingEvent> fields = const {
    #id: _f$id,
    #title: _f$title,
    #startsAt: _f$startsAt,
    #url: _f$url,
    #source: _f$source,
    #priority: _f$priority,
  };

  static UpcomingEvent _instantiate(DecodingData data) {
    return UpcomingEvent(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      startsAt: data.dec(_f$startsAt),
      url: data.dec(_f$url),
      source: data.dec(_f$source),
      priority: data.dec(_f$priority),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UpcomingEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UpcomingEvent>(map);
  }

  static UpcomingEvent fromJson(String json) {
    return ensureInitialized().decodeJson<UpcomingEvent>(json);
  }
}

mixin UpcomingEventMappable {
  String toJson() {
    return UpcomingEventMapper.ensureInitialized().encodeJson<UpcomingEvent>(
      this as UpcomingEvent,
    );
  }

  Map<String, dynamic> toMap() {
    return UpcomingEventMapper.ensureInitialized().encodeMap<UpcomingEvent>(
      this as UpcomingEvent,
    );
  }

  UpcomingEventCopyWith<UpcomingEvent, UpcomingEvent, UpcomingEvent>
  get copyWith => _UpcomingEventCopyWithImpl<UpcomingEvent, UpcomingEvent>(
    this as UpcomingEvent,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UpcomingEventMapper.ensureInitialized().stringifyValue(
      this as UpcomingEvent,
    );
  }

  @override
  bool operator ==(Object other) {
    return UpcomingEventMapper.ensureInitialized().equalsValue(
      this as UpcomingEvent,
      other,
    );
  }

  @override
  int get hashCode {
    return UpcomingEventMapper.ensureInitialized().hashValue(
      this as UpcomingEvent,
    );
  }
}

extension UpcomingEventValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UpcomingEvent, $Out> {
  UpcomingEventCopyWith<$R, UpcomingEvent, $Out> get $asUpcomingEvent =>
      $base.as((v, t, t2) => _UpcomingEventCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UpcomingEventCopyWith<$R, $In extends UpcomingEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? title,
    DateTime? startsAt,
    String? url,
    String? source,
    UpcomingEventPriority? priority,
  });
  UpcomingEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UpcomingEventCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UpcomingEvent, $Out>
    implements UpcomingEventCopyWith<$R, UpcomingEvent, $Out> {
  _UpcomingEventCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UpcomingEvent> $mapper =
      UpcomingEventMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? title,
    DateTime? startsAt,
    Object? url = $none,
    String? source,
    UpcomingEventPriority? priority,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (startsAt != null) #startsAt: startsAt,
      if (url != $none) #url: url,
      if (source != null) #source: source,
      if (priority != null) #priority: priority,
    }),
  );
  @override
  UpcomingEvent $make(CopyWithData data) => UpcomingEvent(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    startsAt: data.get(#startsAt, or: $value.startsAt),
    url: data.get(#url, or: $value.url),
    source: data.get(#source, or: $value.source),
    priority: data.get(#priority, or: $value.priority),
  );

  @override
  UpcomingEventCopyWith<$R2, UpcomingEvent, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UpcomingEventCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

