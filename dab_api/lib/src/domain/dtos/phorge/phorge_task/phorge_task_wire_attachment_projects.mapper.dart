// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_wire_attachment_projects.dart';

class PhorgeTaskWireAttachmentProjectsMapper
    extends ClassMapperBase<PhorgeTaskWireAttachmentProjects> {
  PhorgeTaskWireAttachmentProjectsMapper._();

  static PhorgeTaskWireAttachmentProjectsMapper? _instance;
  static PhorgeTaskWireAttachmentProjectsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeTaskWireAttachmentProjectsMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskWireAttachmentProjects';

  static List<String> _$projectPHIDs(PhorgeTaskWireAttachmentProjects v) =>
      v.projectPHIDs;
  static const Field<PhorgeTaskWireAttachmentProjects, List<String>>
  _f$projectPHIDs = Field(
    'projectPHIDs',
    _$projectPHIDs,
    hook: PhorgeTaskWireStringListHook(),
  );

  @override
  final MappableFields<PhorgeTaskWireAttachmentProjects> fields = const {
    #projectPHIDs: _f$projectPHIDs,
  };

  static PhorgeTaskWireAttachmentProjects _instantiate(DecodingData data) {
    return PhorgeTaskWireAttachmentProjects(
      projectPHIDs: data.dec(_f$projectPHIDs),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskWireAttachmentProjects fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskWireAttachmentProjects>(map);
  }

  static PhorgeTaskWireAttachmentProjects fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskWireAttachmentProjects>(
      json,
    );
  }
}

mixin PhorgeTaskWireAttachmentProjectsMappable {
  String toJson() {
    return PhorgeTaskWireAttachmentProjectsMapper.ensureInitialized()
        .encodeJson<PhorgeTaskWireAttachmentProjects>(
          this as PhorgeTaskWireAttachmentProjects,
        );
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskWireAttachmentProjectsMapper.ensureInitialized()
        .encodeMap<PhorgeTaskWireAttachmentProjects>(
          this as PhorgeTaskWireAttachmentProjects,
        );
  }

  PhorgeTaskWireAttachmentProjectsCopyWith<
    PhorgeTaskWireAttachmentProjects,
    PhorgeTaskWireAttachmentProjects,
    PhorgeTaskWireAttachmentProjects
  >
  get copyWith =>
      _PhorgeTaskWireAttachmentProjectsCopyWithImpl<
        PhorgeTaskWireAttachmentProjects,
        PhorgeTaskWireAttachmentProjects
      >(this as PhorgeTaskWireAttachmentProjects, $identity, $identity);
  @override
  String toString() {
    return PhorgeTaskWireAttachmentProjectsMapper.ensureInitialized()
        .stringifyValue(this as PhorgeTaskWireAttachmentProjects);
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskWireAttachmentProjectsMapper.ensureInitialized()
        .equalsValue(this as PhorgeTaskWireAttachmentProjects, other);
  }

  @override
  int get hashCode {
    return PhorgeTaskWireAttachmentProjectsMapper.ensureInitialized().hashValue(
      this as PhorgeTaskWireAttachmentProjects,
    );
  }
}

extension PhorgeTaskWireAttachmentProjectsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskWireAttachmentProjects, $Out> {
  PhorgeTaskWireAttachmentProjectsCopyWith<
    $R,
    PhorgeTaskWireAttachmentProjects,
    $Out
  >
  get $asPhorgeTaskWireAttachmentProjects => $base.as(
    (v, t, t2) =>
        _PhorgeTaskWireAttachmentProjectsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskWireAttachmentProjectsCopyWith<
  $R,
  $In extends PhorgeTaskWireAttachmentProjects,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get projectPHIDs;
  $R call({List<String>? projectPHIDs});
  PhorgeTaskWireAttachmentProjectsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskWireAttachmentProjectsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskWireAttachmentProjects, $Out>
    implements
        PhorgeTaskWireAttachmentProjectsCopyWith<
          $R,
          PhorgeTaskWireAttachmentProjects,
          $Out
        > {
  _PhorgeTaskWireAttachmentProjectsCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PhorgeTaskWireAttachmentProjects> $mapper =
      PhorgeTaskWireAttachmentProjectsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get projectPHIDs => ListCopyWith(
    $value.projectPHIDs,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(projectPHIDs: v),
  );
  @override
  $R call({List<String>? projectPHIDs}) => $apply(
    FieldCopyWithData({if (projectPHIDs != null) #projectPHIDs: projectPHIDs}),
  );
  @override
  PhorgeTaskWireAttachmentProjects $make(CopyWithData data) =>
      PhorgeTaskWireAttachmentProjects(
        projectPHIDs: data.get(#projectPHIDs, or: $value.projectPHIDs),
      );

  @override
  PhorgeTaskWireAttachmentProjectsCopyWith<
    $R2,
    PhorgeTaskWireAttachmentProjects,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTaskWireAttachmentProjectsCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

