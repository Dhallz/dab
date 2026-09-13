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
      PhorgeUserWireFieldsDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeUserDto';

  static String _$phid(PhorgeUserDto v) => v.phid;
  static const Field<PhorgeUserDto, String> _f$phid = Field('phid', _$phid);
  static PhorgeUserWireFieldsDto _$fields(PhorgeUserDto v) => v.fields;
  static const Field<PhorgeUserDto, PhorgeUserWireFieldsDto> _f$fields = Field(
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
  PhorgeUserWireFieldsDtoCopyWith<
    $R,
    PhorgeUserWireFieldsDto,
    PhorgeUserWireFieldsDto
  >
  get fields;
  $R call({String? phid, PhorgeUserWireFieldsDto? fields});
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
  PhorgeUserWireFieldsDtoCopyWith<
    $R,
    PhorgeUserWireFieldsDto,
    PhorgeUserWireFieldsDto
  >
  get fields => $value.fields.copyWith.$chain((v) => call(fields: v));
  @override
  $R call({String? phid, PhorgeUserWireFieldsDto? fields}) => $apply(
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

