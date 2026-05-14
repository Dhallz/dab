// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_revision_status_fields.dart';

class PhorgeRevisionStatusFieldsMapper
    extends ClassMapperBase<PhorgeRevisionStatusFields> {
  PhorgeRevisionStatusFieldsMapper._();

  static PhorgeRevisionStatusFieldsMapper? _instance;
  static PhorgeRevisionStatusFieldsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeRevisionStatusFieldsMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeRevisionStatusFields';

  static String _$name(PhorgeRevisionStatusFields v) => v.name;
  static const Field<PhorgeRevisionStatusFields, String> _f$name = Field(
    'name',
    _$name,
  );

  @override
  final MappableFields<PhorgeRevisionStatusFields> fields = const {
    #name: _f$name,
  };

  static PhorgeRevisionStatusFields _instantiate(DecodingData data) {
    return PhorgeRevisionStatusFields(name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeRevisionStatusFields fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeRevisionStatusFields>(map);
  }

  static PhorgeRevisionStatusFields fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeRevisionStatusFields>(json);
  }
}

mixin PhorgeRevisionStatusFieldsMappable {
  String toJson() {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized()
        .encodeJson<PhorgeRevisionStatusFields>(
          this as PhorgeRevisionStatusFields,
        );
  }

  Map<String, dynamic> toMap() {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized()
        .encodeMap<PhorgeRevisionStatusFields>(
          this as PhorgeRevisionStatusFields,
        );
  }

  PhorgeRevisionStatusFieldsCopyWith<
    PhorgeRevisionStatusFields,
    PhorgeRevisionStatusFields,
    PhorgeRevisionStatusFields
  >
  get copyWith =>
      _PhorgeRevisionStatusFieldsCopyWithImpl<
        PhorgeRevisionStatusFields,
        PhorgeRevisionStatusFields
      >(this as PhorgeRevisionStatusFields, $identity, $identity);
  @override
  String toString() {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized().stringifyValue(
      this as PhorgeRevisionStatusFields,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized().equalsValue(
      this as PhorgeRevisionStatusFields,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized().hashValue(
      this as PhorgeRevisionStatusFields,
    );
  }
}

extension PhorgeRevisionStatusFieldsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeRevisionStatusFields, $Out> {
  PhorgeRevisionStatusFieldsCopyWith<$R, PhorgeRevisionStatusFields, $Out>
  get $asPhorgeRevisionStatusFields => $base.as(
    (v, t, t2) => _PhorgeRevisionStatusFieldsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeRevisionStatusFieldsCopyWith<
  $R,
  $In extends PhorgeRevisionStatusFields,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name});
  PhorgeRevisionStatusFieldsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeRevisionStatusFieldsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeRevisionStatusFields, $Out>
    implements
        PhorgeRevisionStatusFieldsCopyWith<
          $R,
          PhorgeRevisionStatusFields,
          $Out
        > {
  _PhorgeRevisionStatusFieldsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeRevisionStatusFields> $mapper =
      PhorgeRevisionStatusFieldsMapper.ensureInitialized();
  @override
  $R call({String? name}) =>
      $apply(FieldCopyWithData({if (name != null) #name: name}));
  @override
  PhorgeRevisionStatusFields $make(CopyWithData data) =>
      PhorgeRevisionStatusFields(name: data.get(#name, or: $value.name));

  @override
  PhorgeRevisionStatusFieldsCopyWith<$R2, PhorgeRevisionStatusFields, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeRevisionStatusFieldsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

