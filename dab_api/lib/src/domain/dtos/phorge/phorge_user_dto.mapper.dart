// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_user_dto.dart';

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

class PhorgeUserDtoMapper extends ClassMapperBase<PhorgeUserDto> {
  PhorgeUserDtoMapper._();

  static PhorgeUserDtoMapper? _instance;
  static PhorgeUserDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeUserDtoMapper._());
      PhorgeUserWireFieldsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeUserDto';

  static String _$phid(PhorgeUserDto v) => v.phid;
  static const Field<PhorgeUserDto, String> _f$phid = Field('phid', _$phid);
  static PhorgeUserWireFields _$fields(PhorgeUserDto v) => v.fields;
  static const Field<PhorgeUserDto, PhorgeUserWireFields> _f$fields = Field(
    'fields',
    _$fields,
  );

  @override
  final MappableFields<PhorgeUserDto> fields = const {
    #phid: _f$phid,
    #fields: _f$fields,
  };

  static PhorgeUserDto _instantiate(DecodingData data) {
    return PhorgeUserDto(phid: data.dec(_f$phid), fields: data.dec(_f$fields));
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeUserDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeUserDto>(map);
  }

  static PhorgeUserDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeUserDto>(json);
  }
}

mixin PhorgeUserDtoMappable {
  String toJson() {
    return PhorgeUserDtoMapper.ensureInitialized().encodeJson<PhorgeUserDto>(
      this as PhorgeUserDto,
    );
  }

  Map<String, dynamic> toMap() {
    return PhorgeUserDtoMapper.ensureInitialized().encodeMap<PhorgeUserDto>(
      this as PhorgeUserDto,
    );
  }

  PhorgeUserDtoCopyWith<PhorgeUserDto, PhorgeUserDto, PhorgeUserDto>
  get copyWith => _PhorgeUserDtoCopyWithImpl<PhorgeUserDto, PhorgeUserDto>(
    this as PhorgeUserDto,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PhorgeUserDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeUserDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeUserDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeUserDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeUserDtoMapper.ensureInitialized().hashValue(
      this as PhorgeUserDto,
    );
  }
}

extension PhorgeUserDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeUserDto, $Out> {
  PhorgeUserDtoCopyWith<$R, PhorgeUserDto, $Out> get $asPhorgeUserDto =>
      $base.as((v, t, t2) => _PhorgeUserDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhorgeUserDtoCopyWith<$R, $In extends PhorgeUserDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeUserWireFieldsCopyWith<$R, PhorgeUserWireFields, PhorgeUserWireFields>
  get fields;
  $R call({String? phid, PhorgeUserWireFields? fields});
  PhorgeUserDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PhorgeUserDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeUserDto, $Out>
    implements PhorgeUserDtoCopyWith<$R, PhorgeUserDto, $Out> {
  _PhorgeUserDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeUserDto> $mapper =
      PhorgeUserDtoMapper.ensureInitialized();
  @override
  PhorgeUserWireFieldsCopyWith<$R, PhorgeUserWireFields, PhorgeUserWireFields>
  get fields => $value.fields.copyWith.$chain((v) => call(fields: v));
  @override
  $R call({String? phid, PhorgeUserWireFields? fields}) => $apply(
    FieldCopyWithData({
      if (phid != null) #phid: phid,
      if (fields != null) #fields: fields,
    }),
  );
  @override
  PhorgeUserDto $make(CopyWithData data) => PhorgeUserDto(
    phid: data.get(#phid, or: $value.phid),
    fields: data.get(#fields, or: $value.fields),
  );

  @override
  PhorgeUserDtoCopyWith<$R2, PhorgeUserDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeUserDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

