// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_revision_dto.dart';

class PhorgeRevisionDtoMapper extends ClassMapperBase<PhorgeRevisionDto> {
  PhorgeRevisionDtoMapper._();

  static PhorgeRevisionDtoMapper? _instance;
  static PhorgeRevisionDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeRevisionDtoMapper._());
      PhorgeRevisionFieldsDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeRevisionDto';

  static int _$id(PhorgeRevisionDto v) => v.id;
  static const Field<PhorgeRevisionDto, int> _f$id = Field('id', _$id);
  static String _$phid(PhorgeRevisionDto v) => v.phid;
  static const Field<PhorgeRevisionDto, String> _f$phid = Field('phid', _$phid);
  static PhorgeRevisionFieldsDto _$fields(PhorgeRevisionDto v) => v.fields;
  static const Field<PhorgeRevisionDto, PhorgeRevisionFieldsDto> _f$fields =
      Field('fields', _$fields);

  @override
  final MappableFields<PhorgeRevisionDto> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #fields: _f$fields,
  };

  static PhorgeRevisionDto _instantiate(DecodingData data) {
    return PhorgeRevisionDto(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      fields: data.dec(_f$fields),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeRevisionDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeRevisionDto>(map);
  }

  static PhorgeRevisionDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeRevisionDto>(json);
  }
}

mixin PhorgeRevisionDtoMappable {
  String toJson() {
    return PhorgeRevisionDtoMapper.ensureInitialized()
        .encodeJson<PhorgeRevisionDto>(this as PhorgeRevisionDto);
  }

  Map<String, dynamic> toMap() {
    return PhorgeRevisionDtoMapper.ensureInitialized()
        .encodeMap<PhorgeRevisionDto>(this as PhorgeRevisionDto);
  }

  PhorgeRevisionDtoCopyWith<
    PhorgeRevisionDto,
    PhorgeRevisionDto,
    PhorgeRevisionDto
  >
  get copyWith =>
      _PhorgeRevisionDtoCopyWithImpl<PhorgeRevisionDto, PhorgeRevisionDto>(
        this as PhorgeRevisionDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhorgeRevisionDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeRevisionDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeRevisionDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeRevisionDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeRevisionDtoMapper.ensureInitialized().hashValue(
      this as PhorgeRevisionDto,
    );
  }
}

extension PhorgeRevisionDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeRevisionDto, $Out> {
  PhorgeRevisionDtoCopyWith<$R, PhorgeRevisionDto, $Out>
  get $asPhorgeRevisionDto => $base.as(
    (v, t, t2) => _PhorgeRevisionDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeRevisionDtoCopyWith<
  $R,
  $In extends PhorgeRevisionDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeRevisionFieldsDtoCopyWith<
    $R,
    PhorgeRevisionFieldsDto,
    PhorgeRevisionFieldsDto
  >
  get fields;
  $R call({int? id, String? phid, PhorgeRevisionFieldsDto? fields});
  PhorgeRevisionDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeRevisionDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeRevisionDto, $Out>
    implements PhorgeRevisionDtoCopyWith<$R, PhorgeRevisionDto, $Out> {
  _PhorgeRevisionDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeRevisionDto> $mapper =
      PhorgeRevisionDtoMapper.ensureInitialized();
  @override
  PhorgeRevisionFieldsDtoCopyWith<
    $R,
    PhorgeRevisionFieldsDto,
    PhorgeRevisionFieldsDto
  >
  get fields => $value.fields.copyWith.$chain((v) => call(fields: v));
  @override
  $R call({int? id, String? phid, PhorgeRevisionFieldsDto? fields}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (fields != null) #fields: fields,
    }),
  );
  @override
  PhorgeRevisionDto $make(CopyWithData data) => PhorgeRevisionDto(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    fields: data.get(#fields, or: $value.fields),
  );

  @override
  PhorgeRevisionDtoCopyWith<$R2, PhorgeRevisionDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeRevisionDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

