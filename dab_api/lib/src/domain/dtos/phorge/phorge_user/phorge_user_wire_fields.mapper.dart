// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_user_wire_fields.dart';

class PhorgeUserWireFieldsMapper extends ClassMapperBase<PhorgeUserWireFields> {
  PhorgeUserWireFieldsMapper._();

  static PhorgeUserWireFieldsMapper? _instance;
  static PhorgeUserWireFieldsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeUserWireFieldsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeUserWireFields';

  static String _$username(PhorgeUserWireFields v) => v.username;
  static const Field<PhorgeUserWireFields, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$realName(PhorgeUserWireFields v) => v.realName;
  static const Field<PhorgeUserWireFields, String> _f$realName = Field(
    'realName',
    _$realName,
    opt: true,
  );

  @override
  final MappableFields<PhorgeUserWireFields> fields = const {
    #username: _f$username,
    #realName: _f$realName,
  };

  static PhorgeUserWireFields _instantiate(DecodingData data) {
    return PhorgeUserWireFields(
      username: data.dec(_f$username),
      realName: data.dec(_f$realName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeUserWireFields fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeUserWireFields>(map);
  }

  static PhorgeUserWireFields fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeUserWireFields>(json);
  }
}

mixin PhorgeUserWireFieldsMappable {
  String toJson() {
    return PhorgeUserWireFieldsMapper.ensureInitialized()
        .encodeJson<PhorgeUserWireFields>(this as PhorgeUserWireFields);
  }

  Map<String, dynamic> toMap() {
    return PhorgeUserWireFieldsMapper.ensureInitialized()
        .encodeMap<PhorgeUserWireFields>(this as PhorgeUserWireFields);
  }

  PhorgeUserWireFieldsCopyWith<
    PhorgeUserWireFields,
    PhorgeUserWireFields,
    PhorgeUserWireFields
  >
  get copyWith =>
      _PhorgeUserWireFieldsCopyWithImpl<
        PhorgeUserWireFields,
        PhorgeUserWireFields
      >(this as PhorgeUserWireFields, $identity, $identity);
  @override
  String toString() {
    return PhorgeUserWireFieldsMapper.ensureInitialized().stringifyValue(
      this as PhorgeUserWireFields,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeUserWireFieldsMapper.ensureInitialized().equalsValue(
      this as PhorgeUserWireFields,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeUserWireFieldsMapper.ensureInitialized().hashValue(
      this as PhorgeUserWireFields,
    );
  }
}

extension PhorgeUserWireFieldsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeUserWireFields, $Out> {
  PhorgeUserWireFieldsCopyWith<$R, PhorgeUserWireFields, $Out>
  get $asPhorgeUserWireFields => $base.as(
    (v, t, t2) => _PhorgeUserWireFieldsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeUserWireFieldsCopyWith<
  $R,
  $In extends PhorgeUserWireFields,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? username, String? realName});
  PhorgeUserWireFieldsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeUserWireFieldsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeUserWireFields, $Out>
    implements PhorgeUserWireFieldsCopyWith<$R, PhorgeUserWireFields, $Out> {
  _PhorgeUserWireFieldsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeUserWireFields> $mapper =
      PhorgeUserWireFieldsMapper.ensureInitialized();
  @override
  $R call({String? username, Object? realName = $none}) => $apply(
    FieldCopyWithData({
      if (username != null) #username: username,
      if (realName != $none) #realName: realName,
    }),
  );
  @override
  PhorgeUserWireFields $make(CopyWithData data) => PhorgeUserWireFields(
    username: data.get(#username, or: $value.username),
    realName: data.get(#realName, or: $value.realName),
  );

  @override
  PhorgeUserWireFieldsCopyWith<$R2, PhorgeUserWireFields, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeUserWireFieldsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

