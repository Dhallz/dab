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
      AppThemeVariantMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppSettings';

  static AppThemeVariant _$appThemeVariant(AppSettings v) => v.appThemeVariant;
  static const Field<AppSettings, AppThemeVariant> _f$appThemeVariant = Field(
    'appThemeVariant',
    _$appThemeVariant,
    opt: true,
    def: AppThemeVariant.dab,
  );
  static String? _$localeCode(AppSettings v) => v.localeCode;
  static const Field<AppSettings, String> _f$localeCode = Field(
    'localeCode',
    _$localeCode,
    opt: true,
  );
  static Map<String, List<String>> _$islandBarSelections(AppSettings v) =>
      v.islandBarSelections;
  static const Field<AppSettings, Map<String, List<String>>>
  _f$islandBarSelections = Field(
    'islandBarSelections',
    _$islandBarSelections,
    opt: true,
    def: appSettingsDefaultIslandBarSelections,
  );
  static String? _$syncToken(AppSettings v) => v.syncToken;
  static const Field<AppSettings, String> _f$syncToken = Field(
    'syncToken',
    _$syncToken,
    opt: true,
  );
  static bool _$inboxNotificationsEnabled(AppSettings v) =>
      v.inboxNotificationsEnabled;
  static const Field<AppSettings, bool> _f$inboxNotificationsEnabled = Field(
    'inboxNotificationsEnabled',
    _$inboxNotificationsEnabled,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<AppSettings> fields = const {
    #appThemeVariant: _f$appThemeVariant,
    #localeCode: _f$localeCode,
    #islandBarSelections: _f$islandBarSelections,
    #syncToken: _f$syncToken,
    #inboxNotificationsEnabled: _f$inboxNotificationsEnabled,
  };

  static AppSettings _instantiate(DecodingData data) {
    return AppSettings(
      appThemeVariant: data.dec(_f$appThemeVariant),
      localeCode: data.dec(_f$localeCode),
      islandBarSelections: data.dec(_f$islandBarSelections),
      syncToken: data.dec(_f$syncToken),
      inboxNotificationsEnabled: data.dec(_f$inboxNotificationsEnabled),
    );
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
  MapCopyWith<
    $R,
    String,
    List<String>,
    ObjectCopyWith<$R, List<String>, List<String>>
  >
  get islandBarSelections;
  $R call({
    AppThemeVariant? appThemeVariant,
    String? localeCode,
    Map<String, List<String>>? islandBarSelections,
    String? syncToken,
    bool? inboxNotificationsEnabled,
  });
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
  MapCopyWith<
    $R,
    String,
    List<String>,
    ObjectCopyWith<$R, List<String>, List<String>>
  >
  get islandBarSelections => MapCopyWith(
    $value.islandBarSelections,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(islandBarSelections: v),
  );
  @override
  $R call({
    AppThemeVariant? appThemeVariant,
    Object? localeCode = $none,
    Map<String, List<String>>? islandBarSelections,
    Object? syncToken = $none,
    bool? inboxNotificationsEnabled,
  }) => $apply(
    FieldCopyWithData({
      if (appThemeVariant != null) #appThemeVariant: appThemeVariant,
      if (localeCode != $none) #localeCode: localeCode,
      if (islandBarSelections != null)
        #islandBarSelections: islandBarSelections,
      if (syncToken != $none) #syncToken: syncToken,
      if (inboxNotificationsEnabled != null)
        #inboxNotificationsEnabled: inboxNotificationsEnabled,
    }),
  );
  @override
  AppSettings $make(CopyWithData data) => AppSettings(
    appThemeVariant: data.get(#appThemeVariant, or: $value.appThemeVariant),
    localeCode: data.get(#localeCode, or: $value.localeCode),
    islandBarSelections: data.get(
      #islandBarSelections,
      or: $value.islandBarSelections,
    ),
    syncToken: data.get(#syncToken, or: $value.syncToken),
    inboxNotificationsEnabled: data.get(
      #inboxNotificationsEnabled,
      or: $value.inboxNotificationsEnabled,
    ),
  );

  @override
  AppSettingsCopyWith<$R2, AppSettings, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

