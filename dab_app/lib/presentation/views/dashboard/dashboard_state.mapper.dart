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
      UpcomingEventMapper.ensureInitialized();
      DashboardBannerMapper.ensureInitialized();
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
  static List<UpcomingEvent> _$upcomingEvents(DashboardState v) =>
      v.upcomingEvents;
  static const Field<DashboardState, List<UpcomingEvent>> _f$upcomingEvents =
      Field('upcomingEvents', _$upcomingEvents, opt: true, def: const []);
  static DashboardBanner? _$activeBanner(DashboardState v) => v.activeBanner;
  static const Field<DashboardState, DashboardBanner> _f$activeBanner = Field(
    'activeBanner',
    _$activeBanner,
    opt: true,
  );
  static List<String> _$lastNotifiedEventIds(DashboardState v) =>
      v.lastNotifiedEventIds;
  static const Field<DashboardState, List<String>> _f$lastNotifiedEventIds =
      Field(
        'lastNotifiedEventIds',
        _$lastNotifiedEventIds,
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
    #upcomingEvents: _f$upcomingEvents,
    #activeBanner: _f$activeBanner,
    #lastNotifiedEventIds: _f$lastNotifiedEventIds,
    #showArchivedActivities: _f$showArchivedActivities,
    #errorMessage: _f$errorMessage,
    #visibleActivities: _f$visibleActivities,
    #archivedCount: _f$archivedCount,
  };

  static DashboardState _instantiate(DecodingData data) {
    return DashboardState(
      status: data.dec(_f$status),
      activities: data.dec(_f$activities),
      upcomingEvents: data.dec(_f$upcomingEvents),
      activeBanner: data.dec(_f$activeBanner),
      lastNotifiedEventIds: data.dec(_f$lastNotifiedEventIds),
      showArchivedActivities: data.dec(_f$showArchivedActivities),
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
    UpcomingEvent,
    UpcomingEventCopyWith<$R, UpcomingEvent, UpcomingEvent>
  >
  get upcomingEvents;
  DashboardBannerCopyWith<$R, DashboardBanner, DashboardBanner>?
  get activeBanner;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get lastNotifiedEventIds;
  $R call({
    ViewStatus? status,
    List<Activity>? activities,
    List<UpcomingEvent>? upcomingEvents,
    DashboardBanner? activeBanner,
    List<String>? lastNotifiedEventIds,
    bool? showArchivedActivities,
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
    UpcomingEvent,
    UpcomingEventCopyWith<$R, UpcomingEvent, UpcomingEvent>
  >
  get upcomingEvents => ListCopyWith(
    $value.upcomingEvents,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(upcomingEvents: v),
  );
  @override
  DashboardBannerCopyWith<$R, DashboardBanner, DashboardBanner>?
  get activeBanner =>
      $value.activeBanner?.copyWith.$chain((v) => call(activeBanner: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get lastNotifiedEventIds => ListCopyWith(
    $value.lastNotifiedEventIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(lastNotifiedEventIds: v),
  );
  @override
  $R call({
    ViewStatus? status,
    List<Activity>? activities,
    List<UpcomingEvent>? upcomingEvents,
    Object? activeBanner = $none,
    List<String>? lastNotifiedEventIds,
    bool? showArchivedActivities,
    Object? errorMessage = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (activities != null) #activities: activities,
      if (upcomingEvents != null) #upcomingEvents: upcomingEvents,
      if (activeBanner != $none) #activeBanner: activeBanner,
      if (lastNotifiedEventIds != null)
        #lastNotifiedEventIds: lastNotifiedEventIds,
      if (showArchivedActivities != null)
        #showArchivedActivities: showArchivedActivities,
      if (errorMessage != $none) #errorMessage: errorMessage,
    }),
  );
  @override
  DashboardState $make(CopyWithData data) => DashboardState(
    status: data.get(#status, or: $value.status),
    activities: data.get(#activities, or: $value.activities),
    upcomingEvents: data.get(#upcomingEvents, or: $value.upcomingEvents),
    activeBanner: data.get(#activeBanner, or: $value.activeBanner),
    lastNotifiedEventIds: data.get(
      #lastNotifiedEventIds,
      or: $value.lastNotifiedEventIds,
    ),
    showArchivedActivities: data.get(
      #showArchivedActivities,
      or: $value.showArchivedActivities,
    ),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
  );

  @override
  DashboardStateCopyWith<$R2, DashboardState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DashboardStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

