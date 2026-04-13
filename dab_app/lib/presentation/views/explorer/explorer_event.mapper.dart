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
      ExplorerDateModeChangedMapper.ensureInitialized();
      ExplorerDateRangeChangedMapper.ensureInitialized();
      ExplorerActivityReceivedMapper.ensureInitialized();
      ExplorerDirectoryTypeChangedMapper.ensureInitialized();
      ExplorerUserToggledMapper.ensureInitialized();
      ExplorerGroupToggledMapper.ensureInitialized();
      ExplorerProviderToggledMapper.ensureInitialized();
      ExplorerRefreshRequestedMapper.ensureInitialized();
      ExplorerGroupSavedMapper.ensureInitialized();
      ExplorerStackToggledMapper.ensureInitialized();
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

  static String? _$connectedUserId(ExplorerStarted v) => v.connectedUserId;
  static const Field<ExplorerStarted, String> _f$connectedUserId = Field(
    'connectedUserId',
    _$connectedUserId,
    opt: true,
  );

  @override
  final MappableFields<ExplorerStarted> fields = const {
    #connectedUserId: _f$connectedUserId,
  };

  static ExplorerStarted _instantiate(DecodingData data) {
    return ExplorerStarted(connectedUserId: data.dec(_f$connectedUserId));
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
  $R call({String? connectedUserId});
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
  $R call({Object? connectedUserId = $none}) => $apply(
    FieldCopyWithData({
      if (connectedUserId != $none) #connectedUserId: connectedUserId,
    }),
  );
  @override
  ExplorerStarted $make(CopyWithData data) => ExplorerStarted(
    connectedUserId: data.get(#connectedUserId, or: $value.connectedUserId),
  );

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

class ExplorerDateModeChangedMapper
    extends ClassMapperBase<ExplorerDateModeChanged> {
  ExplorerDateModeChangedMapper._();

  static ExplorerDateModeChangedMapper? _instance;
  static ExplorerDateModeChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ExplorerDateModeChangedMapper._(),
      );
      ExplorerEventMapper.ensureInitialized();
      ExplorerDateModeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerDateModeChanged';

  static ExplorerDateMode _$mode(ExplorerDateModeChanged v) => v.mode;
  static const Field<ExplorerDateModeChanged, ExplorerDateMode> _f$mode = Field(
    'mode',
    _$mode,
  );

  @override
  final MappableFields<ExplorerDateModeChanged> fields = const {#mode: _f$mode};

  static ExplorerDateModeChanged _instantiate(DecodingData data) {
    return ExplorerDateModeChanged(data.dec(_f$mode));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerDateModeChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerDateModeChanged>(map);
  }

  static ExplorerDateModeChanged fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerDateModeChanged>(json);
  }
}

mixin ExplorerDateModeChangedMappable {
  String toJson() {
    return ExplorerDateModeChangedMapper.ensureInitialized()
        .encodeJson<ExplorerDateModeChanged>(this as ExplorerDateModeChanged);
  }

  Map<String, dynamic> toMap() {
    return ExplorerDateModeChangedMapper.ensureInitialized()
        .encodeMap<ExplorerDateModeChanged>(this as ExplorerDateModeChanged);
  }

  ExplorerDateModeChangedCopyWith<
    ExplorerDateModeChanged,
    ExplorerDateModeChanged,
    ExplorerDateModeChanged
  >
  get copyWith =>
      _ExplorerDateModeChangedCopyWithImpl<
        ExplorerDateModeChanged,
        ExplorerDateModeChanged
      >(this as ExplorerDateModeChanged, $identity, $identity);
  @override
  String toString() {
    return ExplorerDateModeChangedMapper.ensureInitialized().stringifyValue(
      this as ExplorerDateModeChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerDateModeChangedMapper.ensureInitialized().equalsValue(
      this as ExplorerDateModeChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerDateModeChangedMapper.ensureInitialized().hashValue(
      this as ExplorerDateModeChanged,
    );
  }
}

extension ExplorerDateModeChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerDateModeChanged, $Out> {
  ExplorerDateModeChangedCopyWith<$R, ExplorerDateModeChanged, $Out>
  get $asExplorerDateModeChanged => $base.as(
    (v, t, t2) => _ExplorerDateModeChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerDateModeChangedCopyWith<
  $R,
  $In extends ExplorerDateModeChanged,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({ExplorerDateMode? mode});
  ExplorerDateModeChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerDateModeChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerDateModeChanged, $Out>
    implements
        ExplorerDateModeChangedCopyWith<$R, ExplorerDateModeChanged, $Out> {
  _ExplorerDateModeChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerDateModeChanged> $mapper =
      ExplorerDateModeChangedMapper.ensureInitialized();
  @override
  $R call({ExplorerDateMode? mode}) =>
      $apply(FieldCopyWithData({if (mode != null) #mode: mode}));
  @override
  ExplorerDateModeChanged $make(CopyWithData data) =>
      ExplorerDateModeChanged(data.get(#mode, or: $value.mode));

  @override
  ExplorerDateModeChangedCopyWith<$R2, ExplorerDateModeChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerDateModeChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerDateRangeChangedMapper
    extends ClassMapperBase<ExplorerDateRangeChanged> {
  ExplorerDateRangeChangedMapper._();

  static ExplorerDateRangeChangedMapper? _instance;
  static ExplorerDateRangeChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ExplorerDateRangeChangedMapper._(),
      );
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerDateRangeChanged';

  static DateTime _$startDate(ExplorerDateRangeChanged v) => v.startDate;
  static const Field<ExplorerDateRangeChanged, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
  );
  static DateTime _$endDate(ExplorerDateRangeChanged v) => v.endDate;
  static const Field<ExplorerDateRangeChanged, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
  );

  @override
  final MappableFields<ExplorerDateRangeChanged> fields = const {
    #startDate: _f$startDate,
    #endDate: _f$endDate,
  };

  static ExplorerDateRangeChanged _instantiate(DecodingData data) {
    return ExplorerDateRangeChanged(
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerDateRangeChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerDateRangeChanged>(map);
  }

  static ExplorerDateRangeChanged fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerDateRangeChanged>(json);
  }
}

mixin ExplorerDateRangeChangedMappable {
  String toJson() {
    return ExplorerDateRangeChangedMapper.ensureInitialized()
        .encodeJson<ExplorerDateRangeChanged>(this as ExplorerDateRangeChanged);
  }

  Map<String, dynamic> toMap() {
    return ExplorerDateRangeChangedMapper.ensureInitialized()
        .encodeMap<ExplorerDateRangeChanged>(this as ExplorerDateRangeChanged);
  }

  ExplorerDateRangeChangedCopyWith<
    ExplorerDateRangeChanged,
    ExplorerDateRangeChanged,
    ExplorerDateRangeChanged
  >
  get copyWith =>
      _ExplorerDateRangeChangedCopyWithImpl<
        ExplorerDateRangeChanged,
        ExplorerDateRangeChanged
      >(this as ExplorerDateRangeChanged, $identity, $identity);
  @override
  String toString() {
    return ExplorerDateRangeChangedMapper.ensureInitialized().stringifyValue(
      this as ExplorerDateRangeChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerDateRangeChangedMapper.ensureInitialized().equalsValue(
      this as ExplorerDateRangeChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerDateRangeChangedMapper.ensureInitialized().hashValue(
      this as ExplorerDateRangeChanged,
    );
  }
}

extension ExplorerDateRangeChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerDateRangeChanged, $Out> {
  ExplorerDateRangeChangedCopyWith<$R, ExplorerDateRangeChanged, $Out>
  get $asExplorerDateRangeChanged => $base.as(
    (v, t, t2) => _ExplorerDateRangeChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerDateRangeChangedCopyWith<
  $R,
  $In extends ExplorerDateRangeChanged,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({DateTime? startDate, DateTime? endDate});
  ExplorerDateRangeChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerDateRangeChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerDateRangeChanged, $Out>
    implements
        ExplorerDateRangeChangedCopyWith<$R, ExplorerDateRangeChanged, $Out> {
  _ExplorerDateRangeChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerDateRangeChanged> $mapper =
      ExplorerDateRangeChangedMapper.ensureInitialized();
  @override
  $R call({DateTime? startDate, DateTime? endDate}) => $apply(
    FieldCopyWithData({
      if (startDate != null) #startDate: startDate,
      if (endDate != null) #endDate: endDate,
    }),
  );
  @override
  ExplorerDateRangeChanged $make(CopyWithData data) => ExplorerDateRangeChanged(
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
  );

  @override
  ExplorerDateRangeChangedCopyWith<$R2, ExplorerDateRangeChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerDateRangeChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
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

class ExplorerDirectoryTypeChangedMapper
    extends ClassMapperBase<ExplorerDirectoryTypeChanged> {
  ExplorerDirectoryTypeChangedMapper._();

  static ExplorerDirectoryTypeChangedMapper? _instance;
  static ExplorerDirectoryTypeChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ExplorerDirectoryTypeChangedMapper._(),
      );
      ExplorerEventMapper.ensureInitialized();
      DirectoryTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerDirectoryTypeChanged';

  static DirectoryType _$type(ExplorerDirectoryTypeChanged v) => v.type;
  static const Field<ExplorerDirectoryTypeChanged, DirectoryType> _f$type =
      Field('type', _$type);

  @override
  final MappableFields<ExplorerDirectoryTypeChanged> fields = const {
    #type: _f$type,
  };

  static ExplorerDirectoryTypeChanged _instantiate(DecodingData data) {
    return ExplorerDirectoryTypeChanged(data.dec(_f$type));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerDirectoryTypeChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerDirectoryTypeChanged>(map);
  }

  static ExplorerDirectoryTypeChanged fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerDirectoryTypeChanged>(json);
  }
}

mixin ExplorerDirectoryTypeChangedMappable {
  String toJson() {
    return ExplorerDirectoryTypeChangedMapper.ensureInitialized()
        .encodeJson<ExplorerDirectoryTypeChanged>(
          this as ExplorerDirectoryTypeChanged,
        );
  }

  Map<String, dynamic> toMap() {
    return ExplorerDirectoryTypeChangedMapper.ensureInitialized()
        .encodeMap<ExplorerDirectoryTypeChanged>(
          this as ExplorerDirectoryTypeChanged,
        );
  }

  ExplorerDirectoryTypeChangedCopyWith<
    ExplorerDirectoryTypeChanged,
    ExplorerDirectoryTypeChanged,
    ExplorerDirectoryTypeChanged
  >
  get copyWith =>
      _ExplorerDirectoryTypeChangedCopyWithImpl<
        ExplorerDirectoryTypeChanged,
        ExplorerDirectoryTypeChanged
      >(this as ExplorerDirectoryTypeChanged, $identity, $identity);
  @override
  String toString() {
    return ExplorerDirectoryTypeChangedMapper.ensureInitialized()
        .stringifyValue(this as ExplorerDirectoryTypeChanged);
  }

  @override
  bool operator ==(Object other) {
    return ExplorerDirectoryTypeChangedMapper.ensureInitialized().equalsValue(
      this as ExplorerDirectoryTypeChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerDirectoryTypeChangedMapper.ensureInitialized().hashValue(
      this as ExplorerDirectoryTypeChanged,
    );
  }
}

extension ExplorerDirectoryTypeChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerDirectoryTypeChanged, $Out> {
  ExplorerDirectoryTypeChangedCopyWith<$R, ExplorerDirectoryTypeChanged, $Out>
  get $asExplorerDirectoryTypeChanged => $base.as(
    (v, t, t2) => _ExplorerDirectoryTypeChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerDirectoryTypeChangedCopyWith<
  $R,
  $In extends ExplorerDirectoryTypeChanged,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({DirectoryType? type});
  ExplorerDirectoryTypeChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerDirectoryTypeChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerDirectoryTypeChanged, $Out>
    implements
        ExplorerDirectoryTypeChangedCopyWith<
          $R,
          ExplorerDirectoryTypeChanged,
          $Out
        > {
  _ExplorerDirectoryTypeChangedCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<ExplorerDirectoryTypeChanged> $mapper =
      ExplorerDirectoryTypeChangedMapper.ensureInitialized();
  @override
  $R call({DirectoryType? type}) =>
      $apply(FieldCopyWithData({if (type != null) #type: type}));
  @override
  ExplorerDirectoryTypeChanged $make(CopyWithData data) =>
      ExplorerDirectoryTypeChanged(data.get(#type, or: $value.type));

  @override
  ExplorerDirectoryTypeChangedCopyWith<$R2, ExplorerDirectoryTypeChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerDirectoryTypeChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerUserToggledMapper extends ClassMapperBase<ExplorerUserToggled> {
  ExplorerUserToggledMapper._();

  static ExplorerUserToggledMapper? _instance;
  static ExplorerUserToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerUserToggledMapper._());
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerUserToggled';

  static String _$userId(ExplorerUserToggled v) => v.userId;
  static const Field<ExplorerUserToggled, String> _f$userId = Field(
    'userId',
    _$userId,
  );

  @override
  final MappableFields<ExplorerUserToggled> fields = const {#userId: _f$userId};

  static ExplorerUserToggled _instantiate(DecodingData data) {
    return ExplorerUserToggled(data.dec(_f$userId));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerUserToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerUserToggled>(map);
  }

  static ExplorerUserToggled fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerUserToggled>(json);
  }
}

mixin ExplorerUserToggledMappable {
  String toJson() {
    return ExplorerUserToggledMapper.ensureInitialized()
        .encodeJson<ExplorerUserToggled>(this as ExplorerUserToggled);
  }

  Map<String, dynamic> toMap() {
    return ExplorerUserToggledMapper.ensureInitialized()
        .encodeMap<ExplorerUserToggled>(this as ExplorerUserToggled);
  }

  ExplorerUserToggledCopyWith<
    ExplorerUserToggled,
    ExplorerUserToggled,
    ExplorerUserToggled
  >
  get copyWith =>
      _ExplorerUserToggledCopyWithImpl<
        ExplorerUserToggled,
        ExplorerUserToggled
      >(this as ExplorerUserToggled, $identity, $identity);
  @override
  String toString() {
    return ExplorerUserToggledMapper.ensureInitialized().stringifyValue(
      this as ExplorerUserToggled,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerUserToggledMapper.ensureInitialized().equalsValue(
      this as ExplorerUserToggled,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerUserToggledMapper.ensureInitialized().hashValue(
      this as ExplorerUserToggled,
    );
  }
}

extension ExplorerUserToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerUserToggled, $Out> {
  ExplorerUserToggledCopyWith<$R, ExplorerUserToggled, $Out>
  get $asExplorerUserToggled => $base.as(
    (v, t, t2) => _ExplorerUserToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerUserToggledCopyWith<
  $R,
  $In extends ExplorerUserToggled,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? userId});
  ExplorerUserToggledCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerUserToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerUserToggled, $Out>
    implements ExplorerUserToggledCopyWith<$R, ExplorerUserToggled, $Out> {
  _ExplorerUserToggledCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerUserToggled> $mapper =
      ExplorerUserToggledMapper.ensureInitialized();
  @override
  $R call({String? userId}) =>
      $apply(FieldCopyWithData({if (userId != null) #userId: userId}));
  @override
  ExplorerUserToggled $make(CopyWithData data) =>
      ExplorerUserToggled(data.get(#userId, or: $value.userId));

  @override
  ExplorerUserToggledCopyWith<$R2, ExplorerUserToggled, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerUserToggledCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerGroupToggledMapper extends ClassMapperBase<ExplorerGroupToggled> {
  ExplorerGroupToggledMapper._();

  static ExplorerGroupToggledMapper? _instance;
  static ExplorerGroupToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerGroupToggledMapper._());
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerGroupToggled';

  static String _$groupId(ExplorerGroupToggled v) => v.groupId;
  static const Field<ExplorerGroupToggled, String> _f$groupId = Field(
    'groupId',
    _$groupId,
  );

  @override
  final MappableFields<ExplorerGroupToggled> fields = const {
    #groupId: _f$groupId,
  };

  static ExplorerGroupToggled _instantiate(DecodingData data) {
    return ExplorerGroupToggled(data.dec(_f$groupId));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerGroupToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerGroupToggled>(map);
  }

  static ExplorerGroupToggled fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerGroupToggled>(json);
  }
}

mixin ExplorerGroupToggledMappable {
  String toJson() {
    return ExplorerGroupToggledMapper.ensureInitialized()
        .encodeJson<ExplorerGroupToggled>(this as ExplorerGroupToggled);
  }

  Map<String, dynamic> toMap() {
    return ExplorerGroupToggledMapper.ensureInitialized()
        .encodeMap<ExplorerGroupToggled>(this as ExplorerGroupToggled);
  }

  ExplorerGroupToggledCopyWith<
    ExplorerGroupToggled,
    ExplorerGroupToggled,
    ExplorerGroupToggled
  >
  get copyWith =>
      _ExplorerGroupToggledCopyWithImpl<
        ExplorerGroupToggled,
        ExplorerGroupToggled
      >(this as ExplorerGroupToggled, $identity, $identity);
  @override
  String toString() {
    return ExplorerGroupToggledMapper.ensureInitialized().stringifyValue(
      this as ExplorerGroupToggled,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerGroupToggledMapper.ensureInitialized().equalsValue(
      this as ExplorerGroupToggled,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerGroupToggledMapper.ensureInitialized().hashValue(
      this as ExplorerGroupToggled,
    );
  }
}

extension ExplorerGroupToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerGroupToggled, $Out> {
  ExplorerGroupToggledCopyWith<$R, ExplorerGroupToggled, $Out>
  get $asExplorerGroupToggled => $base.as(
    (v, t, t2) => _ExplorerGroupToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerGroupToggledCopyWith<
  $R,
  $In extends ExplorerGroupToggled,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? groupId});
  ExplorerGroupToggledCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerGroupToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerGroupToggled, $Out>
    implements ExplorerGroupToggledCopyWith<$R, ExplorerGroupToggled, $Out> {
  _ExplorerGroupToggledCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerGroupToggled> $mapper =
      ExplorerGroupToggledMapper.ensureInitialized();
  @override
  $R call({String? groupId}) =>
      $apply(FieldCopyWithData({if (groupId != null) #groupId: groupId}));
  @override
  ExplorerGroupToggled $make(CopyWithData data) =>
      ExplorerGroupToggled(data.get(#groupId, or: $value.groupId));

  @override
  ExplorerGroupToggledCopyWith<$R2, ExplorerGroupToggled, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerGroupToggledCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerProviderToggledMapper
    extends ClassMapperBase<ExplorerProviderToggled> {
  ExplorerProviderToggledMapper._();

  static ExplorerProviderToggledMapper? _instance;
  static ExplorerProviderToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ExplorerProviderToggledMapper._(),
      );
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerProviderToggled';

  static String _$provider(ExplorerProviderToggled v) => v.provider;
  static const Field<ExplorerProviderToggled, String> _f$provider = Field(
    'provider',
    _$provider,
  );

  @override
  final MappableFields<ExplorerProviderToggled> fields = const {
    #provider: _f$provider,
  };

  static ExplorerProviderToggled _instantiate(DecodingData data) {
    return ExplorerProviderToggled(data.dec(_f$provider));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerProviderToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerProviderToggled>(map);
  }

  static ExplorerProviderToggled fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerProviderToggled>(json);
  }
}

mixin ExplorerProviderToggledMappable {
  String toJson() {
    return ExplorerProviderToggledMapper.ensureInitialized()
        .encodeJson<ExplorerProviderToggled>(this as ExplorerProviderToggled);
  }

  Map<String, dynamic> toMap() {
    return ExplorerProviderToggledMapper.ensureInitialized()
        .encodeMap<ExplorerProviderToggled>(this as ExplorerProviderToggled);
  }

  ExplorerProviderToggledCopyWith<
    ExplorerProviderToggled,
    ExplorerProviderToggled,
    ExplorerProviderToggled
  >
  get copyWith =>
      _ExplorerProviderToggledCopyWithImpl<
        ExplorerProviderToggled,
        ExplorerProviderToggled
      >(this as ExplorerProviderToggled, $identity, $identity);
  @override
  String toString() {
    return ExplorerProviderToggledMapper.ensureInitialized().stringifyValue(
      this as ExplorerProviderToggled,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerProviderToggledMapper.ensureInitialized().equalsValue(
      this as ExplorerProviderToggled,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerProviderToggledMapper.ensureInitialized().hashValue(
      this as ExplorerProviderToggled,
    );
  }
}

extension ExplorerProviderToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerProviderToggled, $Out> {
  ExplorerProviderToggledCopyWith<$R, ExplorerProviderToggled, $Out>
  get $asExplorerProviderToggled => $base.as(
    (v, t, t2) => _ExplorerProviderToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerProviderToggledCopyWith<
  $R,
  $In extends ExplorerProviderToggled,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? provider});
  ExplorerProviderToggledCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerProviderToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerProviderToggled, $Out>
    implements
        ExplorerProviderToggledCopyWith<$R, ExplorerProviderToggled, $Out> {
  _ExplorerProviderToggledCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerProviderToggled> $mapper =
      ExplorerProviderToggledMapper.ensureInitialized();
  @override
  $R call({String? provider}) =>
      $apply(FieldCopyWithData({if (provider != null) #provider: provider}));
  @override
  ExplorerProviderToggled $make(CopyWithData data) =>
      ExplorerProviderToggled(data.get(#provider, or: $value.provider));

  @override
  ExplorerProviderToggledCopyWith<$R2, ExplorerProviderToggled, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerProviderToggledCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerRefreshRequestedMapper
    extends ClassMapperBase<ExplorerRefreshRequested> {
  ExplorerRefreshRequestedMapper._();

  static ExplorerRefreshRequestedMapper? _instance;
  static ExplorerRefreshRequestedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ExplorerRefreshRequestedMapper._(),
      );
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerRefreshRequested';

  @override
  final MappableFields<ExplorerRefreshRequested> fields = const {};

  static ExplorerRefreshRequested _instantiate(DecodingData data) {
    return ExplorerRefreshRequested();
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerRefreshRequested fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerRefreshRequested>(map);
  }

  static ExplorerRefreshRequested fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerRefreshRequested>(json);
  }
}

mixin ExplorerRefreshRequestedMappable {
  String toJson() {
    return ExplorerRefreshRequestedMapper.ensureInitialized()
        .encodeJson<ExplorerRefreshRequested>(this as ExplorerRefreshRequested);
  }

  Map<String, dynamic> toMap() {
    return ExplorerRefreshRequestedMapper.ensureInitialized()
        .encodeMap<ExplorerRefreshRequested>(this as ExplorerRefreshRequested);
  }

  ExplorerRefreshRequestedCopyWith<
    ExplorerRefreshRequested,
    ExplorerRefreshRequested,
    ExplorerRefreshRequested
  >
  get copyWith =>
      _ExplorerRefreshRequestedCopyWithImpl<
        ExplorerRefreshRequested,
        ExplorerRefreshRequested
      >(this as ExplorerRefreshRequested, $identity, $identity);
  @override
  String toString() {
    return ExplorerRefreshRequestedMapper.ensureInitialized().stringifyValue(
      this as ExplorerRefreshRequested,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerRefreshRequestedMapper.ensureInitialized().equalsValue(
      this as ExplorerRefreshRequested,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerRefreshRequestedMapper.ensureInitialized().hashValue(
      this as ExplorerRefreshRequested,
    );
  }
}

extension ExplorerRefreshRequestedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerRefreshRequested, $Out> {
  ExplorerRefreshRequestedCopyWith<$R, ExplorerRefreshRequested, $Out>
  get $asExplorerRefreshRequested => $base.as(
    (v, t, t2) => _ExplorerRefreshRequestedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerRefreshRequestedCopyWith<
  $R,
  $In extends ExplorerRefreshRequested,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  ExplorerRefreshRequestedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerRefreshRequestedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerRefreshRequested, $Out>
    implements
        ExplorerRefreshRequestedCopyWith<$R, ExplorerRefreshRequested, $Out> {
  _ExplorerRefreshRequestedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerRefreshRequested> $mapper =
      ExplorerRefreshRequestedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  ExplorerRefreshRequested $make(CopyWithData data) =>
      ExplorerRefreshRequested();

  @override
  ExplorerRefreshRequestedCopyWith<$R2, ExplorerRefreshRequested, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerRefreshRequestedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerGroupSavedMapper extends ClassMapperBase<ExplorerGroupSaved> {
  ExplorerGroupSavedMapper._();

  static ExplorerGroupSavedMapper? _instance;
  static ExplorerGroupSavedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerGroupSavedMapper._());
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerGroupSaved';

  static dynamic _$group(ExplorerGroupSaved v) => v.group;
  static const Field<ExplorerGroupSaved, dynamic> _f$group = Field(
    'group',
    _$group,
  );

  @override
  final MappableFields<ExplorerGroupSaved> fields = const {#group: _f$group};

  static ExplorerGroupSaved _instantiate(DecodingData data) {
    return ExplorerGroupSaved(data.dec(_f$group));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerGroupSaved fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerGroupSaved>(map);
  }

  static ExplorerGroupSaved fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerGroupSaved>(json);
  }
}

mixin ExplorerGroupSavedMappable {
  String toJson() {
    return ExplorerGroupSavedMapper.ensureInitialized()
        .encodeJson<ExplorerGroupSaved>(this as ExplorerGroupSaved);
  }

  Map<String, dynamic> toMap() {
    return ExplorerGroupSavedMapper.ensureInitialized()
        .encodeMap<ExplorerGroupSaved>(this as ExplorerGroupSaved);
  }

  ExplorerGroupSavedCopyWith<
    ExplorerGroupSaved,
    ExplorerGroupSaved,
    ExplorerGroupSaved
  >
  get copyWith =>
      _ExplorerGroupSavedCopyWithImpl<ExplorerGroupSaved, ExplorerGroupSaved>(
        this as ExplorerGroupSaved,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ExplorerGroupSavedMapper.ensureInitialized().stringifyValue(
      this as ExplorerGroupSaved,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerGroupSavedMapper.ensureInitialized().equalsValue(
      this as ExplorerGroupSaved,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerGroupSavedMapper.ensureInitialized().hashValue(
      this as ExplorerGroupSaved,
    );
  }
}

extension ExplorerGroupSavedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerGroupSaved, $Out> {
  ExplorerGroupSavedCopyWith<$R, ExplorerGroupSaved, $Out>
  get $asExplorerGroupSaved => $base.as(
    (v, t, t2) => _ExplorerGroupSavedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerGroupSavedCopyWith<
  $R,
  $In extends ExplorerGroupSaved,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({dynamic group});
  ExplorerGroupSavedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerGroupSavedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerGroupSaved, $Out>
    implements ExplorerGroupSavedCopyWith<$R, ExplorerGroupSaved, $Out> {
  _ExplorerGroupSavedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerGroupSaved> $mapper =
      ExplorerGroupSavedMapper.ensureInitialized();
  @override
  $R call({Object? group = $none}) =>
      $apply(FieldCopyWithData({if (group != $none) #group: group}));
  @override
  ExplorerGroupSaved $make(CopyWithData data) =>
      ExplorerGroupSaved(data.get(#group, or: $value.group));

  @override
  ExplorerGroupSavedCopyWith<$R2, ExplorerGroupSaved, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExplorerGroupSavedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExplorerStackToggledMapper extends ClassMapperBase<ExplorerStackToggled> {
  ExplorerStackToggledMapper._();

  static ExplorerStackToggledMapper? _instance;
  static ExplorerStackToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerStackToggledMapper._());
      ExplorerEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerStackToggled';

  static String _$taskId(ExplorerStackToggled v) => v.taskId;
  static const Field<ExplorerStackToggled, String> _f$taskId = Field(
    'taskId',
    _$taskId,
  );

  @override
  final MappableFields<ExplorerStackToggled> fields = const {
    #taskId: _f$taskId,
  };

  static ExplorerStackToggled _instantiate(DecodingData data) {
    return ExplorerStackToggled(data.dec(_f$taskId));
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerStackToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerStackToggled>(map);
  }

  static ExplorerStackToggled fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerStackToggled>(json);
  }
}

mixin ExplorerStackToggledMappable {
  String toJson() {
    return ExplorerStackToggledMapper.ensureInitialized()
        .encodeJson<ExplorerStackToggled>(this as ExplorerStackToggled);
  }

  Map<String, dynamic> toMap() {
    return ExplorerStackToggledMapper.ensureInitialized()
        .encodeMap<ExplorerStackToggled>(this as ExplorerStackToggled);
  }

  ExplorerStackToggledCopyWith<
    ExplorerStackToggled,
    ExplorerStackToggled,
    ExplorerStackToggled
  >
  get copyWith =>
      _ExplorerStackToggledCopyWithImpl<
        ExplorerStackToggled,
        ExplorerStackToggled
      >(this as ExplorerStackToggled, $identity, $identity);
  @override
  String toString() {
    return ExplorerStackToggledMapper.ensureInitialized().stringifyValue(
      this as ExplorerStackToggled,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerStackToggledMapper.ensureInitialized().equalsValue(
      this as ExplorerStackToggled,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerStackToggledMapper.ensureInitialized().hashValue(
      this as ExplorerStackToggled,
    );
  }
}

extension ExplorerStackToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerStackToggled, $Out> {
  ExplorerStackToggledCopyWith<$R, ExplorerStackToggled, $Out>
  get $asExplorerStackToggled => $base.as(
    (v, t, t2) => _ExplorerStackToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExplorerStackToggledCopyWith<
  $R,
  $In extends ExplorerStackToggled,
  $Out
>
    implements ExplorerEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? taskId});
  ExplorerStackToggledCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExplorerStackToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerStackToggled, $Out>
    implements ExplorerStackToggledCopyWith<$R, ExplorerStackToggled, $Out> {
  _ExplorerStackToggledCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerStackToggled> $mapper =
      ExplorerStackToggledMapper.ensureInitialized();
  @override
  $R call({String? taskId}) =>
      $apply(FieldCopyWithData({if (taskId != null) #taskId: taskId}));
  @override
  ExplorerStackToggled $make(CopyWithData data) =>
      ExplorerStackToggled(data.get(#taskId, or: $value.taskId));

  @override
  ExplorerStackToggledCopyWith<$R2, ExplorerStackToggled, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ExplorerStackToggledCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

