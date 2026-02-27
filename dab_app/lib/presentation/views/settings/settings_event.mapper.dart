// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_event.dart';

class SettingsEventMapper extends ClassMapperBase<SettingsEvent> {
  SettingsEventMapper._();

  static SettingsEventMapper? _instance;
  static SettingsEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsEventMapper._());
      SettingsStartedMapper.ensureInitialized();
      SettingsThemeModeChangedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsEvent';

  @override
  final MappableFields<SettingsEvent> fields = const {};

  static SettingsEvent _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('SettingsEvent');
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsEvent>(map);
  }

  static SettingsEvent fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsEvent>(json);
  }
}

mixin SettingsEventMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SettingsEventCopyWith<SettingsEvent, SettingsEvent, SettingsEvent>
  get copyWith;
}

abstract class SettingsEventCopyWith<$R, $In extends SettingsEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  SettingsEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class SettingsStartedMapper extends ClassMapperBase<SettingsStarted> {
  SettingsStartedMapper._();

  static SettingsStartedMapper? _instance;
  static SettingsStartedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsStartedMapper._());
      SettingsEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsStarted';

  @override
  final MappableFields<SettingsStarted> fields = const {};

  static SettingsStarted _instantiate(DecodingData data) {
    return SettingsStarted();
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsStarted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsStarted>(map);
  }

  static SettingsStarted fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsStarted>(json);
  }
}

mixin SettingsStartedMappable {
  String toJson() {
    return SettingsStartedMapper.ensureInitialized()
        .encodeJson<SettingsStarted>(this as SettingsStarted);
  }

  Map<String, dynamic> toMap() {
    return SettingsStartedMapper.ensureInitialized().encodeMap<SettingsStarted>(
      this as SettingsStarted,
    );
  }

  SettingsStartedCopyWith<SettingsStarted, SettingsStarted, SettingsStarted>
  get copyWith =>
      _SettingsStartedCopyWithImpl<SettingsStarted, SettingsStarted>(
        this as SettingsStarted,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SettingsStartedMapper.ensureInitialized().stringifyValue(
      this as SettingsStarted,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsStartedMapper.ensureInitialized().equalsValue(
      this as SettingsStarted,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsStartedMapper.ensureInitialized().hashValue(
      this as SettingsStarted,
    );
  }
}

extension SettingsStartedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsStarted, $Out> {
  SettingsStartedCopyWith<$R, SettingsStarted, $Out> get $asSettingsStarted =>
      $base.as((v, t, t2) => _SettingsStartedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SettingsStartedCopyWith<$R, $In extends SettingsStarted, $Out>
    implements SettingsEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  SettingsStartedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsStartedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsStarted, $Out>
    implements SettingsStartedCopyWith<$R, SettingsStarted, $Out> {
  _SettingsStartedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsStarted> $mapper =
      SettingsStartedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  SettingsStarted $make(CopyWithData data) => SettingsStarted();

  @override
  SettingsStartedCopyWith<$R2, SettingsStarted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SettingsStartedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SettingsThemeModeChangedMapper
    extends ClassMapperBase<SettingsThemeModeChanged> {
  SettingsThemeModeChangedMapper._();

  static SettingsThemeModeChangedMapper? _instance;
  static SettingsThemeModeChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsThemeModeChangedMapper._(),
      );
      SettingsEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsThemeModeChanged';

  static ThemeMode _$mode(SettingsThemeModeChanged v) => v.mode;
  static const Field<SettingsThemeModeChanged, ThemeMode> _f$mode = Field(
    'mode',
    _$mode,
  );

  @override
  final MappableFields<SettingsThemeModeChanged> fields = const {
    #mode: _f$mode,
  };

  static SettingsThemeModeChanged _instantiate(DecodingData data) {
    return SettingsThemeModeChanged(data.dec(_f$mode));
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsThemeModeChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsThemeModeChanged>(map);
  }

  static SettingsThemeModeChanged fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsThemeModeChanged>(json);
  }
}

mixin SettingsThemeModeChangedMappable {
  String toJson() {
    return SettingsThemeModeChangedMapper.ensureInitialized()
        .encodeJson<SettingsThemeModeChanged>(this as SettingsThemeModeChanged);
  }

  Map<String, dynamic> toMap() {
    return SettingsThemeModeChangedMapper.ensureInitialized()
        .encodeMap<SettingsThemeModeChanged>(this as SettingsThemeModeChanged);
  }

  SettingsThemeModeChangedCopyWith<
    SettingsThemeModeChanged,
    SettingsThemeModeChanged,
    SettingsThemeModeChanged
  >
  get copyWith =>
      _SettingsThemeModeChangedCopyWithImpl<
        SettingsThemeModeChanged,
        SettingsThemeModeChanged
      >(this as SettingsThemeModeChanged, $identity, $identity);
  @override
  String toString() {
    return SettingsThemeModeChangedMapper.ensureInitialized().stringifyValue(
      this as SettingsThemeModeChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsThemeModeChangedMapper.ensureInitialized().equalsValue(
      this as SettingsThemeModeChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsThemeModeChangedMapper.ensureInitialized().hashValue(
      this as SettingsThemeModeChanged,
    );
  }
}

extension SettingsThemeModeChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsThemeModeChanged, $Out> {
  SettingsThemeModeChangedCopyWith<$R, SettingsThemeModeChanged, $Out>
  get $asSettingsThemeModeChanged => $base.as(
    (v, t, t2) => _SettingsThemeModeChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsThemeModeChangedCopyWith<
  $R,
  $In extends SettingsThemeModeChanged,
  $Out
>
    implements SettingsEventCopyWith<$R, $In, $Out> {
  @override
  $R call({ThemeMode? mode});
  SettingsThemeModeChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsThemeModeChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsThemeModeChanged, $Out>
    implements
        SettingsThemeModeChangedCopyWith<$R, SettingsThemeModeChanged, $Out> {
  _SettingsThemeModeChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsThemeModeChanged> $mapper =
      SettingsThemeModeChangedMapper.ensureInitialized();
  @override
  $R call({ThemeMode? mode}) =>
      $apply(FieldCopyWithData({if (mode != null) #mode: mode}));
  @override
  SettingsThemeModeChanged $make(CopyWithData data) =>
      SettingsThemeModeChanged(data.get(#mode, or: $value.mode));

  @override
  SettingsThemeModeChangedCopyWith<$R2, SettingsThemeModeChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsThemeModeChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

