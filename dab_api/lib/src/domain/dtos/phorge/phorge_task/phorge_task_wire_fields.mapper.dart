// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_wire_fields.dart';

class PhorgeTaskWireFieldsMapper extends ClassMapperBase<PhorgeTaskWireFields> {
  PhorgeTaskWireFieldsMapper._();

  static PhorgeTaskWireFieldsMapper? _instance;
  static PhorgeTaskWireFieldsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTaskWireFieldsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskWireFields';

  static String _$name(PhorgeTaskWireFields v) => v.name;
  static const Field<PhorgeTaskWireFields, String> _f$name = Field(
    'name',
    _$name,
    hook: PhorgeTaskWireDefaultStringHook('Unknown'),
  );
  static String _$uri(PhorgeTaskWireFields v) => v.uri;
  static const Field<PhorgeTaskWireFields, String> _f$uri = Field(
    'uri',
    _$uri,
    hook: PhorgeTaskWireDefaultStringHook(''),
  );
  static String _$ownerPHID(PhorgeTaskWireFields v) => v.ownerPHID;
  static const Field<PhorgeTaskWireFields, String> _f$ownerPHID = Field(
    'ownerPHID',
    _$ownerPHID,
    hook: PhorgeTaskWireDefaultStringHook('system'),
  );
  static int? _$dateModified(PhorgeTaskWireFields v) => v.dateModified;
  static const Field<PhorgeTaskWireFields, int> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
    opt: true,
  );

  @override
  final MappableFields<PhorgeTaskWireFields> fields = const {
    #name: _f$name,
    #uri: _f$uri,
    #ownerPHID: _f$ownerPHID,
    #dateModified: _f$dateModified,
  };

  static PhorgeTaskWireFields _instantiate(DecodingData data) {
    return PhorgeTaskWireFields(
      name: data.dec(_f$name),
      uri: data.dec(_f$uri),
      ownerPHID: data.dec(_f$ownerPHID),
      dateModified: data.dec(_f$dateModified),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskWireFields fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskWireFields>(map);
  }

  static PhorgeTaskWireFields fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskWireFields>(json);
  }
}

mixin PhorgeTaskWireFieldsMappable {
  String toJson() {
    return PhorgeTaskWireFieldsMapper.ensureInitialized()
        .encodeJson<PhorgeTaskWireFields>(this as PhorgeTaskWireFields);
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskWireFieldsMapper.ensureInitialized()
        .encodeMap<PhorgeTaskWireFields>(this as PhorgeTaskWireFields);
  }

  PhorgeTaskWireFieldsCopyWith<
    PhorgeTaskWireFields,
    PhorgeTaskWireFields,
    PhorgeTaskWireFields
  >
  get copyWith =>
      _PhorgeTaskWireFieldsCopyWithImpl<
        PhorgeTaskWireFields,
        PhorgeTaskWireFields
      >(this as PhorgeTaskWireFields, $identity, $identity);
  @override
  String toString() {
    return PhorgeTaskWireFieldsMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskWireFields,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskWireFieldsMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskWireFields,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskWireFieldsMapper.ensureInitialized().hashValue(
      this as PhorgeTaskWireFields,
    );
  }
}

extension PhorgeTaskWireFieldsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskWireFields, $Out> {
  PhorgeTaskWireFieldsCopyWith<$R, PhorgeTaskWireFields, $Out>
  get $asPhorgeTaskWireFields => $base.as(
    (v, t, t2) => _PhorgeTaskWireFieldsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskWireFieldsCopyWith<
  $R,
  $In extends PhorgeTaskWireFields,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? uri, String? ownerPHID, int? dateModified});
  PhorgeTaskWireFieldsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskWireFieldsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskWireFields, $Out>
    implements PhorgeTaskWireFieldsCopyWith<$R, PhorgeTaskWireFields, $Out> {
  _PhorgeTaskWireFieldsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskWireFields> $mapper =
      PhorgeTaskWireFieldsMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    String? uri,
    String? ownerPHID,
    Object? dateModified = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (uri != null) #uri: uri,
      if (ownerPHID != null) #ownerPHID: ownerPHID,
      if (dateModified != $none) #dateModified: dateModified,
    }),
  );
  @override
  PhorgeTaskWireFields $make(CopyWithData data) => PhorgeTaskWireFields(
    name: data.get(#name, or: $value.name),
    uri: data.get(#uri, or: $value.uri),
    ownerPHID: data.get(#ownerPHID, or: $value.ownerPHID),
    dateModified: data.get(#dateModified, or: $value.dateModified),
  );

  @override
  PhorgeTaskWireFieldsCopyWith<$R2, PhorgeTaskWireFields, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTaskWireFieldsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

