// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_state.dart';

class SettingsStateMapper extends ClassMapperBase<SettingsState> {
  SettingsStateMapper._();

  static SettingsStateMapper? _instance;
  static SettingsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsStateMapper._());
      ViewStatusMapper.ensureInitialized();
      AppSettingsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsState';

  static ViewStatus _$status(SettingsState v) => v.status;
  static const Field<SettingsState, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static AppSettings _$persistedSettings(SettingsState v) =>
      v.persistedSettings;
  static const Field<SettingsState, AppSettings> _f$persistedSettings = Field(
    'persistedSettings',
    _$persistedSettings,
    opt: true,
    def: const AppSettings(),
  );
  static AppSettings _$draftSettings(SettingsState v) => v.draftSettings;
  static const Field<SettingsState, AppSettings> _f$draftSettings = Field(
    'draftSettings',
    _$draftSettings,
    opt: true,
    def: const AppSettings(),
  );
  static bool _$isDirty(SettingsState v) => v.isDirty;
  static const Field<SettingsState, bool> _f$isDirty = Field(
    'isDirty',
    _$isDirty,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<SettingsState> fields = const {
    #status: _f$status,
    #persistedSettings: _f$persistedSettings,
    #draftSettings: _f$draftSettings,
    #isDirty: _f$isDirty,
  };

  static SettingsState _instantiate(DecodingData data) {
    return SettingsState(
      status: data.dec(_f$status),
      persistedSettings: data.dec(_f$persistedSettings),
      draftSettings: data.dec(_f$draftSettings),
      isDirty: data.dec(_f$isDirty),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsState>(map);
  }

  static SettingsState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsState>(json);
  }
}

mixin SettingsStateMappable {
  String toJson() {
    return SettingsStateMapper.ensureInitialized().encodeJson<SettingsState>(
      this as SettingsState,
    );
  }

  Map<String, dynamic> toMap() {
    return SettingsStateMapper.ensureInitialized().encodeMap<SettingsState>(
      this as SettingsState,
    );
  }

  SettingsStateCopyWith<SettingsState, SettingsState, SettingsState>
  get copyWith => _SettingsStateCopyWithImpl<SettingsState, SettingsState>(
    this as SettingsState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SettingsStateMapper.ensureInitialized().stringifyValue(
      this as SettingsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsStateMapper.ensureInitialized().equalsValue(
      this as SettingsState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsStateMapper.ensureInitialized().hashValue(
      this as SettingsState,
    );
  }
}

extension SettingsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsState, $Out> {
  SettingsStateCopyWith<$R, SettingsState, $Out> get $asSettingsState =>
      $base.as((v, t, t2) => _SettingsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SettingsStateCopyWith<$R, $In extends SettingsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AppSettingsCopyWith<$R, AppSettings, AppSettings> get persistedSettings;
  AppSettingsCopyWith<$R, AppSettings, AppSettings> get draftSettings;
  $R call({
    ViewStatus? status,
    AppSettings? persistedSettings,
    AppSettings? draftSettings,
    bool? isDirty,
  });
  SettingsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SettingsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsState, $Out>
    implements SettingsStateCopyWith<$R, SettingsState, $Out> {
  _SettingsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsState> $mapper =
      SettingsStateMapper.ensureInitialized();
  @override
  AppSettingsCopyWith<$R, AppSettings, AppSettings> get persistedSettings =>
      $value.persistedSettings.copyWith.$chain(
        (v) => call(persistedSettings: v),
      );
  @override
  AppSettingsCopyWith<$R, AppSettings, AppSettings> get draftSettings =>
      $value.draftSettings.copyWith.$chain((v) => call(draftSettings: v));
  @override
  $R call({
    ViewStatus? status,
    AppSettings? persistedSettings,
    AppSettings? draftSettings,
    bool? isDirty,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (persistedSettings != null) #persistedSettings: persistedSettings,
      if (draftSettings != null) #draftSettings: draftSettings,
      if (isDirty != null) #isDirty: isDirty,
    }),
  );
  @override
  SettingsState $make(CopyWithData data) => SettingsState(
    status: data.get(#status, or: $value.status),
    persistedSettings: data.get(
      #persistedSettings,
      or: $value.persistedSettings,
    ),
    draftSettings: data.get(#draftSettings, or: $value.draftSettings),
    isDirty: data.get(#isDirty, or: $value.isDirty),
  );

  @override
  SettingsStateCopyWith<$R2, SettingsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SettingsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

