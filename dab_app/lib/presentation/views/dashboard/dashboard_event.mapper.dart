// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'dashboard_event.dart';

class DashboardEventMapper extends ClassMapperBase<DashboardEvent> {
  DashboardEventMapper._();

  static DashboardEventMapper? _instance;
  static DashboardEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DashboardEventMapper._());
      DashboardStartedMapper.ensureInitialized();
      DashboardActivityReceivedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardEvent';

  @override
  final MappableFields<DashboardEvent> fields = const {};

  static DashboardEvent _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('DashboardEvent');
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardEvent>(map);
  }

  static DashboardEvent fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardEvent>(json);
  }
}

mixin DashboardEventMappable {
  String toJson();
  Map<String, dynamic> toMap();
  DashboardEventCopyWith<DashboardEvent, DashboardEvent, DashboardEvent>
  get copyWith;
}

abstract class DashboardEventCopyWith<$R, $In extends DashboardEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  DashboardEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class DashboardStartedMapper extends ClassMapperBase<DashboardStarted> {
  DashboardStartedMapper._();

  static DashboardStartedMapper? _instance;
  static DashboardStartedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DashboardStartedMapper._());
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardStarted';

  @override
  final MappableFields<DashboardStarted> fields = const {};

  static DashboardStarted _instantiate(DecodingData data) {
    return DashboardStarted();
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardStarted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardStarted>(map);
  }

  static DashboardStarted fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardStarted>(json);
  }
}

mixin DashboardStartedMappable {
  String toJson() {
    return DashboardStartedMapper.ensureInitialized()
        .encodeJson<DashboardStarted>(this as DashboardStarted);
  }

  Map<String, dynamic> toMap() {
    return DashboardStartedMapper.ensureInitialized()
        .encodeMap<DashboardStarted>(this as DashboardStarted);
  }

  DashboardStartedCopyWith<DashboardStarted, DashboardStarted, DashboardStarted>
  get copyWith =>
      _DashboardStartedCopyWithImpl<DashboardStarted, DashboardStarted>(
        this as DashboardStarted,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DashboardStartedMapper.ensureInitialized().stringifyValue(
      this as DashboardStarted,
    );
  }

  @override
  bool operator ==(Object other) {
    return DashboardStartedMapper.ensureInitialized().equalsValue(
      this as DashboardStarted,
      other,
    );
  }

  @override
  int get hashCode {
    return DashboardStartedMapper.ensureInitialized().hashValue(
      this as DashboardStarted,
    );
  }
}

extension DashboardStartedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardStarted, $Out> {
  DashboardStartedCopyWith<$R, DashboardStarted, $Out>
  get $asDashboardStarted =>
      $base.as((v, t, t2) => _DashboardStartedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DashboardStartedCopyWith<$R, $In extends DashboardStarted, $Out>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DashboardStartedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardStartedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardStarted, $Out>
    implements DashboardStartedCopyWith<$R, DashboardStarted, $Out> {
  _DashboardStartedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DashboardStarted> $mapper =
      DashboardStartedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DashboardStarted $make(CopyWithData data) => DashboardStarted();

  @override
  DashboardStartedCopyWith<$R2, DashboardStarted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DashboardStartedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DashboardActivityReceivedMapper
    extends ClassMapperBase<DashboardActivityReceived> {
  DashboardActivityReceivedMapper._();

  static DashboardActivityReceivedMapper? _instance;
  static DashboardActivityReceivedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardActivityReceivedMapper._(),
      );
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardActivityReceived';

  static dynamic _$activity(DashboardActivityReceived v) => v.activity;
  static const Field<DashboardActivityReceived, dynamic> _f$activity = Field(
    'activity',
    _$activity,
  );

  @override
  final MappableFields<DashboardActivityReceived> fields = const {
    #activity: _f$activity,
  };

  static DashboardActivityReceived _instantiate(DecodingData data) {
    return DashboardActivityReceived(data.dec(_f$activity));
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardActivityReceived fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardActivityReceived>(map);
  }

  static DashboardActivityReceived fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardActivityReceived>(json);
  }
}

mixin DashboardActivityReceivedMappable {
  String toJson() {
    return DashboardActivityReceivedMapper.ensureInitialized()
        .encodeJson<DashboardActivityReceived>(
          this as DashboardActivityReceived,
        );
  }

  Map<String, dynamic> toMap() {
    return DashboardActivityReceivedMapper.ensureInitialized()
        .encodeMap<DashboardActivityReceived>(
          this as DashboardActivityReceived,
        );
  }

  DashboardActivityReceivedCopyWith<
    DashboardActivityReceived,
    DashboardActivityReceived,
    DashboardActivityReceived
  >
  get copyWith =>
      _DashboardActivityReceivedCopyWithImpl<
        DashboardActivityReceived,
        DashboardActivityReceived
      >(this as DashboardActivityReceived, $identity, $identity);
  @override
  String toString() {
    return DashboardActivityReceivedMapper.ensureInitialized().stringifyValue(
      this as DashboardActivityReceived,
    );
  }

  @override
  bool operator ==(Object other) {
    return DashboardActivityReceivedMapper.ensureInitialized().equalsValue(
      this as DashboardActivityReceived,
      other,
    );
  }

  @override
  int get hashCode {
    return DashboardActivityReceivedMapper.ensureInitialized().hashValue(
      this as DashboardActivityReceived,
    );
  }
}

extension DashboardActivityReceivedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardActivityReceived, $Out> {
  DashboardActivityReceivedCopyWith<$R, DashboardActivityReceived, $Out>
  get $asDashboardActivityReceived => $base.as(
    (v, t, t2) => _DashboardActivityReceivedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardActivityReceivedCopyWith<
  $R,
  $In extends DashboardActivityReceived,
  $Out
>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call({dynamic activity});
  DashboardActivityReceivedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardActivityReceivedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardActivityReceived, $Out>
    implements
        DashboardActivityReceivedCopyWith<$R, DashboardActivityReceived, $Out> {
  _DashboardActivityReceivedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DashboardActivityReceived> $mapper =
      DashboardActivityReceivedMapper.ensureInitialized();
  @override
  $R call({Object? activity = $none}) =>
      $apply(FieldCopyWithData({if (activity != $none) #activity: activity}));
  @override
  DashboardActivityReceived $make(CopyWithData data) =>
      DashboardActivityReceived(data.get(#activity, or: $value.activity));

  @override
  DashboardActivityReceivedCopyWith<$R2, DashboardActivityReceived, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardActivityReceivedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

