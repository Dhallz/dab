// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_revision_data.dart';

class PhorgeRevisionDataMapper extends ClassMapperBase<PhorgeRevisionData> {
  PhorgeRevisionDataMapper._();

  static PhorgeRevisionDataMapper? _instance;
  static PhorgeRevisionDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeRevisionDataMapper._());
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
  static String _$authorPHID(PhorgeRevisionData v) => v.authorPHID;
  static const Field<PhorgeRevisionData, String> _f$authorPHID = Field(
    'authorPHID',
    _$authorPHID,
  );
  static String _$title(PhorgeRevisionData v) => v.title;
  static const Field<PhorgeRevisionData, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$uri(PhorgeRevisionData v) => v.uri;
  static const Field<PhorgeRevisionData, String> _f$uri = Field('uri', _$uri);
  static String _$statusName(PhorgeRevisionData v) => v.statusName;
  static const Field<PhorgeRevisionData, String> _f$statusName = Field(
    'statusName',
    _$statusName,
  );
  static DateTime _$dateModified(PhorgeRevisionData v) => v.dateModified;
  static const Field<PhorgeRevisionData, DateTime> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
  );

  @override
  final MappableFields<PhorgeRevisionData> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #authorPHID: _f$authorPHID,
    #title: _f$title,
    #uri: _f$uri,
    #statusName: _f$statusName,
    #dateModified: _f$dateModified,
  };

  static PhorgeRevisionData _instantiate(DecodingData data) {
    return PhorgeRevisionData(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      authorPHID: data.dec(_f$authorPHID),
      title: data.dec(_f$title),
      uri: data.dec(_f$uri),
      statusName: data.dec(_f$statusName),
      dateModified: data.dec(_f$dateModified),
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
  $R call({
    int? id,
    String? phid,
    String? authorPHID,
    String? title,
    String? uri,
    String? statusName,
    DateTime? dateModified,
  });
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
  $R call({
    int? id,
    String? phid,
    String? authorPHID,
    String? title,
    String? uri,
    String? statusName,
    DateTime? dateModified,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (authorPHID != null) #authorPHID: authorPHID,
      if (title != null) #title: title,
      if (uri != null) #uri: uri,
      if (statusName != null) #statusName: statusName,
      if (dateModified != null) #dateModified: dateModified,
    }),
  );
  @override
  PhorgeRevisionData $make(CopyWithData data) => PhorgeRevisionData(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    authorPHID: data.get(#authorPHID, or: $value.authorPHID),
    title: data.get(#title, or: $value.title),
    uri: data.get(#uri, or: $value.uri),
    statusName: data.get(#statusName, or: $value.statusName),
    dateModified: data.get(#dateModified, or: $value.dateModified),
  );

  @override
  PhorgeRevisionDataCopyWith<$R2, PhorgeRevisionData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeRevisionDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

