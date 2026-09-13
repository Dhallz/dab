// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_wire_attachment_projects_dto.dart';

class PhorgeTaskWireAttachmentProjectsDtoMapper
    extends ClassMapperBase<PhorgeTaskWireAttachmentProjectsDto> {
  PhorgeTaskWireAttachmentProjectsDtoMapper._();

  static PhorgeTaskWireAttachmentProjectsDtoMapper? _instance;
  static PhorgeTaskWireAttachmentProjectsDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeTaskWireAttachmentProjectsDtoMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskWireAttachmentProjectsDto';

  static List<String>? _$projectPHIDs(PhorgeTaskWireAttachmentProjectsDto v) =>
      v.projectPHIDs;
  static const Field<PhorgeTaskWireAttachmentProjectsDto, List<String>>
  _f$projectPHIDs = Field('projectPHIDs', _$projectPHIDs, opt: true);

  @override
  final MappableFields<PhorgeTaskWireAttachmentProjectsDto> fields = const {
    #projectPHIDs: _f$projectPHIDs,
  };

  static PhorgeTaskWireAttachmentProjectsDto _instantiate(DecodingData data) {
    return PhorgeTaskWireAttachmentProjectsDto(
      projectPHIDs: data.dec(_f$projectPHIDs),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskWireAttachmentProjectsDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskWireAttachmentProjectsDto>(
      map,
    );
  }

  static PhorgeTaskWireAttachmentProjectsDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskWireAttachmentProjectsDto>(
      json,
    );
  }
}

mixin PhorgeTaskWireAttachmentProjectsDtoMappable {
  String toJson() {
    return PhorgeTaskWireAttachmentProjectsDtoMapper.ensureInitialized()
        .encodeJson<PhorgeTaskWireAttachmentProjectsDto>(
          this as PhorgeTaskWireAttachmentProjectsDto,
        );
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskWireAttachmentProjectsDtoMapper.ensureInitialized()
        .encodeMap<PhorgeTaskWireAttachmentProjectsDto>(
          this as PhorgeTaskWireAttachmentProjectsDto,
        );
  }

  PhorgeTaskWireAttachmentProjectsDtoCopyWith<
    PhorgeTaskWireAttachmentProjectsDto,
    PhorgeTaskWireAttachmentProjectsDto,
    PhorgeTaskWireAttachmentProjectsDto
  >
  get copyWith =>
      _PhorgeTaskWireAttachmentProjectsDtoCopyWithImpl<
        PhorgeTaskWireAttachmentProjectsDto,
        PhorgeTaskWireAttachmentProjectsDto
      >(this as PhorgeTaskWireAttachmentProjectsDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeTaskWireAttachmentProjectsDtoMapper.ensureInitialized()
        .stringifyValue(this as PhorgeTaskWireAttachmentProjectsDto);
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskWireAttachmentProjectsDtoMapper.ensureInitialized()
        .equalsValue(this as PhorgeTaskWireAttachmentProjectsDto, other);
  }

  @override
  int get hashCode {
    return PhorgeTaskWireAttachmentProjectsDtoMapper.ensureInitialized()
        .hashValue(this as PhorgeTaskWireAttachmentProjectsDto);
  }
}

extension PhorgeTaskWireAttachmentProjectsDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskWireAttachmentProjectsDto, $Out> {
  PhorgeTaskWireAttachmentProjectsDtoCopyWith<
    $R,
    PhorgeTaskWireAttachmentProjectsDto,
    $Out
  >
  get $asPhorgeTaskWireAttachmentProjectsDto => $base.as(
    (v, t, t2) =>
        _PhorgeTaskWireAttachmentProjectsDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskWireAttachmentProjectsDtoCopyWith<
  $R,
  $In extends PhorgeTaskWireAttachmentProjectsDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get projectPHIDs;
  $R call({List<String>? projectPHIDs});
  PhorgeTaskWireAttachmentProjectsDtoCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PhorgeTaskWireAttachmentProjectsDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskWireAttachmentProjectsDto, $Out>
    implements
        PhorgeTaskWireAttachmentProjectsDtoCopyWith<
          $R,
          PhorgeTaskWireAttachmentProjectsDto,
          $Out
        > {
  _PhorgeTaskWireAttachmentProjectsDtoCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PhorgeTaskWireAttachmentProjectsDto> $mapper =
      PhorgeTaskWireAttachmentProjectsDtoMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get projectPHIDs => $value.projectPHIDs != null
      ? ListCopyWith(
          $value.projectPHIDs!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(projectPHIDs: v),
        )
      : null;
  @override
  $R call({Object? projectPHIDs = $none}) => $apply(
    FieldCopyWithData({if (projectPHIDs != $none) #projectPHIDs: projectPHIDs}),
  );
  @override
  PhorgeTaskWireAttachmentProjectsDto $make(CopyWithData data) =>
      PhorgeTaskWireAttachmentProjectsDto(
        projectPHIDs: data.get(#projectPHIDs, or: $value.projectPHIDs),
      );

  @override
  PhorgeTaskWireAttachmentProjectsDtoCopyWith<
    $R2,
    PhorgeTaskWireAttachmentProjectsDto,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTaskWireAttachmentProjectsDtoCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

