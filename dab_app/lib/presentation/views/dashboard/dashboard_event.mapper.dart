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
      DashboardActivityArchivedRemotelyMapper.ensureInitialized();
      DashboardActivityUnarchivedRemotelyMapper.ensureInitialized();
      DashboardArchiveActivityRequestedMapper.ensureInitialized();
      DashboardUnarchiveActivityRequestedMapper.ensureInitialized();
      DashboardArchivedVisibilityToggledMapper.ensureInitialized();
      DashboardBannerTickMapper.ensureInitialized();
      DashboardBannerDismissedMapper.ensureInitialized();
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

class DashboardActivityArchivedRemotelyMapper
    extends ClassMapperBase<DashboardActivityArchivedRemotely> {
  DashboardActivityArchivedRemotelyMapper._();

  static DashboardActivityArchivedRemotelyMapper? _instance;
  static DashboardActivityArchivedRemotelyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardActivityArchivedRemotelyMapper._(),
      );
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardActivityArchivedRemotely';

  static String _$activityId(DashboardActivityArchivedRemotely v) =>
      v.activityId;
  static const Field<DashboardActivityArchivedRemotely, String> _f$activityId =
      Field('activityId', _$activityId);

  @override
  final MappableFields<DashboardActivityArchivedRemotely> fields = const {
    #activityId: _f$activityId,
  };

  static DashboardActivityArchivedRemotely _instantiate(DecodingData data) {
    return DashboardActivityArchivedRemotely(data.dec(_f$activityId));
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardActivityArchivedRemotely fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardActivityArchivedRemotely>(
      map,
    );
  }

  static DashboardActivityArchivedRemotely fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardActivityArchivedRemotely>(
      json,
    );
  }
}

mixin DashboardActivityArchivedRemotelyMappable {
  String toJson() {
    return DashboardActivityArchivedRemotelyMapper.ensureInitialized()
        .encodeJson<DashboardActivityArchivedRemotely>(
          this as DashboardActivityArchivedRemotely,
        );
  }

  Map<String, dynamic> toMap() {
    return DashboardActivityArchivedRemotelyMapper.ensureInitialized()
        .encodeMap<DashboardActivityArchivedRemotely>(
          this as DashboardActivityArchivedRemotely,
        );
  }

  DashboardActivityArchivedRemotelyCopyWith<
    DashboardActivityArchivedRemotely,
    DashboardActivityArchivedRemotely,
    DashboardActivityArchivedRemotely
  >
  get copyWith =>
      _DashboardActivityArchivedRemotelyCopyWithImpl<
        DashboardActivityArchivedRemotely,
        DashboardActivityArchivedRemotely
      >(this as DashboardActivityArchivedRemotely, $identity, $identity);
  @override
  String toString() {
    return DashboardActivityArchivedRemotelyMapper.ensureInitialized()
        .stringifyValue(this as DashboardActivityArchivedRemotely);
  }

  @override
  bool operator ==(Object other) {
    return DashboardActivityArchivedRemotelyMapper.ensureInitialized()
        .equalsValue(this as DashboardActivityArchivedRemotely, other);
  }

  @override
  int get hashCode {
    return DashboardActivityArchivedRemotelyMapper.ensureInitialized()
        .hashValue(this as DashboardActivityArchivedRemotely);
  }
}

extension DashboardActivityArchivedRemotelyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardActivityArchivedRemotely, $Out> {
  DashboardActivityArchivedRemotelyCopyWith<
    $R,
    DashboardActivityArchivedRemotely,
    $Out
  >
  get $asDashboardActivityArchivedRemotely => $base.as(
    (v, t, t2) =>
        _DashboardActivityArchivedRemotelyCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardActivityArchivedRemotelyCopyWith<
  $R,
  $In extends DashboardActivityArchivedRemotely,
  $Out
>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? activityId});
  DashboardActivityArchivedRemotelyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardActivityArchivedRemotelyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardActivityArchivedRemotely, $Out>
    implements
        DashboardActivityArchivedRemotelyCopyWith<
          $R,
          DashboardActivityArchivedRemotely,
          $Out
        > {
  _DashboardActivityArchivedRemotelyCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<DashboardActivityArchivedRemotely> $mapper =
      DashboardActivityArchivedRemotelyMapper.ensureInitialized();
  @override
  $R call({String? activityId}) => $apply(
    FieldCopyWithData({if (activityId != null) #activityId: activityId}),
  );
  @override
  DashboardActivityArchivedRemotely $make(CopyWithData data) =>
      DashboardActivityArchivedRemotely(
        data.get(#activityId, or: $value.activityId),
      );

  @override
  DashboardActivityArchivedRemotelyCopyWith<
    $R2,
    DashboardActivityArchivedRemotely,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardActivityArchivedRemotelyCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

class DashboardActivityUnarchivedRemotelyMapper
    extends ClassMapperBase<DashboardActivityUnarchivedRemotely> {
  DashboardActivityUnarchivedRemotelyMapper._();

  static DashboardActivityUnarchivedRemotelyMapper? _instance;
  static DashboardActivityUnarchivedRemotelyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardActivityUnarchivedRemotelyMapper._(),
      );
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardActivityUnarchivedRemotely';

  static String _$activityId(DashboardActivityUnarchivedRemotely v) =>
      v.activityId;
  static const Field<DashboardActivityUnarchivedRemotely, String>
  _f$activityId = Field('activityId', _$activityId);

  @override
  final MappableFields<DashboardActivityUnarchivedRemotely> fields = const {
    #activityId: _f$activityId,
  };

  static DashboardActivityUnarchivedRemotely _instantiate(DecodingData data) {
    return DashboardActivityUnarchivedRemotely(data.dec(_f$activityId));
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardActivityUnarchivedRemotely fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardActivityUnarchivedRemotely>(
      map,
    );
  }

  static DashboardActivityUnarchivedRemotely fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardActivityUnarchivedRemotely>(
      json,
    );
  }
}

mixin DashboardActivityUnarchivedRemotelyMappable {
  String toJson() {
    return DashboardActivityUnarchivedRemotelyMapper.ensureInitialized()
        .encodeJson<DashboardActivityUnarchivedRemotely>(
          this as DashboardActivityUnarchivedRemotely,
        );
  }

  Map<String, dynamic> toMap() {
    return DashboardActivityUnarchivedRemotelyMapper.ensureInitialized()
        .encodeMap<DashboardActivityUnarchivedRemotely>(
          this as DashboardActivityUnarchivedRemotely,
        );
  }

  DashboardActivityUnarchivedRemotelyCopyWith<
    DashboardActivityUnarchivedRemotely,
    DashboardActivityUnarchivedRemotely,
    DashboardActivityUnarchivedRemotely
  >
  get copyWith =>
      _DashboardActivityUnarchivedRemotelyCopyWithImpl<
        DashboardActivityUnarchivedRemotely,
        DashboardActivityUnarchivedRemotely
      >(this as DashboardActivityUnarchivedRemotely, $identity, $identity);
  @override
  String toString() {
    return DashboardActivityUnarchivedRemotelyMapper.ensureInitialized()
        .stringifyValue(this as DashboardActivityUnarchivedRemotely);
  }

  @override
  bool operator ==(Object other) {
    return DashboardActivityUnarchivedRemotelyMapper.ensureInitialized()
        .equalsValue(this as DashboardActivityUnarchivedRemotely, other);
  }

  @override
  int get hashCode {
    return DashboardActivityUnarchivedRemotelyMapper.ensureInitialized()
        .hashValue(this as DashboardActivityUnarchivedRemotely);
  }
}

extension DashboardActivityUnarchivedRemotelyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardActivityUnarchivedRemotely, $Out> {
  DashboardActivityUnarchivedRemotelyCopyWith<
    $R,
    DashboardActivityUnarchivedRemotely,
    $Out
  >
  get $asDashboardActivityUnarchivedRemotely => $base.as(
    (v, t, t2) =>
        _DashboardActivityUnarchivedRemotelyCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardActivityUnarchivedRemotelyCopyWith<
  $R,
  $In extends DashboardActivityUnarchivedRemotely,
  $Out
>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? activityId});
  DashboardActivityUnarchivedRemotelyCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DashboardActivityUnarchivedRemotelyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardActivityUnarchivedRemotely, $Out>
    implements
        DashboardActivityUnarchivedRemotelyCopyWith<
          $R,
          DashboardActivityUnarchivedRemotely,
          $Out
        > {
  _DashboardActivityUnarchivedRemotelyCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<DashboardActivityUnarchivedRemotely> $mapper =
      DashboardActivityUnarchivedRemotelyMapper.ensureInitialized();
  @override
  $R call({String? activityId}) => $apply(
    FieldCopyWithData({if (activityId != null) #activityId: activityId}),
  );
  @override
  DashboardActivityUnarchivedRemotely $make(CopyWithData data) =>
      DashboardActivityUnarchivedRemotely(
        data.get(#activityId, or: $value.activityId),
      );

  @override
  DashboardActivityUnarchivedRemotelyCopyWith<
    $R2,
    DashboardActivityUnarchivedRemotely,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardActivityUnarchivedRemotelyCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

class DashboardArchiveActivityRequestedMapper
    extends ClassMapperBase<DashboardArchiveActivityRequested> {
  DashboardArchiveActivityRequestedMapper._();

  static DashboardArchiveActivityRequestedMapper? _instance;
  static DashboardArchiveActivityRequestedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardArchiveActivityRequestedMapper._(),
      );
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardArchiveActivityRequested';

  static String _$activityId(DashboardArchiveActivityRequested v) =>
      v.activityId;
  static const Field<DashboardArchiveActivityRequested, String> _f$activityId =
      Field('activityId', _$activityId);

  @override
  final MappableFields<DashboardArchiveActivityRequested> fields = const {
    #activityId: _f$activityId,
  };

  static DashboardArchiveActivityRequested _instantiate(DecodingData data) {
    return DashboardArchiveActivityRequested(data.dec(_f$activityId));
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardArchiveActivityRequested fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardArchiveActivityRequested>(
      map,
    );
  }

  static DashboardArchiveActivityRequested fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardArchiveActivityRequested>(
      json,
    );
  }
}

mixin DashboardArchiveActivityRequestedMappable {
  String toJson() {
    return DashboardArchiveActivityRequestedMapper.ensureInitialized()
        .encodeJson<DashboardArchiveActivityRequested>(
          this as DashboardArchiveActivityRequested,
        );
  }

  Map<String, dynamic> toMap() {
    return DashboardArchiveActivityRequestedMapper.ensureInitialized()
        .encodeMap<DashboardArchiveActivityRequested>(
          this as DashboardArchiveActivityRequested,
        );
  }

  DashboardArchiveActivityRequestedCopyWith<
    DashboardArchiveActivityRequested,
    DashboardArchiveActivityRequested,
    DashboardArchiveActivityRequested
  >
  get copyWith =>
      _DashboardArchiveActivityRequestedCopyWithImpl<
        DashboardArchiveActivityRequested,
        DashboardArchiveActivityRequested
      >(this as DashboardArchiveActivityRequested, $identity, $identity);
  @override
  String toString() {
    return DashboardArchiveActivityRequestedMapper.ensureInitialized()
        .stringifyValue(this as DashboardArchiveActivityRequested);
  }

  @override
  bool operator ==(Object other) {
    return DashboardArchiveActivityRequestedMapper.ensureInitialized()
        .equalsValue(this as DashboardArchiveActivityRequested, other);
  }

  @override
  int get hashCode {
    return DashboardArchiveActivityRequestedMapper.ensureInitialized()
        .hashValue(this as DashboardArchiveActivityRequested);
  }
}

extension DashboardArchiveActivityRequestedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardArchiveActivityRequested, $Out> {
  DashboardArchiveActivityRequestedCopyWith<
    $R,
    DashboardArchiveActivityRequested,
    $Out
  >
  get $asDashboardArchiveActivityRequested => $base.as(
    (v, t, t2) =>
        _DashboardArchiveActivityRequestedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardArchiveActivityRequestedCopyWith<
  $R,
  $In extends DashboardArchiveActivityRequested,
  $Out
>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? activityId});
  DashboardArchiveActivityRequestedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardArchiveActivityRequestedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardArchiveActivityRequested, $Out>
    implements
        DashboardArchiveActivityRequestedCopyWith<
          $R,
          DashboardArchiveActivityRequested,
          $Out
        > {
  _DashboardArchiveActivityRequestedCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<DashboardArchiveActivityRequested> $mapper =
      DashboardArchiveActivityRequestedMapper.ensureInitialized();
  @override
  $R call({String? activityId}) => $apply(
    FieldCopyWithData({if (activityId != null) #activityId: activityId}),
  );
  @override
  DashboardArchiveActivityRequested $make(CopyWithData data) =>
      DashboardArchiveActivityRequested(
        data.get(#activityId, or: $value.activityId),
      );

  @override
  DashboardArchiveActivityRequestedCopyWith<
    $R2,
    DashboardArchiveActivityRequested,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardArchiveActivityRequestedCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

class DashboardUnarchiveActivityRequestedMapper
    extends ClassMapperBase<DashboardUnarchiveActivityRequested> {
  DashboardUnarchiveActivityRequestedMapper._();

  static DashboardUnarchiveActivityRequestedMapper? _instance;
  static DashboardUnarchiveActivityRequestedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardUnarchiveActivityRequestedMapper._(),
      );
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardUnarchiveActivityRequested';

  static String _$activityId(DashboardUnarchiveActivityRequested v) =>
      v.activityId;
  static const Field<DashboardUnarchiveActivityRequested, String>
  _f$activityId = Field('activityId', _$activityId);

  @override
  final MappableFields<DashboardUnarchiveActivityRequested> fields = const {
    #activityId: _f$activityId,
  };

  static DashboardUnarchiveActivityRequested _instantiate(DecodingData data) {
    return DashboardUnarchiveActivityRequested(data.dec(_f$activityId));
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardUnarchiveActivityRequested fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardUnarchiveActivityRequested>(
      map,
    );
  }

  static DashboardUnarchiveActivityRequested fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardUnarchiveActivityRequested>(
      json,
    );
  }
}

mixin DashboardUnarchiveActivityRequestedMappable {
  String toJson() {
    return DashboardUnarchiveActivityRequestedMapper.ensureInitialized()
        .encodeJson<DashboardUnarchiveActivityRequested>(
          this as DashboardUnarchiveActivityRequested,
        );
  }

  Map<String, dynamic> toMap() {
    return DashboardUnarchiveActivityRequestedMapper.ensureInitialized()
        .encodeMap<DashboardUnarchiveActivityRequested>(
          this as DashboardUnarchiveActivityRequested,
        );
  }

  DashboardUnarchiveActivityRequestedCopyWith<
    DashboardUnarchiveActivityRequested,
    DashboardUnarchiveActivityRequested,
    DashboardUnarchiveActivityRequested
  >
  get copyWith =>
      _DashboardUnarchiveActivityRequestedCopyWithImpl<
        DashboardUnarchiveActivityRequested,
        DashboardUnarchiveActivityRequested
      >(this as DashboardUnarchiveActivityRequested, $identity, $identity);
  @override
  String toString() {
    return DashboardUnarchiveActivityRequestedMapper.ensureInitialized()
        .stringifyValue(this as DashboardUnarchiveActivityRequested);
  }

  @override
  bool operator ==(Object other) {
    return DashboardUnarchiveActivityRequestedMapper.ensureInitialized()
        .equalsValue(this as DashboardUnarchiveActivityRequested, other);
  }

  @override
  int get hashCode {
    return DashboardUnarchiveActivityRequestedMapper.ensureInitialized()
        .hashValue(this as DashboardUnarchiveActivityRequested);
  }
}

extension DashboardUnarchiveActivityRequestedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardUnarchiveActivityRequested, $Out> {
  DashboardUnarchiveActivityRequestedCopyWith<
    $R,
    DashboardUnarchiveActivityRequested,
    $Out
  >
  get $asDashboardUnarchiveActivityRequested => $base.as(
    (v, t, t2) =>
        _DashboardUnarchiveActivityRequestedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardUnarchiveActivityRequestedCopyWith<
  $R,
  $In extends DashboardUnarchiveActivityRequested,
  $Out
>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? activityId});
  DashboardUnarchiveActivityRequestedCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DashboardUnarchiveActivityRequestedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardUnarchiveActivityRequested, $Out>
    implements
        DashboardUnarchiveActivityRequestedCopyWith<
          $R,
          DashboardUnarchiveActivityRequested,
          $Out
        > {
  _DashboardUnarchiveActivityRequestedCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<DashboardUnarchiveActivityRequested> $mapper =
      DashboardUnarchiveActivityRequestedMapper.ensureInitialized();
  @override
  $R call({String? activityId}) => $apply(
    FieldCopyWithData({if (activityId != null) #activityId: activityId}),
  );
  @override
  DashboardUnarchiveActivityRequested $make(CopyWithData data) =>
      DashboardUnarchiveActivityRequested(
        data.get(#activityId, or: $value.activityId),
      );

  @override
  DashboardUnarchiveActivityRequestedCopyWith<
    $R2,
    DashboardUnarchiveActivityRequested,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardUnarchiveActivityRequestedCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

class DashboardArchivedVisibilityToggledMapper
    extends ClassMapperBase<DashboardArchivedVisibilityToggled> {
  DashboardArchivedVisibilityToggledMapper._();

  static DashboardArchivedVisibilityToggledMapper? _instance;
  static DashboardArchivedVisibilityToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardArchivedVisibilityToggledMapper._(),
      );
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardArchivedVisibilityToggled';

  @override
  final MappableFields<DashboardArchivedVisibilityToggled> fields = const {};

  static DashboardArchivedVisibilityToggled _instantiate(DecodingData data) {
    return DashboardArchivedVisibilityToggled();
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardArchivedVisibilityToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardArchivedVisibilityToggled>(
      map,
    );
  }

  static DashboardArchivedVisibilityToggled fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardArchivedVisibilityToggled>(
      json,
    );
  }
}

mixin DashboardArchivedVisibilityToggledMappable {
  String toJson() {
    return DashboardArchivedVisibilityToggledMapper.ensureInitialized()
        .encodeJson<DashboardArchivedVisibilityToggled>(
          this as DashboardArchivedVisibilityToggled,
        );
  }

  Map<String, dynamic> toMap() {
    return DashboardArchivedVisibilityToggledMapper.ensureInitialized()
        .encodeMap<DashboardArchivedVisibilityToggled>(
          this as DashboardArchivedVisibilityToggled,
        );
  }

  DashboardArchivedVisibilityToggledCopyWith<
    DashboardArchivedVisibilityToggled,
    DashboardArchivedVisibilityToggled,
    DashboardArchivedVisibilityToggled
  >
  get copyWith =>
      _DashboardArchivedVisibilityToggledCopyWithImpl<
        DashboardArchivedVisibilityToggled,
        DashboardArchivedVisibilityToggled
      >(this as DashboardArchivedVisibilityToggled, $identity, $identity);
  @override
  String toString() {
    return DashboardArchivedVisibilityToggledMapper.ensureInitialized()
        .stringifyValue(this as DashboardArchivedVisibilityToggled);
  }

  @override
  bool operator ==(Object other) {
    return DashboardArchivedVisibilityToggledMapper.ensureInitialized()
        .equalsValue(this as DashboardArchivedVisibilityToggled, other);
  }

  @override
  int get hashCode {
    return DashboardArchivedVisibilityToggledMapper.ensureInitialized()
        .hashValue(this as DashboardArchivedVisibilityToggled);
  }
}

extension DashboardArchivedVisibilityToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardArchivedVisibilityToggled, $Out> {
  DashboardArchivedVisibilityToggledCopyWith<
    $R,
    DashboardArchivedVisibilityToggled,
    $Out
  >
  get $asDashboardArchivedVisibilityToggled => $base.as(
    (v, t, t2) =>
        _DashboardArchivedVisibilityToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardArchivedVisibilityToggledCopyWith<
  $R,
  $In extends DashboardArchivedVisibilityToggled,
  $Out
>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DashboardArchivedVisibilityToggledCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DashboardArchivedVisibilityToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardArchivedVisibilityToggled, $Out>
    implements
        DashboardArchivedVisibilityToggledCopyWith<
          $R,
          DashboardArchivedVisibilityToggled,
          $Out
        > {
  _DashboardArchivedVisibilityToggledCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<DashboardArchivedVisibilityToggled> $mapper =
      DashboardArchivedVisibilityToggledMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DashboardArchivedVisibilityToggled $make(CopyWithData data) =>
      DashboardArchivedVisibilityToggled();

  @override
  DashboardArchivedVisibilityToggledCopyWith<
    $R2,
    DashboardArchivedVisibilityToggled,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardArchivedVisibilityToggledCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

class DashboardBannerTickMapper extends ClassMapperBase<DashboardBannerTick> {
  DashboardBannerTickMapper._();

  static DashboardBannerTickMapper? _instance;
  static DashboardBannerTickMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DashboardBannerTickMapper._());
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardBannerTick';

  @override
  final MappableFields<DashboardBannerTick> fields = const {};

  static DashboardBannerTick _instantiate(DecodingData data) {
    return DashboardBannerTick();
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardBannerTick fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardBannerTick>(map);
  }

  static DashboardBannerTick fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardBannerTick>(json);
  }
}

mixin DashboardBannerTickMappable {
  String toJson() {
    return DashboardBannerTickMapper.ensureInitialized()
        .encodeJson<DashboardBannerTick>(this as DashboardBannerTick);
  }

  Map<String, dynamic> toMap() {
    return DashboardBannerTickMapper.ensureInitialized()
        .encodeMap<DashboardBannerTick>(this as DashboardBannerTick);
  }

  DashboardBannerTickCopyWith<
    DashboardBannerTick,
    DashboardBannerTick,
    DashboardBannerTick
  >
  get copyWith =>
      _DashboardBannerTickCopyWithImpl<
        DashboardBannerTick,
        DashboardBannerTick
      >(this as DashboardBannerTick, $identity, $identity);
  @override
  String toString() {
    return DashboardBannerTickMapper.ensureInitialized().stringifyValue(
      this as DashboardBannerTick,
    );
  }

  @override
  bool operator ==(Object other) {
    return DashboardBannerTickMapper.ensureInitialized().equalsValue(
      this as DashboardBannerTick,
      other,
    );
  }

  @override
  int get hashCode {
    return DashboardBannerTickMapper.ensureInitialized().hashValue(
      this as DashboardBannerTick,
    );
  }
}

extension DashboardBannerTickValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardBannerTick, $Out> {
  DashboardBannerTickCopyWith<$R, DashboardBannerTick, $Out>
  get $asDashboardBannerTick => $base.as(
    (v, t, t2) => _DashboardBannerTickCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardBannerTickCopyWith<
  $R,
  $In extends DashboardBannerTick,
  $Out
>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DashboardBannerTickCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardBannerTickCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardBannerTick, $Out>
    implements DashboardBannerTickCopyWith<$R, DashboardBannerTick, $Out> {
  _DashboardBannerTickCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DashboardBannerTick> $mapper =
      DashboardBannerTickMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DashboardBannerTick $make(CopyWithData data) => DashboardBannerTick();

  @override
  DashboardBannerTickCopyWith<$R2, DashboardBannerTick, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardBannerTickCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DashboardBannerDismissedMapper
    extends ClassMapperBase<DashboardBannerDismissed> {
  DashboardBannerDismissedMapper._();

  static DashboardBannerDismissedMapper? _instance;
  static DashboardBannerDismissedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardBannerDismissedMapper._(),
      );
      DashboardEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardBannerDismissed';

  @override
  final MappableFields<DashboardBannerDismissed> fields = const {};

  static DashboardBannerDismissed _instantiate(DecodingData data) {
    return DashboardBannerDismissed();
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardBannerDismissed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardBannerDismissed>(map);
  }

  static DashboardBannerDismissed fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardBannerDismissed>(json);
  }
}

mixin DashboardBannerDismissedMappable {
  String toJson() {
    return DashboardBannerDismissedMapper.ensureInitialized()
        .encodeJson<DashboardBannerDismissed>(this as DashboardBannerDismissed);
  }

  Map<String, dynamic> toMap() {
    return DashboardBannerDismissedMapper.ensureInitialized()
        .encodeMap<DashboardBannerDismissed>(this as DashboardBannerDismissed);
  }

  DashboardBannerDismissedCopyWith<
    DashboardBannerDismissed,
    DashboardBannerDismissed,
    DashboardBannerDismissed
  >
  get copyWith =>
      _DashboardBannerDismissedCopyWithImpl<
        DashboardBannerDismissed,
        DashboardBannerDismissed
      >(this as DashboardBannerDismissed, $identity, $identity);
  @override
  String toString() {
    return DashboardBannerDismissedMapper.ensureInitialized().stringifyValue(
      this as DashboardBannerDismissed,
    );
  }

  @override
  bool operator ==(Object other) {
    return DashboardBannerDismissedMapper.ensureInitialized().equalsValue(
      this as DashboardBannerDismissed,
      other,
    );
  }

  @override
  int get hashCode {
    return DashboardBannerDismissedMapper.ensureInitialized().hashValue(
      this as DashboardBannerDismissed,
    );
  }
}

extension DashboardBannerDismissedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardBannerDismissed, $Out> {
  DashboardBannerDismissedCopyWith<$R, DashboardBannerDismissed, $Out>
  get $asDashboardBannerDismissed => $base.as(
    (v, t, t2) => _DashboardBannerDismissedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardBannerDismissedCopyWith<
  $R,
  $In extends DashboardBannerDismissed,
  $Out
>
    implements DashboardEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DashboardBannerDismissedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardBannerDismissedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardBannerDismissed, $Out>
    implements
        DashboardBannerDismissedCopyWith<$R, DashboardBannerDismissed, $Out> {
  _DashboardBannerDismissedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DashboardBannerDismissed> $mapper =
      DashboardBannerDismissedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DashboardBannerDismissed $make(CopyWithData data) =>
      DashboardBannerDismissed();

  @override
  DashboardBannerDismissedCopyWith<$R2, DashboardBannerDismissed, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardBannerDismissedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

