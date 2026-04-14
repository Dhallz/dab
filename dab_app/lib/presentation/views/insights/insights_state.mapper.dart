// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insights_state.dart';

class InsightsStateMapper extends ClassMapperBase<InsightsState> {
  InsightsStateMapper._();

  static InsightsStateMapper? _instance;
  static InsightsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InsightsStateMapper._());
      ViewStatusMapper.ensureInitialized();
      ActivityMapper.ensureInitialized();
      UserMapper.ensureInitialized();
      ActivityCategoryMapper.ensureInitialized();
      InsightsDatePresetMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsState';

  static ViewStatus _$status(InsightsState v) => v.status;
  static const Field<InsightsState, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static String? _$errorMessage(InsightsState v) => v.errorMessage;
  static const Field<InsightsState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );
  static List<Activity> _$activities(InsightsState v) => v.activities;
  static const Field<InsightsState, List<Activity>> _f$activities = Field(
    'activities',
    _$activities,
    opt: true,
    def: const [],
  );
  static List<User> _$users(InsightsState v) => v.users;
  static const Field<InsightsState, List<User>> _f$users = Field(
    'users',
    _$users,
    opt: true,
    def: const [],
  );
  static Set<String> _$selectedUserIds(InsightsState v) => v.selectedUserIds;
  static const Field<InsightsState, Set<String>> _f$selectedUserIds = Field(
    'selectedUserIds',
    _$selectedUserIds,
    opt: true,
    def: const {},
  );
  static List<String> _$availableProviders(InsightsState v) =>
      v.availableProviders;
  static const Field<InsightsState, List<String>> _f$availableProviders = Field(
    'availableProviders',
    _$availableProviders,
    opt: true,
    def: const [],
  );
  static Set<String> _$selectedProviders(InsightsState v) =>
      v.selectedProviders;
  static const Field<InsightsState, Set<String>> _f$selectedProviders = Field(
    'selectedProviders',
    _$selectedProviders,
    opt: true,
    def: const {},
  );
  static Set<ActivityCategory> _$availableActivityCategories(InsightsState v) =>
      v.availableActivityCategories;
  static const Field<InsightsState, Set<ActivityCategory>>
  _f$availableActivityCategories = Field(
    'availableActivityCategories',
    _$availableActivityCategories,
    opt: true,
    def: const {
      ActivityCategory.commit,
      ActivityCategory.revision,
      ActivityCategory.task,
      ActivityCategory.message,
      ActivityCategory.generic,
    },
  );
  static Set<ActivityCategory> _$selectedActivityCategories(InsightsState v) =>
      v.selectedActivityCategories;
  static const Field<InsightsState, Set<ActivityCategory>>
  _f$selectedActivityCategories = Field(
    'selectedActivityCategories',
    _$selectedActivityCategories,
    opt: true,
    def: const {
      ActivityCategory.commit,
      ActivityCategory.revision,
      ActivityCategory.task,
      ActivityCategory.message,
      ActivityCategory.generic,
    },
  );
  static InsightsDatePreset _$datePreset(InsightsState v) => v.datePreset;
  static const Field<InsightsState, InsightsDatePreset> _f$datePreset = Field(
    'datePreset',
    _$datePreset,
    opt: true,
    def: InsightsDatePreset.last7Days,
  );
  static DateTime _$startDate(InsightsState v) => v.startDate;
  static const Field<InsightsState, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
  );
  static DateTime _$endDate(InsightsState v) => v.endDate;
  static const Field<InsightsState, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
  );

  @override
  final MappableFields<InsightsState> fields = const {
    #status: _f$status,
    #errorMessage: _f$errorMessage,
    #activities: _f$activities,
    #users: _f$users,
    #selectedUserIds: _f$selectedUserIds,
    #availableProviders: _f$availableProviders,
    #selectedProviders: _f$selectedProviders,
    #availableActivityCategories: _f$availableActivityCategories,
    #selectedActivityCategories: _f$selectedActivityCategories,
    #datePreset: _f$datePreset,
    #startDate: _f$startDate,
    #endDate: _f$endDate,
  };

  static InsightsState _instantiate(DecodingData data) {
    return InsightsState(
      status: data.dec(_f$status),
      errorMessage: data.dec(_f$errorMessage),
      activities: data.dec(_f$activities),
      users: data.dec(_f$users),
      selectedUserIds: data.dec(_f$selectedUserIds),
      availableProviders: data.dec(_f$availableProviders),
      selectedProviders: data.dec(_f$selectedProviders),
      availableActivityCategories: data.dec(_f$availableActivityCategories),
      selectedActivityCategories: data.dec(_f$selectedActivityCategories),
      datePreset: data.dec(_f$datePreset),
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsState>(map);
  }

  static InsightsState fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsState>(json);
  }
}

mixin InsightsStateMappable {
  String toJson() {
    return InsightsStateMapper.ensureInitialized().encodeJson<InsightsState>(
      this as InsightsState,
    );
  }

  Map<String, dynamic> toMap() {
    return InsightsStateMapper.ensureInitialized().encodeMap<InsightsState>(
      this as InsightsState,
    );
  }

  InsightsStateCopyWith<InsightsState, InsightsState, InsightsState>
  get copyWith => _InsightsStateCopyWithImpl<InsightsState, InsightsState>(
    this as InsightsState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return InsightsStateMapper.ensureInitialized().stringifyValue(
      this as InsightsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsightsStateMapper.ensureInitialized().equalsValue(
      this as InsightsState,
      other,
    );
  }

  @override
  int get hashCode {
    return InsightsStateMapper.ensureInitialized().hashValue(
      this as InsightsState,
    );
  }
}

extension InsightsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsightsState, $Out> {
  InsightsStateCopyWith<$R, InsightsState, $Out> get $asInsightsState =>
      $base.as((v, t, t2) => _InsightsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class InsightsStateCopyWith<$R, $In extends InsightsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get activities;
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get users;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get availableProviders;
  $R call({
    ViewStatus? status,
    String? errorMessage,
    List<Activity>? activities,
    List<User>? users,
    Set<String>? selectedUserIds,
    List<String>? availableProviders,
    Set<String>? selectedProviders,
    Set<ActivityCategory>? availableActivityCategories,
    Set<ActivityCategory>? selectedActivityCategories,
    InsightsDatePreset? datePreset,
    DateTime? startDate,
    DateTime? endDate,
  });
  InsightsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _InsightsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsightsState, $Out>
    implements InsightsStateCopyWith<$R, InsightsState, $Out> {
  _InsightsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsightsState> $mapper =
      InsightsStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get activities => ListCopyWith(
    $value.activities,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(activities: v),
  );
  @override
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get users =>
      ListCopyWith(
        $value.users,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(users: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get availableProviders => ListCopyWith(
    $value.availableProviders,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(availableProviders: v),
  );
  @override
  $R call({
    ViewStatus? status,
    Object? errorMessage = $none,
    List<Activity>? activities,
    List<User>? users,
    Set<String>? selectedUserIds,
    List<String>? availableProviders,
    Set<String>? selectedProviders,
    Set<ActivityCategory>? availableActivityCategories,
    Set<ActivityCategory>? selectedActivityCategories,
    InsightsDatePreset? datePreset,
    DateTime? startDate,
    DateTime? endDate,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (errorMessage != $none) #errorMessage: errorMessage,
      if (activities != null) #activities: activities,
      if (users != null) #users: users,
      if (selectedUserIds != null) #selectedUserIds: selectedUserIds,
      if (availableProviders != null) #availableProviders: availableProviders,
      if (selectedProviders != null) #selectedProviders: selectedProviders,
      if (availableActivityCategories != null)
        #availableActivityCategories: availableActivityCategories,
      if (selectedActivityCategories != null)
        #selectedActivityCategories: selectedActivityCategories,
      if (datePreset != null) #datePreset: datePreset,
      if (startDate != null) #startDate: startDate,
      if (endDate != null) #endDate: endDate,
    }),
  );
  @override
  InsightsState $make(CopyWithData data) => InsightsState(
    status: data.get(#status, or: $value.status),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
    activities: data.get(#activities, or: $value.activities),
    users: data.get(#users, or: $value.users),
    selectedUserIds: data.get(#selectedUserIds, or: $value.selectedUserIds),
    availableProviders: data.get(
      #availableProviders,
      or: $value.availableProviders,
    ),
    selectedProviders: data.get(
      #selectedProviders,
      or: $value.selectedProviders,
    ),
    availableActivityCategories: data.get(
      #availableActivityCategories,
      or: $value.availableActivityCategories,
    ),
    selectedActivityCategories: data.get(
      #selectedActivityCategories,
      or: $value.selectedActivityCategories,
    ),
    datePreset: data.get(#datePreset, or: $value.datePreset),
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
  );

  @override
  InsightsStateCopyWith<$R2, InsightsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _InsightsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

