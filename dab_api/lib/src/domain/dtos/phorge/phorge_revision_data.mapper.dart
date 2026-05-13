// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_revision_data.dart';

class PhorgeRevisionFieldsMapper extends ClassMapperBase<PhorgeRevisionFields> {
  PhorgeRevisionFieldsMapper._();

  static PhorgeRevisionFieldsMapper? _instance;
  static PhorgeRevisionFieldsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeRevisionFieldsMapper._());
      PhorgeRevisionStatusFieldsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeRevisionFields';

  static String _$authorPHID(PhorgeRevisionFields v) => v.authorPHID;
  static const Field<PhorgeRevisionFields, String> _f$authorPHID = Field(
    'authorPHID',
    _$authorPHID,
  );
  static String _$title(PhorgeRevisionFields v) => v.title;
  static const Field<PhorgeRevisionFields, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$uri(PhorgeRevisionFields v) => v.uri;
  static const Field<PhorgeRevisionFields, String> _f$uri = Field('uri', _$uri);
  static int _$dateModified(PhorgeRevisionFields v) => v.dateModified;
  static const Field<PhorgeRevisionFields, int> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
  );
  static PhorgeRevisionStatusFields _$status(PhorgeRevisionFields v) =>
      v.status;
  static const Field<PhorgeRevisionFields, PhorgeRevisionStatusFields>
  _f$status = Field('status', _$status);

  @override
  final MappableFields<PhorgeRevisionFields> fields = const {
    #authorPHID: _f$authorPHID,
    #title: _f$title,
    #uri: _f$uri,
    #dateModified: _f$dateModified,
    #status: _f$status,
  };

  static PhorgeRevisionFields _instantiate(DecodingData data) {
    return PhorgeRevisionFields(
      authorPHID: data.dec(_f$authorPHID),
      title: data.dec(_f$title),
      uri: data.dec(_f$uri),
      dateModified: data.dec(_f$dateModified),
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeRevisionFields fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeRevisionFields>(map);
  }

  static PhorgeRevisionFields fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeRevisionFields>(json);
  }
}

mixin PhorgeRevisionFieldsMappable {
  String toJson() {
    return PhorgeRevisionFieldsMapper.ensureInitialized()
        .encodeJson<PhorgeRevisionFields>(this as PhorgeRevisionFields);
  }

  Map<String, dynamic> toMap() {
    return PhorgeRevisionFieldsMapper.ensureInitialized()
        .encodeMap<PhorgeRevisionFields>(this as PhorgeRevisionFields);
  }

  PhorgeRevisionFieldsCopyWith<
    PhorgeRevisionFields,
    PhorgeRevisionFields,
    PhorgeRevisionFields
  >
  get copyWith =>
      _PhorgeRevisionFieldsCopyWithImpl<
        PhorgeRevisionFields,
        PhorgeRevisionFields
      >(this as PhorgeRevisionFields, $identity, $identity);
  @override
  String toString() {
    return PhorgeRevisionFieldsMapper.ensureInitialized().stringifyValue(
      this as PhorgeRevisionFields,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeRevisionFieldsMapper.ensureInitialized().equalsValue(
      this as PhorgeRevisionFields,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeRevisionFieldsMapper.ensureInitialized().hashValue(
      this as PhorgeRevisionFields,
    );
  }
}

extension PhorgeRevisionFieldsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeRevisionFields, $Out> {
  PhorgeRevisionFieldsCopyWith<$R, PhorgeRevisionFields, $Out>
  get $asPhorgeRevisionFields => $base.as(
    (v, t, t2) => _PhorgeRevisionFieldsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeRevisionFieldsCopyWith<
  $R,
  $In extends PhorgeRevisionFields,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeRevisionStatusFieldsCopyWith<
    $R,
    PhorgeRevisionStatusFields,
    PhorgeRevisionStatusFields
  >
  get status;
  $R call({
    String? authorPHID,
    String? title,
    String? uri,
    int? dateModified,
    PhorgeRevisionStatusFields? status,
  });
  PhorgeRevisionFieldsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeRevisionFieldsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeRevisionFields, $Out>
    implements PhorgeRevisionFieldsCopyWith<$R, PhorgeRevisionFields, $Out> {
  _PhorgeRevisionFieldsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeRevisionFields> $mapper =
      PhorgeRevisionFieldsMapper.ensureInitialized();
  @override
  PhorgeRevisionStatusFieldsCopyWith<
    $R,
    PhorgeRevisionStatusFields,
    PhorgeRevisionStatusFields
  >
  get status => $value.status.copyWith.$chain((v) => call(status: v));
  @override
  $R call({
    String? authorPHID,
    String? title,
    String? uri,
    int? dateModified,
    PhorgeRevisionStatusFields? status,
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
  PhorgeRevisionFields $make(CopyWithData data) => PhorgeRevisionFields(
    authorPHID: data.get(#authorPHID, or: $value.authorPHID),
    title: data.get(#title, or: $value.title),
    uri: data.get(#uri, or: $value.uri),
    dateModified: data.get(#dateModified, or: $value.dateModified),
    status: data.get(#status, or: $value.status),
  );

  @override
  PhorgeRevisionFieldsCopyWith<$R2, PhorgeRevisionFields, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeRevisionFieldsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PhorgeRevisionStatusFieldsMapper
    extends ClassMapperBase<PhorgeRevisionStatusFields> {
  PhorgeRevisionStatusFieldsMapper._();

  static PhorgeRevisionStatusFieldsMapper? _instance;
  static PhorgeRevisionStatusFieldsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeRevisionStatusFieldsMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeRevisionStatusFields';

  static String _$name(PhorgeRevisionStatusFields v) => v.name;
  static const Field<PhorgeRevisionStatusFields, String> _f$name = Field(
    'name',
    _$name,
  );

  @override
  final MappableFields<PhorgeRevisionStatusFields> fields = const {
    #name: _f$name,
  };

  static PhorgeRevisionStatusFields _instantiate(DecodingData data) {
    return PhorgeRevisionStatusFields(name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeRevisionStatusFields fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeRevisionStatusFields>(map);
  }

  static PhorgeRevisionStatusFields fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeRevisionStatusFields>(json);
  }
}

mixin PhorgeRevisionStatusFieldsMappable {
  String toJson() {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized()
        .encodeJson<PhorgeRevisionStatusFields>(
          this as PhorgeRevisionStatusFields,
        );
  }

  Map<String, dynamic> toMap() {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized()
        .encodeMap<PhorgeRevisionStatusFields>(
          this as PhorgeRevisionStatusFields,
        );
  }

  PhorgeRevisionStatusFieldsCopyWith<
    PhorgeRevisionStatusFields,
    PhorgeRevisionStatusFields,
    PhorgeRevisionStatusFields
  >
  get copyWith =>
      _PhorgeRevisionStatusFieldsCopyWithImpl<
        PhorgeRevisionStatusFields,
        PhorgeRevisionStatusFields
      >(this as PhorgeRevisionStatusFields, $identity, $identity);
  @override
  String toString() {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized().stringifyValue(
      this as PhorgeRevisionStatusFields,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized().equalsValue(
      this as PhorgeRevisionStatusFields,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeRevisionStatusFieldsMapper.ensureInitialized().hashValue(
      this as PhorgeRevisionStatusFields,
    );
  }
}

extension PhorgeRevisionStatusFieldsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeRevisionStatusFields, $Out> {
  PhorgeRevisionStatusFieldsCopyWith<$R, PhorgeRevisionStatusFields, $Out>
  get $asPhorgeRevisionStatusFields => $base.as(
    (v, t, t2) => _PhorgeRevisionStatusFieldsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeRevisionStatusFieldsCopyWith<
  $R,
  $In extends PhorgeRevisionStatusFields,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name});
  PhorgeRevisionStatusFieldsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeRevisionStatusFieldsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeRevisionStatusFields, $Out>
    implements
        PhorgeRevisionStatusFieldsCopyWith<
          $R,
          PhorgeRevisionStatusFields,
          $Out
        > {
  _PhorgeRevisionStatusFieldsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeRevisionStatusFields> $mapper =
      PhorgeRevisionStatusFieldsMapper.ensureInitialized();
  @override
  $R call({String? name}) =>
      $apply(FieldCopyWithData({if (name != null) #name: name}));
  @override
  PhorgeRevisionStatusFields $make(CopyWithData data) =>
      PhorgeRevisionStatusFields(name: data.get(#name, or: $value.name));

  @override
  PhorgeRevisionStatusFieldsCopyWith<$R2, PhorgeRevisionStatusFields, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeRevisionStatusFieldsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PhorgeRevisionDataMapper extends ClassMapperBase<PhorgeRevisionData> {
  PhorgeRevisionDataMapper._();

  static PhorgeRevisionDataMapper? _instance;
  static PhorgeRevisionDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeRevisionDataMapper._());
      PhorgeRevisionFieldsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeRevisionData';

  static int _$id(PhorgeRevisionData v) => v.id;
  static const Field<PhorgeRevisionData, int> _f$id = Field('id', _$id);
  static String _$phid(PhorgeRevisionData v) => v.phid;
  static const Field<PhorgeRevisionData, String> _f$phid = Field(
    'phid',
    _$phid,
  );
  static PhorgeRevisionFields _$fields(PhorgeRevisionData v) => v.fields;
  static const Field<PhorgeRevisionData, PhorgeRevisionFields> _f$fields =
      Field('fields', _$fields);

  @override
  final MappableFields<PhorgeRevisionData> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #fields: _f$fields,
  };

  static PhorgeRevisionData _instantiate(DecodingData data) {
    return PhorgeRevisionData(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      fields: data.dec(_f$fields),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeRevisionData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeRevisionData>(map);
  }

  static PhorgeRevisionData fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeRevisionData>(json);
  }
}

mixin PhorgeRevisionDataMappable {
  String toJson() {
    return PhorgeRevisionDataMapper.ensureInitialized()
        .encodeJson<PhorgeRevisionData>(this as PhorgeRevisionData);
  }

  Map<String, dynamic> toMap() {
    return PhorgeRevisionDataMapper.ensureInitialized()
        .encodeMap<PhorgeRevisionData>(this as PhorgeRevisionData);
  }

  PhorgeRevisionDataCopyWith<
    PhorgeRevisionData,
    PhorgeRevisionData,
    PhorgeRevisionData
  >
  get copyWith =>
      _PhorgeRevisionDataCopyWithImpl<PhorgeRevisionData, PhorgeRevisionData>(
        this as PhorgeRevisionData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhorgeRevisionDataMapper.ensureInitialized().stringifyValue(
      this as PhorgeRevisionData,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeRevisionDataMapper.ensureInitialized().equalsValue(
      this as PhorgeRevisionData,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeRevisionDataMapper.ensureInitialized().hashValue(
      this as PhorgeRevisionData,
    );
  }
}

extension PhorgeRevisionDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeRevisionData, $Out> {
  PhorgeRevisionDataCopyWith<$R, PhorgeRevisionData, $Out>
  get $asPhorgeRevisionData => $base.as(
    (v, t, t2) => _PhorgeRevisionDataCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeRevisionDataCopyWith<
  $R,
  $In extends PhorgeRevisionData,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeRevisionFieldsCopyWith<$R, PhorgeRevisionFields, PhorgeRevisionFields>
  get fields;
  $R call({int? id, String? phid, PhorgeRevisionFields? fields});
  PhorgeRevisionDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeRevisionDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeRevisionData, $Out>
    implements PhorgeRevisionDataCopyWith<$R, PhorgeRevisionData, $Out> {
  _PhorgeRevisionDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeRevisionData> $mapper =
      PhorgeRevisionDataMapper.ensureInitialized();
  @override
  PhorgeRevisionFieldsCopyWith<$R, PhorgeRevisionFields, PhorgeRevisionFields>
  get fields => $value.fields.copyWith.$chain((v) => call(fields: v));
  @override
  $R call({int? id, String? phid, PhorgeRevisionFields? fields}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (fields != null) #fields: fields,
    }),
  );
  @override
  PhorgeRevisionData $make(CopyWithData data) => PhorgeRevisionData(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    fields: data.get(#fields, or: $value.fields),
  );

  @override
  PhorgeRevisionDataCopyWith<$R2, PhorgeRevisionData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeRevisionDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

