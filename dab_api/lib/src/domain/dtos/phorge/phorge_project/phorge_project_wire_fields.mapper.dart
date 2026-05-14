// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_project_wire_fields.dart';

class PhorgeProjectWireFieldsMapper
    extends ClassMapperBase<PhorgeProjectWireFields> {
  PhorgeProjectWireFieldsMapper._();

  static PhorgeProjectWireFieldsMapper? _instance;
  static PhorgeProjectWireFieldsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeProjectWireFieldsMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeProjectWireFields';

  static String _$name(PhorgeProjectWireFields v) => v.name;
  static const Field<PhorgeProjectWireFields, String> _f$name = Field(
    'name',
    _$name,
    hook: PhorgeProjectWireDefaultStringHook('Unknown'),
  );
  static Object? _$color(PhorgeProjectWireFields v) => v.color;
  static const Field<PhorgeProjectWireFields, Object> _f$color = Field(
    'color',
    _$color,
    opt: true,
  );
  static Object? _$icon(PhorgeProjectWireFields v) => v.icon;
  static const Field<PhorgeProjectWireFields, Object> _f$icon = Field(
    'icon',
    _$icon,
    opt: true,
  );

  @override
  final MappableFields<PhorgeProjectWireFields> fields = const {
    #name: _f$name,
    #color: _f$color,
    #icon: _f$icon,
  };

  static PhorgeProjectWireFields _instantiate(DecodingData data) {
    return PhorgeProjectWireFields(
      name: data.dec(_f$name),
      color: data.dec(_f$color),
      icon: data.dec(_f$icon),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeProjectWireFields fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeProjectWireFields>(map);
  }

  static PhorgeProjectWireFields fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeProjectWireFields>(json);
  }
}

mixin PhorgeProjectWireFieldsMappable {
  String toJson() {
    return PhorgeProjectWireFieldsMapper.ensureInitialized()
        .encodeJson<PhorgeProjectWireFields>(this as PhorgeProjectWireFields);
  }

  Map<String, dynamic> toMap() {
    return PhorgeProjectWireFieldsMapper.ensureInitialized()
        .encodeMap<PhorgeProjectWireFields>(this as PhorgeProjectWireFields);
  }

  PhorgeProjectWireFieldsCopyWith<
    PhorgeProjectWireFields,
    PhorgeProjectWireFields,
    PhorgeProjectWireFields
  >
  get copyWith =>
      _PhorgeProjectWireFieldsCopyWithImpl<
        PhorgeProjectWireFields,
        PhorgeProjectWireFields
      >(this as PhorgeProjectWireFields, $identity, $identity);
  @override
  String toString() {
    return PhorgeProjectWireFieldsMapper.ensureInitialized().stringifyValue(
      this as PhorgeProjectWireFields,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeProjectWireFieldsMapper.ensureInitialized().equalsValue(
      this as PhorgeProjectWireFields,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeProjectWireFieldsMapper.ensureInitialized().hashValue(
      this as PhorgeProjectWireFields,
    );
  }
}

extension PhorgeProjectWireFieldsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeProjectWireFields, $Out> {
  PhorgeProjectWireFieldsCopyWith<$R, PhorgeProjectWireFields, $Out>
  get $asPhorgeProjectWireFields => $base.as(
    (v, t, t2) => _PhorgeProjectWireFieldsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeProjectWireFieldsCopyWith<
  $R,
  $In extends PhorgeProjectWireFields,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, Object? color, Object? icon});
  PhorgeProjectWireFieldsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeProjectWireFieldsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeProjectWireFields, $Out>
    implements
        PhorgeProjectWireFieldsCopyWith<$R, PhorgeProjectWireFields, $Out> {
  _PhorgeProjectWireFieldsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeProjectWireFields> $mapper =
      PhorgeProjectWireFieldsMapper.ensureInitialized();
  @override
  $R call({String? name, Object? color = $none, Object? icon = $none}) =>
      $apply(
        FieldCopyWithData({
          if (name != null) #name: name,
          if (color != $none) #color: color,
          if (icon != $none) #icon: icon,
        }),
      );
  @override
  PhorgeProjectWireFields $make(CopyWithData data) => PhorgeProjectWireFields(
    name: data.get(#name, or: $value.name),
    color: data.get(#color, or: $value.color),
    icon: data.get(#icon, or: $value.icon),
  );

  @override
  PhorgeProjectWireFieldsCopyWith<$R2, PhorgeProjectWireFields, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeProjectWireFieldsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

