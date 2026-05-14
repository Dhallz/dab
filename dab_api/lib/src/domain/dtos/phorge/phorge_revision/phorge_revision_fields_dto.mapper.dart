// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_revision_fields_dto.dart';

class PhorgeRevisionFieldsDtoMapper
    extends ClassMapperBase<PhorgeRevisionFieldsDto> {
  PhorgeRevisionFieldsDtoMapper._();

  static PhorgeRevisionFieldsDtoMapper? _instance;
  static PhorgeRevisionFieldsDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeRevisionFieldsDtoMapper._(),
      );
      PhorgeRevisionStatusFieldsDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeRevisionFieldsDto';

  static String _$authorPHID(PhorgeRevisionFieldsDto v) => v.authorPHID;
  static const Field<PhorgeRevisionFieldsDto, String> _f$authorPHID = Field(
    'authorPHID',
    _$authorPHID,
  );
  static String _$title(PhorgeRevisionFieldsDto v) => v.title;
  static const Field<PhorgeRevisionFieldsDto, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$uri(PhorgeRevisionFieldsDto v) => v.uri;
  static const Field<PhorgeRevisionFieldsDto, String> _f$uri = Field(
    'uri',
    _$uri,
  );
  static int _$dateModified(PhorgeRevisionFieldsDto v) => v.dateModified;
  static const Field<PhorgeRevisionFieldsDto, int> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
  );
  static PhorgeRevisionStatusFieldsDto _$status(PhorgeRevisionFieldsDto v) =>
      v.status;
  static const Field<PhorgeRevisionFieldsDto, PhorgeRevisionStatusFieldsDto>
  _f$status = Field('status', _$status);

  @override
  final MappableFields<PhorgeRevisionFieldsDto> fields = const {
    #authorPHID: _f$authorPHID,
    #title: _f$title,
    #uri: _f$uri,
    #dateModified: _f$dateModified,
    #status: _f$status,
  };

  static PhorgeRevisionFieldsDto _instantiate(DecodingData data) {
    return PhorgeRevisionFieldsDto(
      authorPHID: data.dec(_f$authorPHID),
      title: data.dec(_f$title),
      uri: data.dec(_f$uri),
      dateModified: data.dec(_f$dateModified),
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeRevisionFieldsDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeRevisionFieldsDto>(map);
  }

  static PhorgeRevisionFieldsDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeRevisionFieldsDto>(json);
  }
}

mixin PhorgeRevisionFieldsDtoMappable {
  String toJson() {
    return PhorgeRevisionFieldsDtoMapper.ensureInitialized()
        .encodeJson<PhorgeRevisionFieldsDto>(this as PhorgeRevisionFieldsDto);
  }

  Map<String, dynamic> toMap() {
    return PhorgeRevisionFieldsDtoMapper.ensureInitialized()
        .encodeMap<PhorgeRevisionFieldsDto>(this as PhorgeRevisionFieldsDto);
  }

  PhorgeRevisionFieldsDtoCopyWith<
    PhorgeRevisionFieldsDto,
    PhorgeRevisionFieldsDto,
    PhorgeRevisionFieldsDto
  >
  get copyWith =>
      _PhorgeRevisionFieldsDtoCopyWithImpl<
        PhorgeRevisionFieldsDto,
        PhorgeRevisionFieldsDto
      >(this as PhorgeRevisionFieldsDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeRevisionFieldsDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeRevisionFieldsDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeRevisionFieldsDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeRevisionFieldsDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeRevisionFieldsDtoMapper.ensureInitialized().hashValue(
      this as PhorgeRevisionFieldsDto,
    );
  }
}

extension PhorgeRevisionFieldsDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeRevisionFieldsDto, $Out> {
  PhorgeRevisionFieldsDtoCopyWith<$R, PhorgeRevisionFieldsDto, $Out>
  get $asPhorgeRevisionFieldsDto => $base.as(
    (v, t, t2) => _PhorgeRevisionFieldsDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeRevisionFieldsDtoCopyWith<
  $R,
  $In extends PhorgeRevisionFieldsDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeRevisionStatusFieldsDtoCopyWith<
    $R,
    PhorgeRevisionStatusFieldsDto,
    PhorgeRevisionStatusFieldsDto
  >
  get status;
  $R call({
    String? authorPHID,
    String? title,
    String? uri,
    int? dateModified,
    PhorgeRevisionStatusFieldsDto? status,
  });
  PhorgeRevisionFieldsDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeRevisionFieldsDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeRevisionFieldsDto, $Out>
    implements
        PhorgeRevisionFieldsDtoCopyWith<$R, PhorgeRevisionFieldsDto, $Out> {
  _PhorgeRevisionFieldsDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeRevisionFieldsDto> $mapper =
      PhorgeRevisionFieldsDtoMapper.ensureInitialized();
  @override
  PhorgeRevisionStatusFieldsDtoCopyWith<
    $R,
    PhorgeRevisionStatusFieldsDto,
    PhorgeRevisionStatusFieldsDto
  >
  get status => $value.status.copyWith.$chain((v) => call(status: v));
  @override
  $R call({
    String? authorPHID,
    String? title,
    String? uri,
    int? dateModified,
    PhorgeRevisionStatusFieldsDto? status,
  }) => $apply(
    FieldCopyWithData({
      if (authorPHID != null) #authorPHID: authorPHID,
      if (title != null) #title: title,
      if (uri != null) #uri: uri,
      if (dateModified != null) #dateModified: dateModified,
      if (status != null) #status: status,
    }),
  );
  @override
  PhorgeRevisionFieldsDto $make(CopyWithData data) => PhorgeRevisionFieldsDto(
    authorPHID: data.get(#authorPHID, or: $value.authorPHID),
    title: data.get(#title, or: $value.title),
    uri: data.get(#uri, or: $value.uri),
    dateModified: data.get(#dateModified, or: $value.dateModified),
    status: data.get(#status, or: $value.status),
  );

  @override
  PhorgeRevisionFieldsDtoCopyWith<$R2, PhorgeRevisionFieldsDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeRevisionFieldsDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

