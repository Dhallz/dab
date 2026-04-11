// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'provider_config.dart';

class ProviderConfigMapper extends ClassMapperBase<ProviderConfig> {
  ProviderConfigMapper._();

  static ProviderConfigMapper? _instance;
  static ProviderConfigMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProviderConfigMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProviderConfig';

  static String _$id(ProviderConfig v) => v.id;
  static const Field<ProviderConfig, String> _f$id = Field('id', _$id);
  static String _$name(ProviderConfig v) => v.name;
  static const Field<ProviderConfig, String> _f$name = Field('name', _$name);
  static String _$baseUrl(ProviderConfig v) => v.baseUrl;
  static const Field<ProviderConfig, String> _f$baseUrl = Field(
    'baseUrl',
    _$baseUrl,
  );
  static String? _$iconUrl(ProviderConfig v) => v.iconUrl;
  static const Field<ProviderConfig, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static bool _$isActive(ProviderConfig v) => v.isActive;
  static const Field<ProviderConfig, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
  );
  static Map<String, dynamic> _$settings(ProviderConfig v) => v.settings;
  static const Field<ProviderConfig, Map<String, dynamic>> _f$settings = Field(
    'settings',
    _$settings,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<ProviderConfig> fields = const {
    #id: _f$id,
    #name: _f$name,
    #baseUrl: _f$baseUrl,
    #iconUrl: _f$iconUrl,
    #isActive: _f$isActive,
    #settings: _f$settings,
  };

  static ProviderConfig _instantiate(DecodingData data) {
    return ProviderConfig(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      baseUrl: data.dec(_f$baseUrl),
      iconUrl: data.dec(_f$iconUrl),
      isActive: data.dec(_f$isActive),
      settings: data.dec(_f$settings),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProviderConfig fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProviderConfig>(map);
  }

  static ProviderConfig fromJson(String json) {
    return ensureInitialized().decodeJson<ProviderConfig>(json);
  }
}

mixin ProviderConfigMappable {
  String toJson() {
    return ProviderConfigMapper.ensureInitialized().encodeJson<ProviderConfig>(
      this as ProviderConfig,
    );
  }

  Map<String, dynamic> toMap() {
    return ProviderConfigMapper.ensureInitialized().encodeMap<ProviderConfig>(
      this as ProviderConfig,
    );
  }

  ProviderConfigCopyWith<ProviderConfig, ProviderConfig, ProviderConfig>
  get copyWith => _ProviderConfigCopyWithImpl<ProviderConfig, ProviderConfig>(
    this as ProviderConfig,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ProviderConfigMapper.ensureInitialized().stringifyValue(
      this as ProviderConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProviderConfigMapper.ensureInitialized().equalsValue(
      this as ProviderConfig,
      other,
    );
  }

  @override
  int get hashCode {
    return ProviderConfigMapper.ensureInitialized().hashValue(
      this as ProviderConfig,
    );
  }
}

extension ProviderConfigValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProviderConfig, $Out> {
  ProviderConfigCopyWith<$R, ProviderConfig, $Out> get $asProviderConfig =>
      $base.as((v, t, t2) => _ProviderConfigCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProviderConfigCopyWith<$R, $In extends ProviderConfig, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get settings;
  $R call({
    String? id,
    String? name,
    String? baseUrl,
    String? iconUrl,
    bool? isActive,
    Map<String, dynamic>? settings,
  });
  ProviderConfigCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProviderConfigCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProviderConfig, $Out>
    implements ProviderConfigCopyWith<$R, ProviderConfig, $Out> {
  _ProviderConfigCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProviderConfig> $mapper =
      ProviderConfigMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get settings => MapCopyWith(
    $value.settings,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(settings: v),
  );
  @override
  $R call({
    String? id,
    String? name,
    String? baseUrl,
    Object? iconUrl = $none,
    bool? isActive,
    Map<String, dynamic>? settings,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (baseUrl != null) #baseUrl: baseUrl,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (isActive != null) #isActive: isActive,
      if (settings != null) #settings: settings,
    }),
  );
  @override
  ProviderConfig $make(CopyWithData data) => ProviderConfig(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    baseUrl: data.get(#baseUrl, or: $value.baseUrl),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    isActive: data.get(#isActive, or: $value.isActive),
    settings: data.get(#settings, or: $value.settings),
  );

  @override
  ProviderConfigCopyWith<$R2, ProviderConfig, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProviderConfigCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

