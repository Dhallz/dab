// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_wire_attachments.dart';

class PhorgeTaskWireAttachmentsMapper
    extends ClassMapperBase<PhorgeTaskWireAttachments> {
  PhorgeTaskWireAttachmentsMapper._();

  static PhorgeTaskWireAttachmentsMapper? _instance;
  static PhorgeTaskWireAttachmentsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeTaskWireAttachmentsMapper._(),
      );
      PhorgeTaskWireAttachmentProjectsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskWireAttachments';

  static PhorgeTaskWireAttachmentProjects? _$projects(
    PhorgeTaskWireAttachments v,
  ) => v.projects;
  static const Field<
    PhorgeTaskWireAttachments,
    PhorgeTaskWireAttachmentProjects
  >
  _f$projects = Field('projects', _$projects, opt: true);

  @override
  final MappableFields<PhorgeTaskWireAttachments> fields = const {
    #projects: _f$projects,
  };

  static PhorgeTaskWireAttachments _instantiate(DecodingData data) {
    return PhorgeTaskWireAttachments(projects: data.dec(_f$projects));
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskWireAttachments fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskWireAttachments>(map);
  }

  static PhorgeTaskWireAttachments fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskWireAttachments>(json);
  }
}

mixin PhorgeTaskWireAttachmentsMappable {
  String toJson() {
    return PhorgeTaskWireAttachmentsMapper.ensureInitialized()
        .encodeJson<PhorgeTaskWireAttachments>(
          this as PhorgeTaskWireAttachments,
        );
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskWireAttachmentsMapper.ensureInitialized()
        .encodeMap<PhorgeTaskWireAttachments>(
          this as PhorgeTaskWireAttachments,
        );
  }

  PhorgeTaskWireAttachmentsCopyWith<
    PhorgeTaskWireAttachments,
    PhorgeTaskWireAttachments,
    PhorgeTaskWireAttachments
  >
  get copyWith =>
      _PhorgeTaskWireAttachmentsCopyWithImpl<
        PhorgeTaskWireAttachments,
        PhorgeTaskWireAttachments
      >(this as PhorgeTaskWireAttachments, $identity, $identity);
  @override
  String toString() {
    return PhorgeTaskWireAttachmentsMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskWireAttachments,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskWireAttachmentsMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskWireAttachments,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskWireAttachmentsMapper.ensureInitialized().hashValue(
      this as PhorgeTaskWireAttachments,
    );
  }
}

extension PhorgeTaskWireAttachmentsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskWireAttachments, $Out> {
  PhorgeTaskWireAttachmentsCopyWith<$R, PhorgeTaskWireAttachments, $Out>
  get $asPhorgeTaskWireAttachments => $base.as(
    (v, t, t2) => _PhorgeTaskWireAttachmentsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskWireAttachmentsCopyWith<
  $R,
  $In extends PhorgeTaskWireAttachments,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeTaskWireAttachmentProjectsCopyWith<
    $R,
    PhorgeTaskWireAttachmentProjects,
    PhorgeTaskWireAttachmentProjects
  >?
  get projects;
  $R call({PhorgeTaskWireAttachmentProjects? projects});
  PhorgeTaskWireAttachmentsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskWireAttachmentsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskWireAttachments, $Out>
    implements
        PhorgeTaskWireAttachmentsCopyWith<$R, PhorgeTaskWireAttachments, $Out> {
  _PhorgeTaskWireAttachmentsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskWireAttachments> $mapper =
      PhorgeTaskWireAttachmentsMapper.ensureInitialized();
  @override
  PhorgeTaskWireAttachmentProjectsCopyWith<
    $R,
    PhorgeTaskWireAttachmentProjects,
    PhorgeTaskWireAttachmentProjects
  >?
  get projects => $value.projects?.copyWith.$chain((v) => call(projects: v));
  @override
  $R call({Object? projects = $none}) =>
      $apply(FieldCopyWithData({if (projects != $none) #projects: projects}));
  @override
  PhorgeTaskWireAttachments $make(CopyWithData data) =>
      PhorgeTaskWireAttachments(
        projects: data.get(#projects, or: $value.projects),
      );

  @override
  PhorgeTaskWireAttachmentsCopyWith<$R2, PhorgeTaskWireAttachments, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTaskWireAttachmentsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

