// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'explorer_state.dart';

class ExplorerStateMapper extends ClassMapperBase<ExplorerState> {
  ExplorerStateMapper._();

  static ExplorerStateMapper? _instance;
  static ExplorerStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerStateMapper._());
      ActivityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerState';

  static ExplorerStatus _$status(ExplorerState v) => v.status;
  static const Field<ExplorerState, ExplorerStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ExplorerStatus.initial,
  );
  static List<Activity> _$activities(ExplorerState v) => v.activities;
  static const Field<ExplorerState, List<Activity>> _f$activities = Field(
    'activities',
    _$activities,
    opt: true,
    def: const [],
  );
  static String? _$errorMessage(ExplorerState v) => v.errorMessage;
  static const Field<ExplorerState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );
  static DateTime _$selectedDate(ExplorerState v) => v.selectedDate;
  static const Field<ExplorerState, DateTime> _f$selectedDate = Field(
    'selectedDate',
    _$selectedDate,
  );

  @override
  final MappableFields<ExplorerState> fields = const {
    #status: _f$status,
    #activities: _f$activities,
    #errorMessage: _f$errorMessage,
    #selectedDate: _f$selectedDate,
  };

  static ExplorerState _instantiate(DecodingData data) {
    return ExplorerState(
      status: data.dec(_f$status),
      activities: data.dec(_f$activities),
      errorMessage: data.dec(_f$errorMessage),
      selectedDate: data.dec(_f$selectedDate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerState>(map);
  }

  static ExplorerState fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerState>(json);
  }
}

mixin ExplorerStateMappable {
  String toJson() {
    return ExplorerStateMapper.ensureInitialized().encodeJson<ExplorerState>(
      this as ExplorerState,
    );
  }

  Map<String, dynamic> toMap() {
    return ExplorerStateMapper.ensureInitialized().encodeMap<ExplorerState>(
      this as ExplorerState,
    );
  }

  ExplorerStateCopyWith<ExplorerState, ExplorerState, ExplorerState>
  get copyWith => _ExplorerStateCopyWithImpl<ExplorerState, ExplorerState>(
    this as ExplorerState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ExplorerStateMapper.ensureInitialized().stringifyValue(
      this as ExplorerState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerStateMapper.ensureInitialized().equalsValue(
      this as ExplorerState,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerStateMapper.ensureInitialized().hashValue(
      this as ExplorerState,
    );
  }
}

extension ExplorerStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerState, $Out> {
  ExplorerStateCopyWith<$R, ExplorerState, $Out> get $asExplorerState =>
      $base.as((v, t, t2) => _ExplorerStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExplorerStateCopyWith<$R, $In extends ExplorerState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get activities;
  $R call({
    ExplorerStatus? status,
    List<Activity>? activities,
    String? errorMessage,
    DateTime? selectedDate,
  });
  ExplorerStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExplorerStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerState, $Out>
    implements ExplorerStateCopyWith<$R, ExplorerState, $Out> {
  _ExplorerStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerState> $mapper =
      ExplorerStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get activities => ListCopyWith(
    $value.activities,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(activities: v),
  );
  @override
  $R call({
    ExplorerStatus? status,
    List<Activity>? activities,
    Object? errorMessage = $none,
    DateTime? selectedDate,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (activities != null) #activities: activities,
      if (errorMessage != $none) #errorMessage: errorMessage,
      if (selectedDate != null) #selectedDate: selectedDate,
    }),
  );
  @override
  ExplorerState $make(CopyWithData data) => ExplorerState(
    status: data.get(#status, or: $value.status),
    activities: data.get(#activities, or: $value.activities),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
    selectedDate: data.get(#selectedDate, or: $value.selectedDate),
  );

  @override
  ExplorerStateCopyWith<$R2, ExplorerState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExplorerStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

