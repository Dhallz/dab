// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_revision_fields.dart';

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

