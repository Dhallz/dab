// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_state.dart';

class AppStateMapper extends ClassMapperBase<AppState> {
  AppStateMapper._();

  static AppStateMapper? _instance;
  static AppStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppStateMapper._());
      ViewStatusMapper.ensureInitialized();
      AppSettingsMapper.ensureInitialized();
      ProviderConfigMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppState';

  static ViewStatus _$status(AppState v) => v.status;
  static const Field<AppState, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static AppSettings _$settings(AppState v) => v.settings;
  static const Field<AppState, AppSettings> _f$settings = Field(
    'settings',
    _$settings,
    opt: true,
    def: const AppSettings(),
  );
  static List<ProviderConfig> _$configs(AppState v) => v.configs;
  static const Field<AppState, List<ProviderConfig>> _f$configs = Field(
    'configs',
    _$configs,
    opt: true,
    def: const [],
  );
  static bool _$isSystemConfigured(AppState v) => v.isSystemConfigured;
  static const Field<AppState, bool> _f$isSystemConfigured = Field(
    'isSystemConfigured',
    _$isSystemConfigured,
    opt: true,
    def: false,
  );
  static int _$unresolvedIdentityCount(AppState v) => v.unresolvedIdentityCount;
  static const Field<AppState, int> _f$unresolvedIdentityCount = Field(
    'unresolvedIdentityCount',
    _$unresolvedIdentityCount,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<AppState> fields = const {
    #status: _f$status,
    #settings: _f$settings,
    #configs: _f$configs,
    #isSystemConfigured: _f$isSystemConfigured,
    #unresolvedIdentityCount: _f$unresolvedIdentityCount,
  };

  static AppState _instantiate(DecodingData data) {
    return AppState(
      status: data.dec(_f$status),
      settings: data.dec(_f$settings),
      configs: data.dec(_f$configs),
      isSystemConfigured: data.dec(_f$isSystemConfigured),
      unresolvedIdentityCount: data.dec(_f$unresolvedIdentityCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppState>(map);
  }

  static AppState fromJson(String json) {
    return ensureInitialized().decodeJson<AppState>(json);
  }
}

mixin AppStateMappable {
  String toJson() {
    return AppStateMapper.ensureInitialized().encodeJson<AppState>(
      this as AppState,
    );
  }

  Map<String, dynamic> toMap() {
    return AppStateMapper.ensureInitialized().encodeMap<AppState>(
      this as AppState,
    );
  }

  AppStateCopyWith<AppState, AppState, AppState> get copyWith =>
      _AppStateCopyWithImpl<AppState, AppState>(
        this as AppState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppStateMapper.ensureInitialized().stringifyValue(this as AppState);
  }

  @override
  bool operator ==(Object other) {
    return AppStateMapper.ensureInitialized().equalsValue(
      this as AppState,
      other,
    );
  }

  @override
  int get hashCode {
    return AppStateMapper.ensureInitialized().hashValue(this as AppState);
  }
}

extension AppStateValueCopy<$R, $Out> on ObjectCopyWith<$R, AppState, $Out> {
  AppStateCopyWith<$R, AppState, $Out> get $asAppState =>
      $base.as((v, t, t2) => _AppStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppStateCopyWith<$R, $In extends AppState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AppSettingsCopyWith<$R, AppSettings, AppSettings> get settings;
  ListCopyWith<
    $R,
    ProviderConfig,
    ProviderConfigCopyWith<$R, ProviderConfig, ProviderConfig>
  >
  get configs;
  $R call({
    ViewStatus? status,
    AppSettings? settings,
    List<ProviderConfig>? configs,
    bool? isSystemConfigured,
    int? unresolvedIdentityCount,
  });
  AppStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppState, $Out>
    implements AppStateCopyWith<$R, AppState, $Out> {
  _AppStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppState> $mapper =
      AppStateMapper.ensureInitialized();
  @override
  AppSettingsCopyWith<$R, AppSettings, AppSettings> get settings =>
      $value.settings.copyWith.$chain((v) => call(settings: v));
  @override
  ListCopyWith<
    $R,
    ProviderConfig,
    ProviderConfigCopyWith<$R, ProviderConfig, ProviderConfig>
  >
  get configs => ListCopyWith(
    $value.configs,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(configs: v),
  );
  @override
  $R call({
    ViewStatus? status,
    AppSettings? settings,
    List<ProviderConfig>? configs,
    bool? isSystemConfigured,
    int? unresolvedIdentityCount,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (settings != null) #settings: settings,
      if (configs != null) #configs: configs,
      if (isSystemConfigured != null) #isSystemConfigured: isSystemConfigured,
      if (unresolvedIdentityCount != null)
        #unresolvedIdentityCount: unresolvedIdentityCount,
    }),
  );
  @override
  AppState $make(CopyWithData data) => AppState(
    status: data.get(#status, or: $value.status),
    settings: data.get(#settings, or: $value.settings),
    configs: data.get(#configs, or: $value.configs),
    isSystemConfigured: data.get(
      #isSystemConfigured,
      or: $value.isSystemConfigured,
    ),
    unresolvedIdentityCount: data.get(
      #unresolvedIdentityCount,
      or: $value.unresolvedIdentityCount,
    ),
  );

  @override
  AppStateCopyWith<$R2, AppState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

