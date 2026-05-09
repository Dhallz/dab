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
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskDto';

  static int _$id(PhorgeTaskDto v) => v.id;
  static const Field<PhorgeTaskDto, int> _f$id = Field('id', _$id);
  static String _$phid(PhorgeTaskDto v) => v.phid;
  static const Field<PhorgeTaskDto, String> _f$phid = Field('phid', _$phid);
  static String _$name(PhorgeTaskDto v) => v.name;
  static const Field<PhorgeTaskDto, String> _f$name = Field('name', _$name);
  static String _$uri(PhorgeTaskDto v) => v.uri;
  static const Field<PhorgeTaskDto, String> _f$uri = Field('uri', _$uri);
  static String _$ownerPHID(PhorgeTaskDto v) => v.ownerPHID;
  static const Field<PhorgeTaskDto, String> _f$ownerPHID = Field(
    'ownerPHID',
    _$ownerPHID,
  );
  static List<String> _$projectPHIDs(PhorgeTaskDto v) => v.projectPHIDs;
  static const Field<PhorgeTaskDto, List<String>> _f$projectPHIDs = Field(
    'projectPHIDs',
    _$projectPHIDs,
  );

  @override
  final MappableFields<PhorgeTaskDto> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #name: _f$name,
    #uri: _f$uri,
    #ownerPHID: _f$ownerPHID,
    #projectPHIDs: _f$projectPHIDs,
  };

  static PhorgeTaskDto _instantiate(DecodingData data) {
    return PhorgeTaskDto(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      name: data.dec(_f$name),
      uri: data.dec(_f$uri),
      ownerPHID: data.dec(_f$ownerPHID),
      projectPHIDs: data.dec(_f$projectPHIDs),
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get projectPHIDs;
  $R call({
    int? id,
    String? phid,
    String? name,
    String? uri,
    String? ownerPHID,
    List<String>? projectPHIDs,
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get projectPHIDs => ListCopyWith(
    $value.projectPHIDs,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(projectPHIDs: v),
  );
  @override
  $R call({
    int? id,
    String? phid,
    String? name,
    String? uri,
    String? ownerPHID,
    List<String>? projectPHIDs,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (name != null) #name: name,
      if (uri != null) #uri: uri,
      if (ownerPHID != null) #ownerPHID: ownerPHID,
      if (projectPHIDs != null) #projectPHIDs: projectPHIDs,
    }),
  );
  @override
  PhorgeTaskDto $make(CopyWithData data) => PhorgeTaskDto(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    name: data.get(#name, or: $value.name),
    uri: data.get(#uri, or: $value.uri),
    ownerPHID: data.get(#ownerPHID, or: $value.ownerPHID),
    projectPHIDs: data.get(#projectPHIDs, or: $value.projectPHIDs),
  );

  @override
  PhorgeTaskDtoCopyWith<$R2, PhorgeTaskDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeTaskDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

