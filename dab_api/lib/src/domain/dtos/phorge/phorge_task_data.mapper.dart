// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_data.dart';

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
    hook: _WireStringListHook(),
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

class PhorgeTaskWireFieldsMapper extends ClassMapperBase<PhorgeTaskWireFields> {
  PhorgeTaskWireFieldsMapper._();

  static PhorgeTaskWireFieldsMapper? _instance;
  static PhorgeTaskWireFieldsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTaskWireFieldsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskWireFields';

  static String _$name(PhorgeTaskWireFields v) => v.name;
  static const Field<PhorgeTaskWireFields, String> _f$name = Field(
    'name',
    _$name,
    hook: _WireDefaultStringHook('Unknown'),
  );
  static String _$uri(PhorgeTaskWireFields v) => v.uri;
  static const Field<PhorgeTaskWireFields, String> _f$uri = Field(
    'uri',
    _$uri,
    hook: _WireDefaultStringHook(''),
  );
  static String _$ownerPHID(PhorgeTaskWireFields v) => v.ownerPHID;
  static const Field<PhorgeTaskWireFields, String> _f$ownerPHID = Field(
    'ownerPHID',
    _$ownerPHID,
    hook: _WireDefaultStringHook('system'),
  );
  static int? _$dateModified(PhorgeTaskWireFields v) => v.dateModified;
  static const Field<PhorgeTaskWireFields, int> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
    opt: true,
  );

  @override
  final MappableFields<PhorgeTaskWireFields> fields = const {
    #name: _f$name,
    #uri: _f$uri,
    #ownerPHID: _f$ownerPHID,
    #dateModified: _f$dateModified,
  };

  static PhorgeTaskWireFields _instantiate(DecodingData data) {
    return PhorgeTaskWireFields(
      name: data.dec(_f$name),
      uri: data.dec(_f$uri),
      ownerPHID: data.dec(_f$ownerPHID),
      dateModified: data.dec(_f$dateModified),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskWireFields fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskWireFields>(map);
  }

  static PhorgeTaskWireFields fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskWireFields>(json);
  }
}

mixin PhorgeTaskWireFieldsMappable {
  String toJson() {
    return PhorgeTaskWireFieldsMapper.ensureInitialized()
        .encodeJson<PhorgeTaskWireFields>(this as PhorgeTaskWireFields);
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskWireFieldsMapper.ensureInitialized()
        .encodeMap<PhorgeTaskWireFields>(this as PhorgeTaskWireFields);
  }

  PhorgeTaskWireFieldsCopyWith<
    PhorgeTaskWireFields,
    PhorgeTaskWireFields,
    PhorgeTaskWireFields
  >
  get copyWith =>
      _PhorgeTaskWireFieldsCopyWithImpl<
        PhorgeTaskWireFields,
        PhorgeTaskWireFields
      >(this as PhorgeTaskWireFields, $identity, $identity);
  @override
  String toString() {
    return PhorgeTaskWireFieldsMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskWireFields,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskWireFieldsMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskWireFields,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskWireFieldsMapper.ensureInitialized().hashValue(
      this as PhorgeTaskWireFields,
    );
  }
}

extension PhorgeTaskWireFieldsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskWireFields, $Out> {
  PhorgeTaskWireFieldsCopyWith<$R, PhorgeTaskWireFields, $Out>
  get $asPhorgeTaskWireFields => $base.as(
    (v, t, t2) => _PhorgeTaskWireFieldsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskWireFieldsCopyWith<
  $R,
  $In extends PhorgeTaskWireFields,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? uri, String? ownerPHID, int? dateModified});
  PhorgeTaskWireFieldsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskWireFieldsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskWireFields, $Out>
    implements PhorgeTaskWireFieldsCopyWith<$R, PhorgeTaskWireFields, $Out> {
  _PhorgeTaskWireFieldsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskWireFields> $mapper =
      PhorgeTaskWireFieldsMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    String? uri,
    String? ownerPHID,
    Object? dateModified = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (uri != null) #uri: uri,
      if (ownerPHID != null) #ownerPHID: ownerPHID,
      if (dateModified != $none) #dateModified: dateModified,
    }),
  );
  @override
  PhorgeTaskWireFields $make(CopyWithData data) => PhorgeTaskWireFields(
    name: data.get(#name, or: $value.name),
    uri: data.get(#uri, or: $value.uri),
    ownerPHID: data.get(#ownerPHID, or: $value.ownerPHID),
    dateModified: data.get(#dateModified, or: $value.dateModified),
  );

  @override
  PhorgeTaskWireFieldsCopyWith<$R2, PhorgeTaskWireFields, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTaskWireFieldsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PhorgeTaskDataMapper extends ClassMapperBase<PhorgeTaskData> {
  PhorgeTaskDataMapper._();

  static PhorgeTaskDataMapper? _instance;
  static PhorgeTaskDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTaskDataMapper._());
      PhorgeTaskWireFieldsMapper.ensureInitialized();
      PhorgeTaskWireAttachmentsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskData';

  static int _$id(PhorgeTaskData v) => v.id;
  static const Field<PhorgeTaskData, int> _f$id = Field(
    'id',
    _$id,
    hook: _PhorgeWireIntHook(),
  );
  static String _$phid(PhorgeTaskData v) => v.phid;
  static const Field<PhorgeTaskData, String> _f$phid = Field(
    'phid',
    _$phid,
    hook: _WireDefaultStringHook(''),
  );
  static PhorgeTaskWireFields _$fields(PhorgeTaskData v) => v.fields;
  static const Field<PhorgeTaskData, PhorgeTaskWireFields> _f$fields = Field(
    'fields',
    _$fields,
  );
  static PhorgeTaskWireAttachments? _$attachments(PhorgeTaskData v) =>
      v.attachments;
  static const Field<PhorgeTaskData, PhorgeTaskWireAttachments> _f$attachments =
      Field('attachments', _$attachments, opt: true);

  @override
  final MappableFields<PhorgeTaskData> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #fields: _f$fields,
    #attachments: _f$attachments,
  };

  static PhorgeTaskData _instantiate(DecodingData data) {
    return PhorgeTaskData(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      fields: data.dec(_f$fields),
      attachments: data.dec(_f$attachments),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskData>(map);
  }

  static PhorgeTaskData fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskData>(json);
  }
}

mixin PhorgeTaskDataMappable {
  String toJson() {
    return PhorgeTaskDataMapper.ensureInitialized().encodeJson<PhorgeTaskData>(
      this as PhorgeTaskData,
    );
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskDataMapper.ensureInitialized().encodeMap<PhorgeTaskData>(
      this as PhorgeTaskData,
    );
  }

  PhorgeTaskDataCopyWith<PhorgeTaskData, PhorgeTaskData, PhorgeTaskData>
  get copyWith => _PhorgeTaskDataCopyWithImpl<PhorgeTaskData, PhorgeTaskData>(
    this as PhorgeTaskData,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PhorgeTaskDataMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskData,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskDataMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskData,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskDataMapper.ensureInitialized().hashValue(
      this as PhorgeTaskData,
    );
  }
}

extension PhorgeTaskDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskData, $Out> {
  PhorgeTaskDataCopyWith<$R, PhorgeTaskData, $Out> get $asPhorgeTaskData =>
      $base.as((v, t, t2) => _PhorgeTaskDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhorgeTaskDataCopyWith<$R, $In extends PhorgeTaskData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeTaskWireFieldsCopyWith<$R, PhorgeTaskWireFields, PhorgeTaskWireFields>
  get fields;
  PhorgeTaskWireAttachmentsCopyWith<
    $R,
    PhorgeTaskWireAttachments,
    PhorgeTaskWireAttachments
  >?
  get attachments;
  $R call({
    int? id,
    String? phid,
    PhorgeTaskWireFields? fields,
    PhorgeTaskWireAttachments? attachments,
  });
  PhorgeTaskDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskData, $Out>
    implements PhorgeTaskDataCopyWith<$R, PhorgeTaskData, $Out> {
  _PhorgeTaskDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskData> $mapper =
      PhorgeTaskDataMapper.ensureInitialized();
  @override
  PhorgeTaskWireFieldsCopyWith<$R, PhorgeTaskWireFields, PhorgeTaskWireFields>
  get fields => $value.fields.copyWith.$chain((v) => call(fields: v));
  @override
  PhorgeTaskWireAttachmentsCopyWith<
    $R,
    PhorgeTaskWireAttachments,
    PhorgeTaskWireAttachments
  >?
  get attachments =>
      $value.attachments?.copyWith.$chain((v) => call(attachments: v));
  @override
  $R call({
    int? id,
    String? phid,
    PhorgeTaskWireFields? fields,
    Object? attachments = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (fields != null) #fields: fields,
      if (attachments != $none) #attachments: attachments,
    }),
  );
  @override
  PhorgeTaskData $make(CopyWithData data) => PhorgeTaskData(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    fields: data.get(#fields, or: $value.fields),
    attachments: data.get(#attachments, or: $value.attachments),
  );

  @override
  PhorgeTaskDataCopyWith<$R2, PhorgeTaskData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeTaskDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

