// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insights_event.dart';

class InsightsEventMapper extends ClassMapperBase<InsightsEvent> {
  InsightsEventMapper._();

  static InsightsEventMapper? _instance;
  static InsightsEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InsightsEventMapper._());
      InsightsStartedMapper.ensureInitialized();
      InsightsDatePresetChangedMapper.ensureInitialized();
      InsightsDateRangeChangedMapper.ensureInitialized();
      InsightsProviderToggledMapper.ensureInitialized();
      InsightsActivityCategoryToggledMapper.ensureInitialized();
      InsightsUserToggledMapper.ensureInitialized();
      InsightsRefreshRequestedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsEvent';

  @override
  final MappableFields<InsightsEvent> fields = const {};

  static InsightsEvent _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('InsightsEvent');
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsEvent>(map);
  }

  static InsightsEvent fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsEvent>(json);
  }
}

mixin InsightsEventMappable {
  String toJson();
  Map<String, dynamic> toMap();
  InsightsEventCopyWith<InsightsEvent, InsightsEvent, InsightsEvent>
  get copyWith;
}

abstract class InsightsEventCopyWith<$R, $In extends InsightsEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  InsightsEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class InsightsStartedMapper extends ClassMapperBase<InsightsStarted> {
  InsightsStartedMapper._();

  static InsightsStartedMapper? _instance;
  static InsightsStartedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InsightsStartedMapper._());
      InsightsEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsStarted';

  static String? _$connectedUserId(InsightsStarted v) => v.connectedUserId;
  static const Field<InsightsStarted, String> _f$connectedUserId = Field(
    'connectedUserId',
    _$connectedUserId,
    opt: true,
  );

  @override
  final MappableFields<InsightsStarted> fields = const {
    #connectedUserId: _f$connectedUserId,
  };

  static InsightsStarted _instantiate(DecodingData data) {
    return InsightsStarted(connectedUserId: data.dec(_f$connectedUserId));
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsStarted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsStarted>(map);
  }

  static InsightsStarted fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsStarted>(json);
  }
}

mixin InsightsStartedMappable {
  String toJson() {
    return InsightsStartedMapper.ensureInitialized()
        .encodeJson<InsightsStarted>(this as InsightsStarted);
  }

  Map<String, dynamic> toMap() {
    return InsightsStartedMapper.ensureInitialized().encodeMap<InsightsStarted>(
      this as InsightsStarted,
    );
  }

  InsightsStartedCopyWith<InsightsStarted, InsightsStarted, InsightsStarted>
  get copyWith =>
      _InsightsStartedCopyWithImpl<InsightsStarted, InsightsStarted>(
        this as InsightsStarted,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return InsightsStartedMapper.ensureInitialized().stringifyValue(
      this as InsightsStarted,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsightsStartedMapper.ensureInitialized().equalsValue(
      this as InsightsStarted,
      other,
    );
  }

  @override
  int get hashCode {
    return InsightsStartedMapper.ensureInitialized().hashValue(
      this as InsightsStarted,
    );
  }
}

extension InsightsStartedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsightsStarted, $Out> {
  InsightsStartedCopyWith<$R, InsightsStarted, $Out> get $asInsightsStarted =>
      $base.as((v, t, t2) => _InsightsStartedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class InsightsStartedCopyWith<$R, $In extends InsightsStarted, $Out>
    implements InsightsEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? connectedUserId});
  InsightsStartedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsightsStartedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsightsStarted, $Out>
    implements InsightsStartedCopyWith<$R, InsightsStarted, $Out> {
  _InsightsStartedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsightsStarted> $mapper =
      InsightsStartedMapper.ensureInitialized();
  @override
  $R call({Object? connectedUserId = $none}) => $apply(
    FieldCopyWithData({
      if (connectedUserId != $none) #connectedUserId: connectedUserId,
    }),
  );
  @override
  InsightsStarted $make(CopyWithData data) => InsightsStarted(
    connectedUserId: data.get(#connectedUserId, or: $value.connectedUserId),
  );

  @override
  InsightsStartedCopyWith<$R2, InsightsStarted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _InsightsStartedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class InsightsDatePresetChangedMapper
    extends ClassMapperBase<InsightsDatePresetChanged> {
  InsightsDatePresetChangedMapper._();

  static InsightsDatePresetChangedMapper? _instance;
  static InsightsDatePresetChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsightsDatePresetChangedMapper._(),
      );
      InsightsEventMapper.ensureInitialized();
      InsightsDatePresetMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsDatePresetChanged';

  static InsightsDatePreset _$preset(InsightsDatePresetChanged v) => v.preset;
  static const Field<InsightsDatePresetChanged, InsightsDatePreset> _f$preset =
      Field('preset', _$preset);

  @override
  final MappableFields<InsightsDatePresetChanged> fields = const {
    #preset: _f$preset,
  };

  static InsightsDatePresetChanged _instantiate(DecodingData data) {
    return InsightsDatePresetChanged(data.dec(_f$preset));
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsDatePresetChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsDatePresetChanged>(map);
  }

  static InsightsDatePresetChanged fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsDatePresetChanged>(json);
  }
}

mixin InsightsDatePresetChangedMappable {
  String toJson() {
    return InsightsDatePresetChangedMapper.ensureInitialized()
        .encodeJson<InsightsDatePresetChanged>(
          this as InsightsDatePresetChanged,
        );
  }

  Map<String, dynamic> toMap() {
    return InsightsDatePresetChangedMapper.ensureInitialized()
        .encodeMap<InsightsDatePresetChanged>(
          this as InsightsDatePresetChanged,
        );
  }

  InsightsDatePresetChangedCopyWith<
    InsightsDatePresetChanged,
    InsightsDatePresetChanged,
    InsightsDatePresetChanged
  >
  get copyWith =>
      _InsightsDatePresetChangedCopyWithImpl<
        InsightsDatePresetChanged,
        InsightsDatePresetChanged
      >(this as InsightsDatePresetChanged, $identity, $identity);
  @override
  String toString() {
    return InsightsDatePresetChangedMapper.ensureInitialized().stringifyValue(
      this as InsightsDatePresetChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsightsDatePresetChangedMapper.ensureInitialized().equalsValue(
      this as InsightsDatePresetChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return InsightsDatePresetChangedMapper.ensureInitialized().hashValue(
      this as InsightsDatePresetChanged,
    );
  }
}

extension InsightsDatePresetChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsightsDatePresetChanged, $Out> {
  InsightsDatePresetChangedCopyWith<$R, InsightsDatePresetChanged, $Out>
  get $asInsightsDatePresetChanged => $base.as(
    (v, t, t2) => _InsightsDatePresetChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsightsDatePresetChangedCopyWith<
  $R,
  $In extends InsightsDatePresetChanged,
  $Out
>
    implements InsightsEventCopyWith<$R, $In, $Out> {
  @override
  $R call({InsightsDatePreset? preset});
  InsightsDatePresetChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsightsDatePresetChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsightsDatePresetChanged, $Out>
    implements
        InsightsDatePresetChangedCopyWith<$R, InsightsDatePresetChanged, $Out> {
  _InsightsDatePresetChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsightsDatePresetChanged> $mapper =
      InsightsDatePresetChangedMapper.ensureInitialized();
  @override
  $R call({InsightsDatePreset? preset}) =>
      $apply(FieldCopyWithData({if (preset != null) #preset: preset}));
  @override
  InsightsDatePresetChanged $make(CopyWithData data) =>
      InsightsDatePresetChanged(data.get(#preset, or: $value.preset));

  @override
  InsightsDatePresetChangedCopyWith<$R2, InsightsDatePresetChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsightsDatePresetChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class InsightsDateRangeChangedMapper
    extends ClassMapperBase<InsightsDateRangeChanged> {
  InsightsDateRangeChangedMapper._();

  static InsightsDateRangeChangedMapper? _instance;
  static InsightsDateRangeChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsightsDateRangeChangedMapper._(),
      );
      InsightsEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsDateRangeChanged';

  static DateTime _$startDate(InsightsDateRangeChanged v) => v.startDate;
  static const Field<InsightsDateRangeChanged, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
  );
  static DateTime _$endDate(InsightsDateRangeChanged v) => v.endDate;
  static const Field<InsightsDateRangeChanged, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
  );

  @override
  final MappableFields<InsightsDateRangeChanged> fields = const {
    #startDate: _f$startDate,
    #endDate: _f$endDate,
  };

  static InsightsDateRangeChanged _instantiate(DecodingData data) {
    return InsightsDateRangeChanged(
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsDateRangeChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsDateRangeChanged>(map);
  }

  static InsightsDateRangeChanged fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsDateRangeChanged>(json);
  }
}

mixin InsightsDateRangeChangedMappable {
  String toJson() {
    return InsightsDateRangeChangedMapper.ensureInitialized()
        .encodeJson<InsightsDateRangeChanged>(this as InsightsDateRangeChanged);
  }

  Map<String, dynamic> toMap() {
    return InsightsDateRangeChangedMapper.ensureInitialized()
        .encodeMap<InsightsDateRangeChanged>(this as InsightsDateRangeChanged);
  }

  InsightsDateRangeChangedCopyWith<
    InsightsDateRangeChanged,
    InsightsDateRangeChanged,
    InsightsDateRangeChanged
  >
  get copyWith =>
      _InsightsDateRangeChangedCopyWithImpl<
        InsightsDateRangeChanged,
        InsightsDateRangeChanged
      >(this as InsightsDateRangeChanged, $identity, $identity);
  @override
  String toString() {
    return InsightsDateRangeChangedMapper.ensureInitialized().stringifyValue(
      this as InsightsDateRangeChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsightsDateRangeChangedMapper.ensureInitialized().equalsValue(
      this as InsightsDateRangeChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return InsightsDateRangeChangedMapper.ensureInitialized().hashValue(
      this as InsightsDateRangeChanged,
    );
  }
}

extension InsightsDateRangeChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsightsDateRangeChanged, $Out> {
  InsightsDateRangeChangedCopyWith<$R, InsightsDateRangeChanged, $Out>
  get $asInsightsDateRangeChanged => $base.as(
    (v, t, t2) => _InsightsDateRangeChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsightsDateRangeChangedCopyWith<
  $R,
  $In extends InsightsDateRangeChanged,
  $Out
>
    implements InsightsEventCopyWith<$R, $In, $Out> {
  @override
  $R call({DateTime? startDate, DateTime? endDate});
  InsightsDateRangeChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsightsDateRangeChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsightsDateRangeChanged, $Out>
    implements
        InsightsDateRangeChangedCopyWith<$R, InsightsDateRangeChanged, $Out> {
  _InsightsDateRangeChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsightsDateRangeChanged> $mapper =
      InsightsDateRangeChangedMapper.ensureInitialized();
  @override
  $R call({DateTime? startDate, DateTime? endDate}) => $apply(
    FieldCopyWithData({
      if (startDate != null) #startDate: startDate,
      if (endDate != null) #endDate: endDate,
    }),
  );
  @override
  InsightsDateRangeChanged $make(CopyWithData data) => InsightsDateRangeChanged(
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
  );

  @override
  InsightsDateRangeChangedCopyWith<$R2, InsightsDateRangeChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsightsDateRangeChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class InsightsProviderToggledMapper
    extends ClassMapperBase<InsightsProviderToggled> {
  InsightsProviderToggledMapper._();

  static InsightsProviderToggledMapper? _instance;
  static InsightsProviderToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsightsProviderToggledMapper._(),
      );
      InsightsEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsProviderToggled';

  static String _$providerId(InsightsProviderToggled v) => v.providerId;
  static const Field<InsightsProviderToggled, String> _f$providerId = Field(
    'providerId',
    _$providerId,
  );

  @override
  final MappableFields<InsightsProviderToggled> fields = const {
    #providerId: _f$providerId,
  };

  static InsightsProviderToggled _instantiate(DecodingData data) {
    return InsightsProviderToggled(data.dec(_f$providerId));
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsProviderToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsProviderToggled>(map);
  }

  static InsightsProviderToggled fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsProviderToggled>(json);
  }
}

mixin InsightsProviderToggledMappable {
  String toJson() {
    return InsightsProviderToggledMapper.ensureInitialized()
        .encodeJson<InsightsProviderToggled>(this as InsightsProviderToggled);
  }

  Map<String, dynamic> toMap() {
    return InsightsProviderToggledMapper.ensureInitialized()
        .encodeMap<InsightsProviderToggled>(this as InsightsProviderToggled);
  }

  InsightsProviderToggledCopyWith<
    InsightsProviderToggled,
    InsightsProviderToggled,
    InsightsProviderToggled
  >
  get copyWith =>
      _InsightsProviderToggledCopyWithImpl<
        InsightsProviderToggled,
        InsightsProviderToggled
      >(this as InsightsProviderToggled, $identity, $identity);
  @override
  String toString() {
    return InsightsProviderToggledMapper.ensureInitialized().stringifyValue(
      this as InsightsProviderToggled,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsightsProviderToggledMapper.ensureInitialized().equalsValue(
      this as InsightsProviderToggled,
      other,
    );
  }

  @override
  int get hashCode {
    return InsightsProviderToggledMapper.ensureInitialized().hashValue(
      this as InsightsProviderToggled,
    );
  }
}

extension InsightsProviderToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsightsProviderToggled, $Out> {
  InsightsProviderToggledCopyWith<$R, InsightsProviderToggled, $Out>
  get $asInsightsProviderToggled => $base.as(
    (v, t, t2) => _InsightsProviderToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsightsProviderToggledCopyWith<
  $R,
  $In extends InsightsProviderToggled,
  $Out
>
    implements InsightsEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? providerId});
  InsightsProviderToggledCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsightsProviderToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsightsProviderToggled, $Out>
    implements
        InsightsProviderToggledCopyWith<$R, InsightsProviderToggled, $Out> {
  _InsightsProviderToggledCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsightsProviderToggled> $mapper =
      InsightsProviderToggledMapper.ensureInitialized();
  @override
  $R call({String? providerId}) => $apply(
    FieldCopyWithData({if (providerId != null) #providerId: providerId}),
  );
  @override
  InsightsProviderToggled $make(CopyWithData data) =>
      InsightsProviderToggled(data.get(#providerId, or: $value.providerId));

  @override
  InsightsProviderToggledCopyWith<$R2, InsightsProviderToggled, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsightsProviderToggledCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class InsightsActivityCategoryToggledMapper
    extends ClassMapperBase<InsightsActivityCategoryToggled> {
  InsightsActivityCategoryToggledMapper._();

  static InsightsActivityCategoryToggledMapper? _instance;
  static InsightsActivityCategoryToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsightsActivityCategoryToggledMapper._(),
      );
      InsightsEventMapper.ensureInitialized();
      ActivityCategoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsActivityCategoryToggled';

  static ActivityCategory _$category(InsightsActivityCategoryToggled v) =>
      v.category;
  static const Field<InsightsActivityCategoryToggled, ActivityCategory>
  _f$category = Field('category', _$category);

  @override
  final MappableFields<InsightsActivityCategoryToggled> fields = const {
    #category: _f$category,
  };

  static InsightsActivityCategoryToggled _instantiate(DecodingData data) {
    return InsightsActivityCategoryToggled(data.dec(_f$category));
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsActivityCategoryToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsActivityCategoryToggled>(map);
  }

  static InsightsActivityCategoryToggled fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsActivityCategoryToggled>(
      json,
    );
  }
}

mixin InsightsActivityCategoryToggledMappable {
  String toJson() {
    return InsightsActivityCategoryToggledMapper.ensureInitialized()
        .encodeJson<InsightsActivityCategoryToggled>(
          this as InsightsActivityCategoryToggled,
        );
  }

  Map<String, dynamic> toMap() {
    return InsightsActivityCategoryToggledMapper.ensureInitialized()
        .encodeMap<InsightsActivityCategoryToggled>(
          this as InsightsActivityCategoryToggled,
        );
  }

  InsightsActivityCategoryToggledCopyWith<
    InsightsActivityCategoryToggled,
    InsightsActivityCategoryToggled,
    InsightsActivityCategoryToggled
  >
  get copyWith =>
      _InsightsActivityCategoryToggledCopyWithImpl<
        InsightsActivityCategoryToggled,
        InsightsActivityCategoryToggled
      >(this as InsightsActivityCategoryToggled, $identity, $identity);
  @override
  String toString() {
    return InsightsActivityCategoryToggledMapper.ensureInitialized()
        .stringifyValue(this as InsightsActivityCategoryToggled);
  }

  @override
  bool operator ==(Object other) {
    return InsightsActivityCategoryToggledMapper.ensureInitialized()
        .equalsValue(this as InsightsActivityCategoryToggled, other);
  }

  @override
  int get hashCode {
    return InsightsActivityCategoryToggledMapper.ensureInitialized().hashValue(
      this as InsightsActivityCategoryToggled,
    );
  }
}

extension InsightsActivityCategoryToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsightsActivityCategoryToggled, $Out> {
  InsightsActivityCategoryToggledCopyWith<
    $R,
    InsightsActivityCategoryToggled,
    $Out
  >
  get $asInsightsActivityCategoryToggled => $base.as(
    (v, t, t2) =>
        _InsightsActivityCategoryToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsightsActivityCategoryToggledCopyWith<
  $R,
  $In extends InsightsActivityCategoryToggled,
  $Out
>
    implements InsightsEventCopyWith<$R, $In, $Out> {
  @override
  $R call({ActivityCategory? category});
  InsightsActivityCategoryToggledCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsightsActivityCategoryToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsightsActivityCategoryToggled, $Out>
    implements
        InsightsActivityCategoryToggledCopyWith<
          $R,
          InsightsActivityCategoryToggled,
          $Out
        > {
  _InsightsActivityCategoryToggledCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<InsightsActivityCategoryToggled> $mapper =
      InsightsActivityCategoryToggledMapper.ensureInitialized();
  @override
  $R call({ActivityCategory? category}) =>
      $apply(FieldCopyWithData({if (category != null) #category: category}));
  @override
  InsightsActivityCategoryToggled $make(CopyWithData data) =>
      InsightsActivityCategoryToggled(data.get(#category, or: $value.category));

  @override
  InsightsActivityCategoryToggledCopyWith<
    $R2,
    InsightsActivityCategoryToggled,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsightsActivityCategoryToggledCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

class InsightsUserToggledMapper extends ClassMapperBase<InsightsUserToggled> {
  InsightsUserToggledMapper._();

  static InsightsUserToggledMapper? _instance;
  static InsightsUserToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InsightsUserToggledMapper._());
      InsightsEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsUserToggled';

  static String _$userId(InsightsUserToggled v) => v.userId;
  static const Field<InsightsUserToggled, String> _f$userId = Field(
    'userId',
    _$userId,
  );

  @override
  final MappableFields<InsightsUserToggled> fields = const {#userId: _f$userId};

  static InsightsUserToggled _instantiate(DecodingData data) {
    return InsightsUserToggled(data.dec(_f$userId));
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsUserToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsUserToggled>(map);
  }

  static InsightsUserToggled fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsUserToggled>(json);
  }
}

mixin InsightsUserToggledMappable {
  String toJson() {
    return InsightsUserToggledMapper.ensureInitialized()
        .encodeJson<InsightsUserToggled>(this as InsightsUserToggled);
  }

  Map<String, dynamic> toMap() {
    return InsightsUserToggledMapper.ensureInitialized()
        .encodeMap<InsightsUserToggled>(this as InsightsUserToggled);
  }

  InsightsUserToggledCopyWith<
    InsightsUserToggled,
    InsightsUserToggled,
    InsightsUserToggled
  >
  get copyWith =>
      _InsightsUserToggledCopyWithImpl<
        InsightsUserToggled,
        InsightsUserToggled
      >(this as InsightsUserToggled, $identity, $identity);
  @override
  String toString() {
    return InsightsUserToggledMapper.ensureInitialized().stringifyValue(
      this as InsightsUserToggled,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsightsUserToggledMapper.ensureInitialized().equalsValue(
      this as InsightsUserToggled,
      other,
    );
  }

  @override
  int get hashCode {
    return InsightsUserToggledMapper.ensureInitialized().hashValue(
      this as InsightsUserToggled,
    );
  }
}

extension InsightsUserToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsightsUserToggled, $Out> {
  InsightsUserToggledCopyWith<$R, InsightsUserToggled, $Out>
  get $asInsightsUserToggled => $base.as(
    (v, t, t2) => _InsightsUserToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsightsUserToggledCopyWith<
  $R,
  $In extends InsightsUserToggled,
  $Out
>
    implements InsightsEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? userId});
  InsightsUserToggledCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsightsUserToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsightsUserToggled, $Out>
    implements InsightsUserToggledCopyWith<$R, InsightsUserToggled, $Out> {
  _InsightsUserToggledCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsightsUserToggled> $mapper =
      InsightsUserToggledMapper.ensureInitialized();
  @override
  $R call({String? userId}) =>
      $apply(FieldCopyWithData({if (userId != null) #userId: userId}));
  @override
  InsightsUserToggled $make(CopyWithData data) =>
      InsightsUserToggled(data.get(#userId, or: $value.userId));

  @override
  InsightsUserToggledCopyWith<$R2, InsightsUserToggled, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsightsUserToggledCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class InsightsRefreshRequestedMapper
    extends ClassMapperBase<InsightsRefreshRequested> {
  InsightsRefreshRequestedMapper._();

  static InsightsRefreshRequestedMapper? _instance;
  static InsightsRefreshRequestedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsightsRefreshRequestedMapper._(),
      );
      InsightsEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsightsRefreshRequested';

  @override
  final MappableFields<InsightsRefreshRequested> fields = const {};

  static InsightsRefreshRequested _instantiate(DecodingData data) {
    return InsightsRefreshRequested();
  }

  @override
  final Function instantiate = _instantiate;

  static InsightsRefreshRequested fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsightsRefreshRequested>(map);
  }

  static InsightsRefreshRequested fromJson(String json) {
    return ensureInitialized().decodeJson<InsightsRefreshRequested>(json);
  }
}

mixin InsightsRefreshRequestedMappable {
  String toJson() {
    return InsightsRefreshRequestedMapper.ensureInitialized()
        .encodeJson<InsightsRefreshRequested>(this as InsightsRefreshRequested);
  }

  Map<String, dynamic> toMap() {
    return InsightsRefreshRequestedMapper.ensureInitialized()
        .encodeMap<InsightsRefreshRequested>(this as InsightsRefreshRequested);
  }

  InsightsRefreshRequestedCopyWith<
    InsightsRefreshRequested,
    InsightsRefreshRequested,
    InsightsRefreshRequested
  >
  get copyWith =>
      _InsightsRefreshRequestedCopyWithImpl<
        InsightsRefreshRequested,
        InsightsRefreshRequested
      >(this as InsightsRefreshRequested, $identity, $identity);
  @override
  String toString() {
    return InsightsRefreshRequestedMapper.ensureInitialized().stringifyValue(
      this as InsightsRefreshRequested,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsightsRefreshRequestedMapper.ensureInitialized().equalsValue(
      this as InsightsRefreshRequested,
      other,
    );
  }

  @override
  int get hashCode {
    return InsightsRefreshRequestedMapper.ensureInitialized().hashValue(
      this as InsightsRefreshRequested,
    );
  }
}

extension InsightsRefreshRequestedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsightsRefreshRequested, $Out> {
  InsightsRefreshRequestedCopyWith<$R, InsightsRefreshRequested, $Out>
  get $asInsightsRefreshRequested => $base.as(
    (v, t, t2) => _InsightsRefreshRequestedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsightsRefreshRequestedCopyWith<
  $R,
  $In extends InsightsRefreshRequested,
  $Out
>
    implements InsightsEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  InsightsRefreshRequestedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsightsRefreshRequestedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsightsRefreshRequested, $Out>
    implements
        InsightsRefreshRequestedCopyWith<$R, InsightsRefreshRequested, $Out> {
  _InsightsRefreshRequestedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsightsRefreshRequested> $mapper =
      InsightsRefreshRequestedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  InsightsRefreshRequested $make(CopyWithData data) =>
      InsightsRefreshRequested();

  @override
  InsightsRefreshRequestedCopyWith<$R2, InsightsRefreshRequested, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsightsRefreshRequestedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

