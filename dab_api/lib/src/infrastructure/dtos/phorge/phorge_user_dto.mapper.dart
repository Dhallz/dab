// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_user_dto.dart';

class PhorgeUserDtoMapper extends ClassMapperBase<PhorgeUserDto> {
  PhorgeUserDtoMapper._();

  static PhorgeUserDtoMapper? _instance;
  static PhorgeUserDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeUserDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeUserDto';

  static String _$phid(PhorgeUserDto v) => v.phid;
  static const Field<PhorgeUserDto, String> _f$phid = Field('phid', _$phid);
  static String _$userName(PhorgeUserDto v) => v.userName;
  static const Field<PhorgeUserDto, String> _f$userName = Field(
    'userName',
    _$userName,
  );
  static String? _$realName(PhorgeUserDto v) => v.realName;
  static const Field<PhorgeUserDto, String> _f$realName = Field(
    'realName',
    _$realName,
    opt: true,
  );

  @override
  final MappableFields<PhorgeUserDto> fields = const {
    #phid: _f$phid,
    #userName: _f$userName,
    #realName: _f$realName,
  };

  static PhorgeUserDto _instantiate(DecodingData data) {
    return PhorgeUserDto(
      phid: data.dec(_f$phid),
      userName: data.dec(_f$userName),
      realName: data.dec(_f$realName),
    );
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
  $R call({String? phid, String? userName, String? realName});
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
  $R call({String? phid, String? userName, Object? realName = $none}) => $apply(
    FieldCopyWithData({
      if (phid != null) #phid: phid,
      if (userName != null) #userName: userName,
      if (realName != $none) #realName: realName,
    }),
  );
  @override
  PhorgeUserDto $make(CopyWithData data) => PhorgeUserDto(
    phid: data.get(#phid, or: $value.phid),
    userName: data.get(#userName, or: $value.userName),
    realName: data.get(#realName, or: $value.realName),
  );

  @override
  PhorgeUserDtoCopyWith<$R2, PhorgeUserDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeUserDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

