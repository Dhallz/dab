// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_revision_status_fields_dto.dart';

class PhorgeRevisionStatusFieldsDtoMapper
    extends ClassMapperBase<PhorgeRevisionStatusFieldsDto> {
  PhorgeRevisionStatusFieldsDtoMapper._();

  static PhorgeRevisionStatusFieldsDtoMapper? _instance;
  static PhorgeRevisionStatusFieldsDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeRevisionStatusFieldsDtoMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeRevisionStatusFieldsDto';

  static String _$name(PhorgeRevisionStatusFieldsDto v) => v.name;
  static const Field<PhorgeRevisionStatusFieldsDto, String> _f$name = Field(
    'name',
    _$name,
  );

  @override
  final MappableFields<PhorgeRevisionStatusFieldsDto> fields = const {
    #name: _f$name,
  };

  static PhorgeRevisionStatusFieldsDto _instantiate(DecodingData data) {
    return PhorgeRevisionStatusFieldsDto(name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeRevisionStatusFieldsDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeRevisionStatusFieldsDto>(map);
  }

  static PhorgeRevisionStatusFieldsDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeRevisionStatusFieldsDto>(json);
  }
}

mixin PhorgeRevisionStatusFieldsDtoMappable {
  String toJson() {
    return PhorgeRevisionStatusFieldsDtoMapper.ensureInitialized()
        .encodeJson<PhorgeRevisionStatusFieldsDto>(
          this as PhorgeRevisionStatusFieldsDto,
        );
  }

  Map<String, dynamic> toMap() {
    return PhorgeRevisionStatusFieldsDtoMapper.ensureInitialized()
        .encodeMap<PhorgeRevisionStatusFieldsDto>(
          this as PhorgeRevisionStatusFieldsDto,
        );
  }

  PhorgeRevisionStatusFieldsDtoCopyWith<
    PhorgeRevisionStatusFieldsDto,
    PhorgeRevisionStatusFieldsDto,
    PhorgeRevisionStatusFieldsDto
  >
  get copyWith =>
      _PhorgeRevisionStatusFieldsDtoCopyWithImpl<
        PhorgeRevisionStatusFieldsDto,
        PhorgeRevisionStatusFieldsDto
      >(this as PhorgeRevisionStatusFieldsDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeRevisionStatusFieldsDtoMapper.ensureInitialized()
        .stringifyValue(this as PhorgeRevisionStatusFieldsDto);
  }

  @override
  bool operator ==(Object other) {
    return PhorgeRevisionStatusFieldsDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeRevisionStatusFieldsDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeRevisionStatusFieldsDtoMapper.ensureInitialized().hashValue(
      this as PhorgeRevisionStatusFieldsDto,
    );
  }
}

extension PhorgeRevisionStatusFieldsDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeRevisionStatusFieldsDto, $Out> {
  PhorgeRevisionStatusFieldsDtoCopyWith<$R, PhorgeRevisionStatusFieldsDto, $Out>
  get $asPhorgeRevisionStatusFieldsDto => $base.as(
    (v, t, t2) =>
        _PhorgeRevisionStatusFieldsDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeRevisionStatusFieldsDtoCopyWith<
  $R,
  $In extends PhorgeRevisionStatusFieldsDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name});
  PhorgeRevisionStatusFieldsDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeRevisionStatusFieldsDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeRevisionStatusFieldsDto, $Out>
    implements
        PhorgeRevisionStatusFieldsDtoCopyWith<
          $R,
          PhorgeRevisionStatusFieldsDto,
          $Out
        > {
  _PhorgeRevisionStatusFieldsDtoCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PhorgeRevisionStatusFieldsDto> $mapper =
      PhorgeRevisionStatusFieldsDtoMapper.ensureInitialized();
  @override
  $R call({String? name}) =>
      $apply(FieldCopyWithData({if (name != null) #name: name}));
  @override
  PhorgeRevisionStatusFieldsDto $make(CopyWithData data) =>
      PhorgeRevisionStatusFieldsDto(name: data.get(#name, or: $value.name));

  @override
  PhorgeRevisionStatusFieldsDtoCopyWith<
    $R2,
    PhorgeRevisionStatusFieldsDto,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeRevisionStatusFieldsDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

