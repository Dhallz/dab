// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'explorer_item.dart';

class ExplorerItemMapper extends ClassMapperBase<ExplorerItem> {
  ExplorerItemMapper._();

  static ExplorerItemMapper? _instance;
  static ExplorerItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerItemMapper._());
      SingleActivityItemMapper.ensureInitialized();
      TaskActivityItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerItem';

  @override
  final MappableFields<ExplorerItem> fields = const {};

  static ExplorerItem _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('ExplorerItem');
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerItem>(map);
  }

  static ExplorerItem fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerItem>(json);
  }
}

mixin ExplorerItemMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ExplorerItemCopyWith<ExplorerItem, ExplorerItem, ExplorerItem> get copyWith;
}

abstract class ExplorerItemCopyWith<$R, $In extends ExplorerItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ExplorerItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class SingleActivityItemMapper extends ClassMapperBase<SingleActivityItem> {
  SingleActivityItemMapper._();

  static SingleActivityItemMapper? _instance;
  static SingleActivityItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SingleActivityItemMapper._());
      ExplorerItemMapper.ensureInitialized();
      ActivityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SingleActivityItem';

  static Activity _$activity(SingleActivityItem v) => v.activity;
  static const Field<SingleActivityItem, Activity> _f$activity = Field(
    'activity',
    _$activity,
  );

  @override
  final MappableFields<SingleActivityItem> fields = const {
    #activity: _f$activity,
  };

  static SingleActivityItem _instantiate(DecodingData data) {
    return SingleActivityItem(data.dec(_f$activity));
  }

  @override
  final Function instantiate = _instantiate;

  static SingleActivityItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SingleActivityItem>(map);
  }

  static SingleActivityItem fromJson(String json) {
    return ensureInitialized().decodeJson<SingleActivityItem>(json);
  }
}

mixin SingleActivityItemMappable {
  String toJson() {
    return SingleActivityItemMapper.ensureInitialized()
        .encodeJson<SingleActivityItem>(this as SingleActivityItem);
  }

  Map<String, dynamic> toMap() {
    return SingleActivityItemMapper.ensureInitialized()
        .encodeMap<SingleActivityItem>(this as SingleActivityItem);
  }

  SingleActivityItemCopyWith<
    SingleActivityItem,
    SingleActivityItem,
    SingleActivityItem
  >
  get copyWith =>
      _SingleActivityItemCopyWithImpl<SingleActivityItem, SingleActivityItem>(
        this as SingleActivityItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SingleActivityItemMapper.ensureInitialized().stringifyValue(
      this as SingleActivityItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return SingleActivityItemMapper.ensureInitialized().equalsValue(
      this as SingleActivityItem,
      other,
    );
  }

  @override
  int get hashCode {
    return SingleActivityItemMapper.ensureInitialized().hashValue(
      this as SingleActivityItem,
    );
  }
}

extension SingleActivityItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SingleActivityItem, $Out> {
  SingleActivityItemCopyWith<$R, SingleActivityItem, $Out>
  get $asSingleActivityItem => $base.as(
    (v, t, t2) => _SingleActivityItemCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SingleActivityItemCopyWith<
  $R,
  $In extends SingleActivityItem,
  $Out
>
    implements ExplorerItemCopyWith<$R, $In, $Out> {
  ActivityCopyWith<$R, Activity, Activity> get activity;
  @override
  $R call({Activity? activity});
  SingleActivityItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SingleActivityItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SingleActivityItem, $Out>
    implements SingleActivityItemCopyWith<$R, SingleActivityItem, $Out> {
  _SingleActivityItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SingleActivityItem> $mapper =
      SingleActivityItemMapper.ensureInitialized();
  @override
  ActivityCopyWith<$R, Activity, Activity> get activity =>
      $value.activity.copyWith.$chain((v) => call(activity: v));
  @override
  $R call({Activity? activity}) =>
      $apply(FieldCopyWithData({if (activity != null) #activity: activity}));
  @override
  SingleActivityItem $make(CopyWithData data) =>
      SingleActivityItem(data.get(#activity, or: $value.activity));

  @override
  SingleActivityItemCopyWith<$R2, SingleActivityItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SingleActivityItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TaskActivityItemMapper extends ClassMapperBase<TaskActivityItem> {
  TaskActivityItemMapper._();

  static TaskActivityItemMapper? _instance;
  static TaskActivityItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskActivityItemMapper._());
      ExplorerItemMapper.ensureInitialized();
      ActivityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TaskActivityItem';

  static List<Activity> _$activities(TaskActivityItem v) => v.activities;
  static const Field<TaskActivityItem, List<Activity>> _f$activities = Field(
    'activities',
    _$activities,
  );
  static String _$taskId(TaskActivityItem v) => v.taskId;
  static const Field<TaskActivityItem, String> _f$taskId = Field(
    'taskId',
    _$taskId,
  );
  static String _$userId(TaskActivityItem v) => v.userId;
  static const Field<TaskActivityItem, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static bool _$isExpanded(TaskActivityItem v) => v.isExpanded;
  static const Field<TaskActivityItem, bool> _f$isExpanded = Field(
    'isExpanded',
    _$isExpanded,
    opt: true,
    def: false,
  );
  static Activity _$latestActivity(TaskActivityItem v) => v.latestActivity;
  static const Field<TaskActivityItem, Activity> _f$latestActivity = Field(
    'latestActivity',
    _$latestActivity,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<TaskActivityItem> fields = const {
    #activities: _f$activities,
    #taskId: _f$taskId,
    #userId: _f$userId,
    #isExpanded: _f$isExpanded,
    #latestActivity: _f$latestActivity,
  };

  static TaskActivityItem _instantiate(DecodingData data) {
    return TaskActivityItem(
      activities: data.dec(_f$activities),
      taskId: data.dec(_f$taskId),
      userId: data.dec(_f$userId),
      isExpanded: data.dec(_f$isExpanded),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TaskActivityItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TaskActivityItem>(map);
  }

  static TaskActivityItem fromJson(String json) {
    return ensureInitialized().decodeJson<TaskActivityItem>(json);
  }
}

mixin TaskActivityItemMappable {
  String toJson() {
    return TaskActivityItemMapper.ensureInitialized()
        .encodeJson<TaskActivityItem>(this as TaskActivityItem);
  }

  Map<String, dynamic> toMap() {
    return TaskActivityItemMapper.ensureInitialized()
        .encodeMap<TaskActivityItem>(this as TaskActivityItem);
  }

  TaskActivityItemCopyWith<TaskActivityItem, TaskActivityItem, TaskActivityItem>
  get copyWith =>
      _TaskActivityItemCopyWithImpl<TaskActivityItem, TaskActivityItem>(
        this as TaskActivityItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TaskActivityItemMapper.ensureInitialized().stringifyValue(
      this as TaskActivityItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return TaskActivityItemMapper.ensureInitialized().equalsValue(
      this as TaskActivityItem,
      other,
    );
  }

  @override
  int get hashCode {
    return TaskActivityItemMapper.ensureInitialized().hashValue(
      this as TaskActivityItem,
    );
  }
}

extension TaskActivityItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TaskActivityItem, $Out> {
  TaskActivityItemCopyWith<$R, TaskActivityItem, $Out>
  get $asTaskActivityItem =>
      $base.as((v, t, t2) => _TaskActivityItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TaskActivityItemCopyWith<$R, $In extends TaskActivityItem, $Out>
    implements ExplorerItemCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get activities;
  @override
  $R call({
    List<Activity>? activities,
    String? taskId,
    String? userId,
    bool? isExpanded,
  });
  TaskActivityItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TaskActivityItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TaskActivityItem, $Out>
    implements TaskActivityItemCopyWith<$R, TaskActivityItem, $Out> {
  _TaskActivityItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TaskActivityItem> $mapper =
      TaskActivityItemMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get activities => ListCopyWith(
    $value.activities,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(activities: v),
  );
  @override
  $R call({
    List<Activity>? activities,
    String? taskId,
    String? userId,
    bool? isExpanded,
  }) => $apply(
    FieldCopyWithData({
      if (activities != null) #activities: activities,
      if (taskId != null) #taskId: taskId,
      if (userId != null) #userId: userId,
      if (isExpanded != null) #isExpanded: isExpanded,
    }),
  );
  @override
  TaskActivityItem $make(CopyWithData data) => TaskActivityItem(
    activities: data.get(#activities, or: $value.activities),
    taskId: data.get(#taskId, or: $value.taskId),
    userId: data.get(#userId, or: $value.userId),
    isExpanded: data.get(#isExpanded, or: $value.isExpanded),
  );

  @override
  TaskActivityItemCopyWith<$R2, TaskActivityItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TaskActivityItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

