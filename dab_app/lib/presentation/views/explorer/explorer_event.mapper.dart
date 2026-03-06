// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'explorer_event.dart';

class ExplorerEventMapper extends ClassMapperBase<ExplorerEvent> {
  ExplorerEventMapper._();

  static ExplorerEventMapper? _instance;
  static ExplorerEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerEventMapper._());
      ExplorerStartedMapper.ensureInitialized();
      ExplorerDateChangedMapper.ensureInitialized();
      ExplorerActivityReceivedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerEvent';

  @override
  final MappableFields<ExplorerEvent> fields = const {};

  static ExplorerEvent _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('ExplorerEvent');
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerEvent>(map);
  }

  static ExplorerEvent fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerEvent>(json);
  }
}

mixin ExplorerEventMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ExplorerEventCopyWith<ExplorerEvent, ExplorerEvent, ExplorerEvent>
  get copyWith;
}

abstract class ExplorerEventCopyWith<$R, $In extends ExplorerEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ExplorerEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class ExplorerStartedMapper extends ClassMapperBase<ExplorerStarted> {
  ExplorerStartedMapper._();

  static ExplorerStartedMapper? _instance;
  static ExplorerStartedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerStartedMapper._());
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerStarted';

  @override
  final MappableFields<ExplorerStarted> fields = const {};

  static ExplorerStarted _instantiate(DecodingData data) {
    return ExplorerStarted();
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerStarted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerStarted>(map);
  }

  static ExplorerStarted fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerStarted>(json);
  }
}

mixin ExplorerStartedMappable {
  String toJson() {
    return ExplorerStartedMapper.ensureInitialized()
        .encodeJson<ExplorerStarted>(this as ExplorerStarted);
  }

  Map<String, dynamic> toMap() {
    return ExplorerStartedMapper.ensureInitialized().encodeMap<ExplorerStarted>(
      this as ExplorerStarted,
    );
  }

  ExplorerStartedCopyWith<ExplorerStarted, ExplorerStarted, ExplorerStarted>
  get copyWith =>
      _ExplorerStartedCopyWithImpl<ExplorerStarted, ExplorerStarted>(
        this as ExplorerStarted,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ExplorerStartedMapper.ensureInitialized().stringifyValue(
      this as ExplorerStarted,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerStartedMapper.ensureInitialized().equalsValue(
      this as ExplorerStarted,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerStartedMapper.ensureInitialized().hashValue(
      this as ExplorerStarted,
    );
  }
}

extension ExplorerStartedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerStarted, $Out> {
  ExplorerStartedCopyWith<$R, ExplorerStarted, $Out> get $asExplorerStarted =>
      $base.as((v, t, t2) => _ExplorerStartedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExplorerStartedCopyWith<$R, $In extends ExplorerStarted, $Out>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  ExplorerStartedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerStartedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerStarted, $Out>
    implements ExplorerStartedCopyWith<$R, ExplorerStarted, $Out> {
  _ExplorerStartedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerStarted> $mapper =
      ExplorerStartedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  ExplorerStarted $make(CopyWithData data) => ExplorerStarted();

  @override
  ExplorerStartedCopyWith<$R2, ExplorerStarted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExplorerStartedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerDateChangedMapper extends ClassMapperBase<ExplorerDateChanged> {
  ExplorerDateChangedMapper._();

  static ExplorerDateChangedMapper? _instance;
  static ExplorerDateChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerDateChangedMapper._());
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerDateChanged';

  static DateTime _$date(ExplorerDateChanged v) => v.date;
  static const Field<ExplorerDateChanged, DateTime> _f$date = Field(
    'date',
    _$date,
  );

  @override
  final MappableFields<ExplorerDateChanged> fields = const {#date: _f$date};

  static ExplorerDateChanged _instantiate(DecodingData data) {
    return ExplorerDateChanged(data.dec(_f$date));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerDateChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerDateChanged>(map);
  }

  static ExplorerDateChanged fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerDateChanged>(json);
  }
}

mixin ExplorerDateChangedMappable {
  String toJson() {
    return ExplorerDateChangedMapper.ensureInitialized()
        .encodeJson<ExplorerDateChanged>(this as ExplorerDateChanged);
  }

  Map<String, dynamic> toMap() {
    return ExplorerDateChangedMapper.ensureInitialized()
        .encodeMap<ExplorerDateChanged>(this as ExplorerDateChanged);
  }

  ExplorerDateChangedCopyWith<
    ExplorerDateChanged,
    ExplorerDateChanged,
    ExplorerDateChanged
  >
  get copyWith =>
      _ExplorerDateChangedCopyWithImpl<
        ExplorerDateChanged,
        ExplorerDateChanged
      >(this as ExplorerDateChanged, $identity, $identity);
  @override
  String toString() {
    return ExplorerDateChangedMapper.ensureInitialized().stringifyValue(
      this as ExplorerDateChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerDateChangedMapper.ensureInitialized().equalsValue(
      this as ExplorerDateChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerDateChangedMapper.ensureInitialized().hashValue(
      this as ExplorerDateChanged,
    );
  }
}

extension ExplorerDateChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerDateChanged, $Out> {
  ExplorerDateChangedCopyWith<$R, ExplorerDateChanged, $Out>
  get $asExplorerDateChanged => $base.as(
    (v, t, t2) => _ExplorerDateChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerDateChangedCopyWith<
  $R,
  $In extends ExplorerDateChanged,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({DateTime? date});
  ExplorerDateChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerDateChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerDateChanged, $Out>
    implements ExplorerDateChangedCopyWith<$R, ExplorerDateChanged, $Out> {
  _ExplorerDateChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerDateChanged> $mapper =
      ExplorerDateChangedMapper.ensureInitialized();
  @override
  $R call({DateTime? date}) =>
      $apply(FieldCopyWithData({if (date != null) #date: date}));
  @override
  ExplorerDateChanged $make(CopyWithData data) =>
      ExplorerDateChanged(data.get(#date, or: $value.date));

  @override
  ExplorerDateChangedCopyWith<$R2, ExplorerDateChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerDateChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerActivityReceivedMapper
    extends ClassMapperBase<ExplorerActivityReceived> {
  ExplorerActivityReceivedMapper._();

  static ExplorerActivityReceivedMapper? _instance;
  static ExplorerActivityReceivedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ExplorerActivityReceivedMapper._(),
      );
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerActivityReceived';

  static dynamic _$activity(ExplorerActivityReceived v) => v.activity;
  static const Field<ExplorerActivityReceived, dynamic> _f$activity = Field(
    'activity',
    _$activity,
  );

  @override
  final MappableFields<ExplorerActivityReceived> fields = const {
    #activity: _f$activity,
  };

  static ExplorerActivityReceived _instantiate(DecodingData data) {
    return ExplorerActivityReceived(data.dec(_f$activity));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerActivityReceived fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerActivityReceived>(map);
  }

  static ExplorerActivityReceived fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerActivityReceived>(json);
  }
}

mixin ExplorerActivityReceivedMappable {
  String toJson() {
    return ExplorerActivityReceivedMapper.ensureInitialized()
        .encodeJson<ExplorerActivityReceived>(this as ExplorerActivityReceived);
  }

  Map<String, dynamic> toMap() {
    return ExplorerActivityReceivedMapper.ensureInitialized()
        .encodeMap<ExplorerActivityReceived>(this as ExplorerActivityReceived);
  }

  ExplorerActivityReceivedCopyWith<
    ExplorerActivityReceived,
    ExplorerActivityReceived,
    ExplorerActivityReceived
  >
  get copyWith =>
      _ExplorerActivityReceivedCopyWithImpl<
        ExplorerActivityReceived,
        ExplorerActivityReceived
      >(this as ExplorerActivityReceived, $identity, $identity);
  @override
  String toString() {
    return ExplorerActivityReceivedMapper.ensureInitialized().stringifyValue(
      this as ExplorerActivityReceived,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerActivityReceivedMapper.ensureInitialized().equalsValue(
      this as ExplorerActivityReceived,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerActivityReceivedMapper.ensureInitialized().hashValue(
      this as ExplorerActivityReceived,
    );
  }
}

extension ExplorerActivityReceivedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerActivityReceived, $Out> {
  ExplorerActivityReceivedCopyWith<$R, ExplorerActivityReceived, $Out>
  get $asExplorerActivityReceived => $base.as(
    (v, t, t2) => _ExplorerActivityReceivedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerActivityReceivedCopyWith<
  $R,
  $In extends ExplorerActivityReceived,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({dynamic activity});
  ExplorerActivityReceivedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerActivityReceivedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerActivityReceived, $Out>
    implements
        ExplorerActivityReceivedCopyWith<$R, ExplorerActivityReceived, $Out> {
  _ExplorerActivityReceivedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerActivityReceived> $mapper =
      ExplorerActivityReceivedMapper.ensureInitialized();
  @override
  $R call({Object? activity = $none}) =>
      $apply(FieldCopyWithData({if (activity != $none) #activity: activity}));
  @override
  ExplorerActivityReceived $make(CopyWithData data) =>
      ExplorerActivityReceived(data.get(#activity, or: $value.activity));

  @override
  ExplorerActivityReceivedCopyWith<$R2, ExplorerActivityReceived, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerActivityReceivedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

