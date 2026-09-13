// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_wire_attachments_dto.dart';

class PhorgeTaskWireAttachmentsDtoMapper
    extends ClassMapperBase<PhorgeTaskWireAttachmentsDto> {
  PhorgeTaskWireAttachmentsDtoMapper._();

  static PhorgeTaskWireAttachmentsDtoMapper? _instance;
  static PhorgeTaskWireAttachmentsDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeTaskWireAttachmentsDtoMapper._(),
      );
      PhorgeTaskWireAttachmentProjectsDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskWireAttachmentsDto';

  static PhorgeTaskWireAttachmentProjectsDto? _$projects(
    PhorgeTaskWireAttachmentsDto v,
  ) => v.projects;
  static const Field<
    PhorgeTaskWireAttachmentsDto,
    PhorgeTaskWireAttachmentProjectsDto
  >
  _f$projects = Field('projects', _$projects, opt: true);

  @override
  final MappableFields<PhorgeTaskWireAttachmentsDto> fields = const {
    #projects: _f$projects,
  };

  static PhorgeTaskWireAttachmentsDto _instantiate(DecodingData data) {
    return PhorgeTaskWireAttachmentsDto(projects: data.dec(_f$projects));
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskWireAttachmentsDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskWireAttachmentsDto>(map);
  }

  static PhorgeTaskWireAttachmentsDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskWireAttachmentsDto>(json);
  }
}

mixin PhorgeTaskWireAttachmentsDtoMappable {
  String toJson() {
    return PhorgeTaskWireAttachmentsDtoMapper.ensureInitialized()
        .encodeJson<PhorgeTaskWireAttachmentsDto>(
          this as PhorgeTaskWireAttachmentsDto,
        );
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskWireAttachmentsDtoMapper.ensureInitialized()
        .encodeMap<PhorgeTaskWireAttachmentsDto>(
          this as PhorgeTaskWireAttachmentsDto,
        );
  }

  PhorgeTaskWireAttachmentsDtoCopyWith<
    PhorgeTaskWireAttachmentsDto,
    PhorgeTaskWireAttachmentsDto,
    PhorgeTaskWireAttachmentsDto
  >
  get copyWith =>
      _PhorgeTaskWireAttachmentsDtoCopyWithImpl<
        PhorgeTaskWireAttachmentsDto,
        PhorgeTaskWireAttachmentsDto
      >(this as PhorgeTaskWireAttachmentsDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeTaskWireAttachmentsDtoMapper.ensureInitialized()
        .stringifyValue(this as PhorgeTaskWireAttachmentsDto);
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskWireAttachmentsDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskWireAttachmentsDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskWireAttachmentsDtoMapper.ensureInitialized().hashValue(
      this as PhorgeTaskWireAttachmentsDto,
    );
  }
}

extension PhorgeTaskWireAttachmentsDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskWireAttachmentsDto, $Out> {
  PhorgeTaskWireAttachmentsDtoCopyWith<$R, PhorgeTaskWireAttachmentsDto, $Out>
  get $asPhorgeTaskWireAttachmentsDto => $base.as(
    (v, t, t2) => _PhorgeTaskWireAttachmentsDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskWireAttachmentsDtoCopyWith<
  $R,
  $In extends PhorgeTaskWireAttachmentsDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeTaskWireAttachmentProjectsDtoCopyWith<
    $R,
    PhorgeTaskWireAttachmentProjectsDto,
    PhorgeTaskWireAttachmentProjectsDto
  >?
  get projects;
  $R call({PhorgeTaskWireAttachmentProjectsDto? projects});
  PhorgeTaskWireAttachmentsDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskWireAttachmentsDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskWireAttachmentsDto, $Out>
    implements
        PhorgeTaskWireAttachmentsDtoCopyWith<
          $R,
          PhorgeTaskWireAttachmentsDto,
          $Out
        > {
  _PhorgeTaskWireAttachmentsDtoCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PhorgeTaskWireAttachmentsDto> $mapper =
      PhorgeTaskWireAttachmentsDtoMapper.ensureInitialized();
  @override
  PhorgeTaskWireAttachmentProjectsDtoCopyWith<
    $R,
    PhorgeTaskWireAttachmentProjectsDto,
    PhorgeTaskWireAttachmentProjectsDto
  >?
  get projects => $value.projects?.copyWith.$chain((v) => call(projects: v));
  @override
  $R call({Object? projects = $none}) =>
      $apply(FieldCopyWithData({if (projects != $none) #projects: projects}));
  @override
  PhorgeTaskWireAttachmentsDto $make(CopyWithData data) =>
      PhorgeTaskWireAttachmentsDto(
        projects: data.get(#projects, or: $value.projects),
      );

  @override
  PhorgeTaskWireAttachmentsDtoCopyWith<$R2, PhorgeTaskWireAttachmentsDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTaskWireAttachmentsDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

