// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'provider_metadata.dart';

class ProviderMetadataMapper extends ClassMapperBase<ProviderMetadata> {
  ProviderMetadataMapper._();

  static ProviderMetadataMapper? _instance;
  static ProviderMetadataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProviderMetadataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProviderMetadata';

  static String _$id(ProviderMetadata v) => v.id;
  static const Field<ProviderMetadata, String> _f$id = Field('id', _$id);
  static String _$name(ProviderMetadata v) => v.name;
  static const Field<ProviderMetadata, String> _f$name = Field('name', _$name);
  static String _$provider(ProviderMetadata v) => v.provider;
  static const Field<ProviderMetadata, String> _f$provider = Field(
    'provider',
    _$provider,
  );
  static String _$type(ProviderMetadata v) => v.type;
  static const Field<ProviderMetadata, String> _f$type = Field('type', _$type);
  static String? _$color(ProviderMetadata v) => v.color;
  static const Field<ProviderMetadata, String> _f$color = Field(
    'color',
    _$color,
    opt: true,
  );
  static String? _$icon(ProviderMetadata v) => v.icon;
  static const Field<ProviderMetadata, String> _f$icon = Field(
    'icon',
    _$icon,
    opt: true,
  );

  @override
  final MappableFields<ProviderMetadata> fields = const {
    #id: _f$id,
    #name: _f$name,
    #provider: _f$provider,
    #type: _f$type,
    #color: _f$color,
    #icon: _f$icon,
  };

  static ProviderMetadata _instantiate(DecodingData data) {
    return ProviderMetadata(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      provider: data.dec(_f$provider),
      type: data.dec(_f$type),
      color: data.dec(_f$color),
      icon: data.dec(_f$icon),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProviderMetadata fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProviderMetadata>(map);
  }

  static ProviderMetadata fromJson(String json) {
    return ensureInitialized().decodeJson<ProviderMetadata>(json);
  }
}

mixin ProviderMetadataMappable {
  String toJson() {
    return ProviderMetadataMapper.ensureInitialized()
        .encodeJson<ProviderMetadata>(this as ProviderMetadata);
  }

  Map<String, dynamic> toMap() {
    return ProviderMetadataMapper.ensureInitialized()
        .encodeMap<ProviderMetadata>(this as ProviderMetadata);
  }

  ProviderMetadataCopyWith<ProviderMetadata, ProviderMetadata, ProviderMetadata>
  get copyWith =>
      _ProviderMetadataCopyWithImpl<ProviderMetadata, ProviderMetadata>(
        this as ProviderMetadata,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ProviderMetadataMapper.ensureInitialized().stringifyValue(
      this as ProviderMetadata,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProviderMetadataMapper.ensureInitialized().equalsValue(
      this as ProviderMetadata,
      other,
    );
  }

  @override
  int get hashCode {
    return ProviderMetadataMapper.ensureInitialized().hashValue(
      this as ProviderMetadata,
    );
  }
}

extension ProviderMetadataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProviderMetadata, $Out> {
  ProviderMetadataCopyWith<$R, ProviderMetadata, $Out>
  get $asProviderMetadata =>
      $base.as((v, t, t2) => _ProviderMetadataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProviderMetadataCopyWith<$R, $In extends ProviderMetadata, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? name,
    String? provider,
    String? type,
    String? color,
    String? icon,
  });
  ProviderMetadataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProviderMetadataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProviderMetadata, $Out>
    implements ProviderMetadataCopyWith<$R, ProviderMetadata, $Out> {
  _ProviderMetadataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProviderMetadata> $mapper =
      ProviderMetadataMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? name,
    String? provider,
    String? type,
    Object? color = $none,
    Object? icon = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (provider != null) #provider: provider,
      if (type != null) #type: type,
      if (color != $none) #color: color,
      if (icon != $none) #icon: icon,
    }),
  );
  @override
  ProviderMetadata $make(CopyWithData data) => ProviderMetadata(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    provider: data.get(#provider, or: $value.provider),
    type: data.get(#type, or: $value.type),
    color: data.get(#color, or: $value.color),
    icon: data.get(#icon, or: $value.icon),
  );

  @override
  ProviderMetadataCopyWith<$R2, ProviderMetadata, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProviderMetadataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

