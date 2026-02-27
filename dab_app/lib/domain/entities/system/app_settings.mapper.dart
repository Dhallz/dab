// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_settings.dart';

class AppSettingsMapper extends ClassMapperBase<AppSettings> {
  AppSettingsMapper._();

  static AppSettingsMapper? _instance;
  static AppSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppSettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AppSettings';

  static ThemeMode _$themeMode(AppSettings v) => v.themeMode;
  static const Field<AppSettings, ThemeMode> _f$themeMode = Field(
    'themeMode',
    _$themeMode,
    opt: true,
    def: ThemeMode.system,
  );

  @override
  final MappableFields<AppSettings> fields = const {#themeMode: _f$themeMode};

  static AppSettings _instantiate(DecodingData data) {
    return AppSettings(themeMode: data.dec(_f$themeMode));
  }

  @override
  final Function instantiate = _instantiate;

  static AppSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppSettings>(map);
  }

  static AppSettings fromJson(String json) {
    return ensureInitialized().decodeJson<AppSettings>(json);
  }
}

mixin AppSettingsMappable {
  String toJson() {
    return AppSettingsMapper.ensureInitialized().encodeJson<AppSettings>(
      this as AppSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return AppSettingsMapper.ensureInitialized().encodeMap<AppSettings>(
      this as AppSettings,
    );
  }

  AppSettingsCopyWith<AppSettings, AppSettings, AppSettings> get copyWith =>
      _AppSettingsCopyWithImpl<AppSettings, AppSettings>(
        this as AppSettings,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppSettingsMapper.ensureInitialized().stringifyValue(
      this as AppSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return AppSettingsMapper.ensureInitialized().equalsValue(
      this as AppSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return AppSettingsMapper.ensureInitialized().hashValue(this as AppSettings);
  }
}

extension AppSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppSettings, $Out> {
  AppSettingsCopyWith<$R, AppSettings, $Out> get $asAppSettings =>
      $base.as((v, t, t2) => _AppSettingsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppSettingsCopyWith<$R, $In extends AppSettings, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({ThemeMode? themeMode});
  AppSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppSettings, $Out>
    implements AppSettingsCopyWith<$R, AppSettings, $Out> {
  _AppSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppSettings> $mapper =
      AppSettingsMapper.ensureInitialized();
  @override
  $R call({ThemeMode? themeMode}) =>
      $apply(FieldCopyWithData({if (themeMode != null) #themeMode: themeMode}));
  @override
  AppSettings $make(CopyWithData data) =>
      AppSettings(themeMode: data.get(#themeMode, or: $value.themeMode));

  @override
  AppSettingsCopyWith<$R2, AppSettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

