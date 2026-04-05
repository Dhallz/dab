// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_data.dart';

class PhorgeTaskDataMapper extends ClassMapperBase<PhorgeTaskData> {
  PhorgeTaskDataMapper._();

  static PhorgeTaskDataMapper? _instance;
  static PhorgeTaskDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTaskDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskData';

  static int _$id(PhorgeTaskData v) => v.id;
  static const Field<PhorgeTaskData, int> _f$id = Field('id', _$id);
  static String _$phid(PhorgeTaskData v) => v.phid;
  static const Field<PhorgeTaskData, String> _f$phid = Field('phid', _$phid);
  static String _$name(PhorgeTaskData v) => v.name;
  static const Field<PhorgeTaskData, String> _f$name = Field('name', _$name);
  static String _$uri(PhorgeTaskData v) => v.uri;
  static const Field<PhorgeTaskData, String> _f$uri = Field('uri', _$uri);
  static String _$ownerPHID(PhorgeTaskData v) => v.ownerPHID;
  static const Field<PhorgeTaskData, String> _f$ownerPHID = Field(
    'ownerPHID',
    _$ownerPHID,
  );
  static List<String> _$projectPHIDs(PhorgeTaskData v) => v.projectPHIDs;
  static const Field<PhorgeTaskData, List<String>> _f$projectPHIDs = Field(
    'projectPHIDs',
    _$projectPHIDs,
  );
  static DateTime? _$dateModified(PhorgeTaskData v) => v.dateModified;
  static const Field<PhorgeTaskData, DateTime> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
    opt: true,
  );

  @override
  final MappableFields<PhorgeTaskData> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #name: _f$name,
    #uri: _f$uri,
    #ownerPHID: _f$ownerPHID,
    #projectPHIDs: _f$projectPHIDs,
    #dateModified: _f$dateModified,
  };

  static PhorgeTaskData _instantiate(DecodingData data) {
    return PhorgeTaskData(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      name: data.dec(_f$name),
      uri: data.dec(_f$uri),
      ownerPHID: data.dec(_f$ownerPHID),
      projectPHIDs: data.dec(_f$projectPHIDs),
      dateModified: data.dec(_f$dateModified),
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get projectPHIDs;
  $R call({
    int? id,
    String? phid,
    String? name,
    String? uri,
    String? ownerPHID,
    List<String>? projectPHIDs,
    DateTime? dateModified,
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
    Object? dateModified = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (name != null) #name: name,
      if (uri != null) #uri: uri,
      if (ownerPHID != null) #ownerPHID: ownerPHID,
      if (projectPHIDs != null) #projectPHIDs: projectPHIDs,
      if (dateModified != $none) #dateModified: dateModified,
    }),
  );
  @override
  PhorgeTaskData $make(CopyWithData data) => PhorgeTaskData(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    name: data.get(#name, or: $value.name),
    uri: data.get(#uri, or: $value.uri),
    ownerPHID: data.get(#ownerPHID, or: $value.ownerPHID),
    projectPHIDs: data.get(#projectPHIDs, or: $value.projectPHIDs),
    dateModified: data.get(#dateModified, or: $value.dateModified),
  );

  @override
  PhorgeTaskDataCopyWith<$R2, PhorgeTaskData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeTaskDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

