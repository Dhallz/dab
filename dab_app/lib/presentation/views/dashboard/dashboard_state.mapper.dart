// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'dashboard_state.dart';

class DashboardStateMapper extends ClassMapperBase<DashboardState> {
  DashboardStateMapper._();

  static DashboardStateMapper? _instance;
  static DashboardStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DashboardStateMapper._());
      ViewStatusMapper.ensureInitialized();
      ActivityMapper.ensureInitialized();
      DashboardFeedModeMapper.ensureInitialized();
      DashboardProviderHealthMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardState';

  static ViewStatus _$status(DashboardState v) => v.status;
  static const Field<DashboardState, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static List<Activity> _$activities(DashboardState v) => v.activities;
  static const Field<DashboardState, List<Activity>> _f$activities = Field(
    'activities',
    _$activities,
    opt: true,
    def: const [],
  );
  static bool _$showArchivedActivities(DashboardState v) =>
      v.showArchivedActivities;
  static const Field<DashboardState, bool> _f$showArchivedActivities = Field(
    'showArchivedActivities',
    _$showArchivedActivities,
    opt: true,
    def: false,
  );
  static DashboardFeedMode _$feedMode(DashboardState v) => v.feedMode;
  static const Field<DashboardState, DashboardFeedMode> _f$feedMode = Field(
    'feedMode',
    _$feedMode,
    opt: true,
    def: DashboardFeedMode.timeline,
  );
  static List<DashboardProviderHealth> _$providerHealth(DashboardState v) =>
      v.providerHealth;
  static const Field<DashboardState, List<DashboardProviderHealth>>
  _f$providerHealth = Field(
    'providerHealth',
    _$providerHealth,
    opt: true,
    def: const [],
  );
  static DateTime? _$lastSyncedAt(DashboardState v) => v.lastSyncedAt;
  static const Field<DashboardState, DateTime> _f$lastSyncedAt = Field(
    'lastSyncedAt',
    _$lastSyncedAt,
    opt: true,
  );
  static DateTime? _$reconnectNoticeAt(DashboardState v) => v.reconnectNoticeAt;
  static const Field<DashboardState, DateTime> _f$reconnectNoticeAt = Field(
    'reconnectNoticeAt',
    _$reconnectNoticeAt,
    opt: true,
  );
  static String? _$errorMessage(DashboardState v) => v.errorMessage;
  static const Field<DashboardState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );
  static List<Activity> _$visibleActivities(DashboardState v) =>
      v.visibleActivities;
  static const Field<DashboardState, List<Activity>> _f$visibleActivities =
      Field('visibleActivities', _$visibleActivities, mode: FieldMode.member);
  static int _$archivedCount(DashboardState v) => v.archivedCount;
  static const Field<DashboardState, int> _f$archivedCount = Field(
    'archivedCount',
    _$archivedCount,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<DashboardState> fields = const {
    #status: _f$status,
    #activities: _f$activities,
    #showArchivedActivities: _f$showArchivedActivities,
    #feedMode: _f$feedMode,
    #providerHealth: _f$providerHealth,
    #lastSyncedAt: _f$lastSyncedAt,
    #reconnectNoticeAt: _f$reconnectNoticeAt,
    #errorMessage: _f$errorMessage,
    #visibleActivities: _f$visibleActivities,
    #archivedCount: _f$archivedCount,
  };

  static DashboardState _instantiate(DecodingData data) {
    return DashboardState(
      status: data.dec(_f$status),
      activities: data.dec(_f$activities),
      showArchivedActivities: data.dec(_f$showArchivedActivities),
      feedMode: data.dec(_f$feedMode),
      providerHealth: data.dec(_f$providerHealth),
      lastSyncedAt: data.dec(_f$lastSyncedAt),
      reconnectNoticeAt: data.dec(_f$reconnectNoticeAt),
      errorMessage: data.dec(_f$errorMessage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardState>(map);
  }

  static DashboardState fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardState>(json);
  }
}

mixin DashboardStateMappable {
  String toJson() {
    return DashboardStateMapper.ensureInitialized().encodeJson<DashboardState>(
      this as DashboardState,
    );
  }

  Map<String, dynamic> toMap() {
    return DashboardStateMapper.ensureInitialized().encodeMap<DashboardState>(
      this as DashboardState,
    );
  }

  DashboardStateCopyWith<DashboardState, DashboardState, DashboardState>
  get copyWith => _DashboardStateCopyWithImpl<DashboardState, DashboardState>(
    this as DashboardState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return DashboardStateMapper.ensureInitialized().stringifyValue(
      this as DashboardState,
    );
  }

  @override
  bool operator ==(Object other) {
    return DashboardStateMapper.ensureInitialized().equalsValue(
      this as DashboardState,
      other,
    );
  }

  @override
  int get hashCode {
    return DashboardStateMapper.ensureInitialized().hashValue(
      this as DashboardState,
    );
  }
}

extension DashboardStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardState, $Out> {
  DashboardStateCopyWith<$R, DashboardState, $Out> get $asDashboardState =>
      $base.as((v, t, t2) => _DashboardStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DashboardStateCopyWith<$R, $In extends DashboardState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get activities;
  ListCopyWith<
    $R,
    DashboardProviderHealth,
    DashboardProviderHealthCopyWith<
      $R,
      DashboardProviderHealth,
      DashboardProviderHealth
    >
  >
  get providerHealth;
  $R call({
    ViewStatus? status,
    List<Activity>? activities,
    bool? showArchivedActivities,
    DashboardFeedMode? feedMode,
    List<DashboardProviderHealth>? providerHealth,
    DateTime? lastSyncedAt,
    DateTime? reconnectNoticeAt,
    String? errorMessage,
  });
  DashboardStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardState, $Out>
    implements DashboardStateCopyWith<$R, DashboardState, $Out> {
  _DashboardStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DashboardState> $mapper =
      DashboardStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get activities => ListCopyWith(
    $value.activities,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(activities: v),
  );
  @override
  ListCopyWith<
    $R,
    DashboardProviderHealth,
    DashboardProviderHealthCopyWith<
      $R,
      DashboardProviderHealth,
      DashboardProviderHealth
    >
  >
  get providerHealth => ListCopyWith(
    $value.providerHealth,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(providerHealth: v),
  );
  @override
  $R call({
    ViewStatus? status,
    List<Activity>? activities,
    bool? showArchivedActivities,
    DashboardFeedMode? feedMode,
    List<DashboardProviderHealth>? providerHealth,
    Object? lastSyncedAt = $none,
    Object? reconnectNoticeAt = $none,
    Object? errorMessage = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (activities != null) #activities: activities,
      if (showArchivedActivities != null)
        #showArchivedActivities: showArchivedActivities,
      if (feedMode != null) #feedMode: feedMode,
      if (providerHealth != null) #providerHealth: providerHealth,
      if (lastSyncedAt != $none) #lastSyncedAt: lastSyncedAt,
      if (reconnectNoticeAt != $none) #reconnectNoticeAt: reconnectNoticeAt,
      if (errorMessage != $none) #errorMessage: errorMessage,
    }),
  );
  @override
  DashboardState $make(CopyWithData data) => DashboardState(
    status: data.get(#status, or: $value.status),
    activities: data.get(#activities, or: $value.activities),
    showArchivedActivities: data.get(
      #showArchivedActivities,
      or: $value.showArchivedActivities,
    ),
    feedMode: data.get(#feedMode, or: $value.feedMode),
    providerHealth: data.get(#providerHealth, or: $value.providerHealth),
    lastSyncedAt: data.get(#lastSyncedAt, or: $value.lastSyncedAt),
    reconnectNoticeAt: data.get(
      #reconnectNoticeAt,
      or: $value.reconnectNoticeAt,
    ),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
  );

  @override
  DashboardStateCopyWith<$R2, DashboardState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DashboardStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

