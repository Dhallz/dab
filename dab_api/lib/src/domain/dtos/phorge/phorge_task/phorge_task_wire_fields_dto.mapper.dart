// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_wire_fields_dto.dart';

class PhorgeTaskWireFieldsDtoMapper
    extends ClassMapperBase<PhorgeTaskWireFieldsDto> {
  PhorgeTaskWireFieldsDtoMapper._();

  static PhorgeTaskWireFieldsDtoMapper? _instance;
  static PhorgeTaskWireFieldsDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeTaskWireFieldsDtoMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskWireFieldsDto';

  static String? _$title(PhorgeTaskWireFieldsDto v) => v.title;
  static const Field<PhorgeTaskWireFieldsDto, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$name(PhorgeTaskWireFieldsDto v) => v.name;
  static const Field<PhorgeTaskWireFieldsDto, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static String? _$uri(PhorgeTaskWireFieldsDto v) => v.uri;
  static const Field<PhorgeTaskWireFieldsDto, String> _f$uri = Field(
    'uri',
    _$uri,
    opt: true,
  );
  static String? _$ownerPHID(PhorgeTaskWireFieldsDto v) => v.ownerPHID;
  static const Field<PhorgeTaskWireFieldsDto, String> _f$ownerPHID = Field(
    'ownerPHID',
    _$ownerPHID,
    opt: true,
  );
  static int? _$dateModified(PhorgeTaskWireFieldsDto v) => v.dateModified;
  static const Field<PhorgeTaskWireFieldsDto, int> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
    opt: true,
  );

  @override
  final MappableFields<PhorgeTaskWireFieldsDto> fields = const {
    #title: _f$title,
    #name: _f$name,
    #uri: _f$uri,
    #ownerPHID: _f$ownerPHID,
    #dateModified: _f$dateModified,
  };

  static PhorgeTaskWireFieldsDto _instantiate(DecodingData data) {
    return PhorgeTaskWireFieldsDto(
      title: data.dec(_f$title),
      name: data.dec(_f$name),
      uri: data.dec(_f$uri),
      ownerPHID: data.dec(_f$ownerPHID),
      dateModified: data.dec(_f$dateModified),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskWireFieldsDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskWireFieldsDto>(map);
  }

  static PhorgeTaskWireFieldsDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskWireFieldsDto>(json);
  }
}

mixin PhorgeTaskWireFieldsDtoMappable {
  String toJson() {
    return PhorgeTaskWireFieldsDtoMapper.ensureInitialized()
        .encodeJson<PhorgeTaskWireFieldsDto>(this as PhorgeTaskWireFieldsDto);
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskWireFieldsDtoMapper.ensureInitialized()
        .encodeMap<PhorgeTaskWireFieldsDto>(this as PhorgeTaskWireFieldsDto);
  }

  PhorgeTaskWireFieldsDtoCopyWith<
    PhorgeTaskWireFieldsDto,
    PhorgeTaskWireFieldsDto,
    PhorgeTaskWireFieldsDto
  >
  get copyWith =>
      _PhorgeTaskWireFieldsDtoCopyWithImpl<
        PhorgeTaskWireFieldsDto,
        PhorgeTaskWireFieldsDto
      >(this as PhorgeTaskWireFieldsDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeTaskWireFieldsDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskWireFieldsDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskWireFieldsDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskWireFieldsDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskWireFieldsDtoMapper.ensureInitialized().hashValue(
      this as PhorgeTaskWireFieldsDto,
    );
  }
}

extension PhorgeTaskWireFieldsDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskWireFieldsDto, $Out> {
  PhorgeTaskWireFieldsDtoCopyWith<$R, PhorgeTaskWireFieldsDto, $Out>
  get $asPhorgeTaskWireFieldsDto => $base.as(
    (v, t, t2) => _PhorgeTaskWireFieldsDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskWireFieldsDtoCopyWith<
  $R,
  $In extends PhorgeTaskWireFieldsDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? title,
    String? name,
    String? uri,
    String? ownerPHID,
    int? dateModified,
  });
  PhorgeTaskWireFieldsDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskWireFieldsDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskWireFieldsDto, $Out>
    implements
        PhorgeTaskWireFieldsDtoCopyWith<$R, PhorgeTaskWireFieldsDto, $Out> {
  _PhorgeTaskWireFieldsDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskWireFieldsDto> $mapper =
      PhorgeTaskWireFieldsDtoMapper.ensureInitialized();
  @override
  $R call({
    Object? title = $none,
    Object? name = $none,
    Object? uri = $none,
    Object? ownerPHID = $none,
    Object? dateModified = $none,
  }) => $apply(
    FieldCopyWithData({
      if (title != $none) #title: title,
      if (name != $none) #name: name,
      if (uri != $none) #uri: uri,
      if (ownerPHID != $none) #ownerPHID: ownerPHID,
      if (dateModified != $none) #dateModified: dateModified,
    }),
  );
  @override
  PhorgeTaskWireFieldsDto $make(CopyWithData data) => PhorgeTaskWireFieldsDto(
    title: data.get(#title, or: $value.title),
    name: data.get(#name, or: $value.name),
    uri: data.get(#uri, or: $value.uri),
    ownerPHID: data.get(#ownerPHID, or: $value.ownerPHID),
    dateModified: data.get(#dateModified, or: $value.dateModified),
  );

  @override
  PhorgeTaskWireFieldsDtoCopyWith<$R2, PhorgeTaskWireFieldsDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTaskWireFieldsDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

