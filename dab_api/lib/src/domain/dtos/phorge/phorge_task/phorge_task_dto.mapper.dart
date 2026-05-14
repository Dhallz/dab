// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_dto.dart';

class PhorgeTaskDtoMapper extends ClassMapperBase<PhorgeTaskDto> {
  PhorgeTaskDtoMapper._();

  static PhorgeTaskDtoMapper? _instance;
  static PhorgeTaskDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTaskDtoMapper._());
      PhorgeTaskWireFieldsDtoMapper.ensureInitialized();
      PhorgeTaskWireAttachmentsDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskDto';

  static int? _$id(PhorgeTaskDto v) => v.id;
  static const Field<PhorgeTaskDto, int> _f$id = Field('id', _$id, opt: true);
  static String? _$phid(PhorgeTaskDto v) => v.phid;
  static const Field<PhorgeTaskDto, String> _f$phid = Field(
    'phid',
    _$phid,
    opt: true,
  );
  static PhorgeTaskWireFieldsDto _$fields(PhorgeTaskDto v) => v.fields;
  static const Field<PhorgeTaskDto, PhorgeTaskWireFieldsDto> _f$fields = Field(
    'fields',
    _$fields,
  );
  static PhorgeTaskWireAttachmentsDto? _$attachments(PhorgeTaskDto v) =>
      v.attachments;
  static const Field<PhorgeTaskDto, PhorgeTaskWireAttachmentsDto>
  _f$attachments = Field('attachments', _$attachments, opt: true);

  @override
  final MappableFields<PhorgeTaskDto> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #fields: _f$fields,
    #attachments: _f$attachments,
  };

  static PhorgeTaskDto _instantiate(DecodingData data) {
    return PhorgeTaskDto(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      fields: data.dec(_f$fields),
      attachments: data.dec(_f$attachments),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskDto>(map);
  }

  static PhorgeTaskDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskDto>(json);
  }
}

mixin PhorgeTaskDtoMappable {
  String toJson() {
    return PhorgeTaskDtoMapper.ensureInitialized().encodeJson<PhorgeTaskDto>(
      this as PhorgeTaskDto,
    );
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskDtoMapper.ensureInitialized().encodeMap<PhorgeTaskDto>(
      this as PhorgeTaskDto,
    );
  }

  PhorgeTaskDtoCopyWith<PhorgeTaskDto, PhorgeTaskDto, PhorgeTaskDto>
  get copyWith => _PhorgeTaskDtoCopyWithImpl<PhorgeTaskDto, PhorgeTaskDto>(
    this as PhorgeTaskDto,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PhorgeTaskDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskDtoMapper.ensureInitialized().hashValue(
      this as PhorgeTaskDto,
    );
  }
}

extension PhorgeTaskDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskDto, $Out> {
  PhorgeTaskDtoCopyWith<$R, PhorgeTaskDto, $Out> get $asPhorgeTaskDto =>
      $base.as((v, t, t2) => _PhorgeTaskDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhorgeTaskDtoCopyWith<$R, $In extends PhorgeTaskDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeTaskWireFieldsDtoCopyWith<
    $R,
    PhorgeTaskWireFieldsDto,
    PhorgeTaskWireFieldsDto
  >
  get fields;
  PhorgeTaskWireAttachmentsDtoCopyWith<
    $R,
    PhorgeTaskWireAttachmentsDto,
    PhorgeTaskWireAttachmentsDto
  >?
  get attachments;
  $R call({
    int? id,
    String? phid,
    PhorgeTaskWireFieldsDto? fields,
    PhorgeTaskWireAttachmentsDto? attachments,
  });
  PhorgeTaskDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PhorgeTaskDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskDto, $Out>
    implements PhorgeTaskDtoCopyWith<$R, PhorgeTaskDto, $Out> {
  _PhorgeTaskDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskDto> $mapper =
      PhorgeTaskDtoMapper.ensureInitialized();
  @override
  PhorgeTaskWireFieldsDtoCopyWith<
    $R,
    PhorgeTaskWireFieldsDto,
    PhorgeTaskWireFieldsDto
  >
  get fields => $value.fields.copyWith.$chain((v) => call(fields: v));
  @override
  PhorgeTaskWireAttachmentsDtoCopyWith<
    $R,
    PhorgeTaskWireAttachmentsDto,
    PhorgeTaskWireAttachmentsDto
  >?
  get attachments =>
      $value.attachments?.copyWith.$chain((v) => call(attachments: v));
  @override
  $R call({
    Object? id = $none,
    Object? phid = $none,
    PhorgeTaskWireFieldsDto? fields,
    Object? attachments = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (phid != $none) #phid: phid,
      if (fields != null) #fields: fields,
      if (attachments != $none) #attachments: attachments,
    }),
  );
  @override
  PhorgeTaskDto $make(CopyWithData data) => PhorgeTaskDto(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    fields: data.get(#fields, or: $value.fields),
    attachments: data.get(#attachments, or: $value.attachments),
  );

  @override
  PhorgeTaskDtoCopyWith<$R2, PhorgeTaskDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeTaskDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

