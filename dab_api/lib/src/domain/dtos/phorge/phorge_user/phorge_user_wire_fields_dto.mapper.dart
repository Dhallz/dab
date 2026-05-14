// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_user_wire_fields_dto.dart';

class PhorgeUserWireFieldsDtoMapper
    extends ClassMapperBase<PhorgeUserWireFieldsDto> {
  PhorgeUserWireFieldsDtoMapper._();

  static PhorgeUserWireFieldsDtoMapper? _instance;
  static PhorgeUserWireFieldsDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeUserWireFieldsDtoMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeUserWireFieldsDto';

  static String _$username(PhorgeUserWireFieldsDto v) => v.username;
  static const Field<PhorgeUserWireFieldsDto, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$realName(PhorgeUserWireFieldsDto v) => v.realName;
  static const Field<PhorgeUserWireFieldsDto, String> _f$realName = Field(
    'realName',
    _$realName,
    opt: true,
  );

  @override
  final MappableFields<PhorgeUserWireFieldsDto> fields = const {
    #username: _f$username,
    #realName: _f$realName,
  };

  static PhorgeUserWireFieldsDto _instantiate(DecodingData data) {
    return PhorgeUserWireFieldsDto(
      username: data.dec(_f$username),
      realName: data.dec(_f$realName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeUserWireFieldsDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeUserWireFieldsDto>(map);
  }

  static PhorgeUserWireFieldsDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeUserWireFieldsDto>(json);
  }
}

mixin PhorgeUserWireFieldsDtoMappable {
  String toJson() {
    return PhorgeUserWireFieldsDtoMapper.ensureInitialized()
        .encodeJson<PhorgeUserWireFieldsDto>(this as PhorgeUserWireFieldsDto);
  }

  Map<String, dynamic> toMap() {
    return PhorgeUserWireFieldsDtoMapper.ensureInitialized()
        .encodeMap<PhorgeUserWireFieldsDto>(this as PhorgeUserWireFieldsDto);
  }

  PhorgeUserWireFieldsDtoCopyWith<
    PhorgeUserWireFieldsDto,
    PhorgeUserWireFieldsDto,
    PhorgeUserWireFieldsDto
  >
  get copyWith =>
      _PhorgeUserWireFieldsDtoCopyWithImpl<
        PhorgeUserWireFieldsDto,
        PhorgeUserWireFieldsDto
      >(this as PhorgeUserWireFieldsDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeUserWireFieldsDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeUserWireFieldsDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeUserWireFieldsDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeUserWireFieldsDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeUserWireFieldsDtoMapper.ensureInitialized().hashValue(
      this as PhorgeUserWireFieldsDto,
    );
  }
}

extension PhorgeUserWireFieldsDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeUserWireFieldsDto, $Out> {
  PhorgeUserWireFieldsDtoCopyWith<$R, PhorgeUserWireFieldsDto, $Out>
  get $asPhorgeUserWireFieldsDto => $base.as(
    (v, t, t2) => _PhorgeUserWireFieldsDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeUserWireFieldsDtoCopyWith<
  $R,
  $In extends PhorgeUserWireFieldsDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? username, String? realName});
  PhorgeUserWireFieldsDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeUserWireFieldsDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeUserWireFieldsDto, $Out>
    implements
        PhorgeUserWireFieldsDtoCopyWith<$R, PhorgeUserWireFieldsDto, $Out> {
  _PhorgeUserWireFieldsDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeUserWireFieldsDto> $mapper =
      PhorgeUserWireFieldsDtoMapper.ensureInitialized();
  @override
  $R call({String? username, Object? realName = $none}) => $apply(
    FieldCopyWithData({
      if (username != null) #username: username,
      if (realName != $none) #realName: realName,
    }),
  );
  @override
  PhorgeUserWireFieldsDto $make(CopyWithData data) => PhorgeUserWireFieldsDto(
    username: data.get(#username, or: $value.username),
    realName: data.get(#realName, or: $value.realName),
  );

  @override
  PhorgeUserWireFieldsDtoCopyWith<$R2, PhorgeUserWireFieldsDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeUserWireFieldsDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

