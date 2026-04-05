// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_transaction_data.dart';

class PhorgeTransactionDataMapper
    extends ClassMapperBase<PhorgeTransactionData> {
  PhorgeTransactionDataMapper._();

  static PhorgeTransactionDataMapper? _instance;
  static PhorgeTransactionDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTransactionDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTransactionData';

  static int _$id(PhorgeTransactionData v) => v.id;
  static const Field<PhorgeTransactionData, int> _f$id = Field('id', _$id);
  static String _$phid(PhorgeTransactionData v) => v.phid;
  static const Field<PhorgeTransactionData, String> _f$phid = Field(
    'phid',
    _$phid,
  );
  static String _$objectPHID(PhorgeTransactionData v) => v.objectPHID;
  static const Field<PhorgeTransactionData, String> _f$objectPHID = Field(
    'objectPHID',
    _$objectPHID,
  );
  static String _$authorPHID(PhorgeTransactionData v) => v.authorPHID;
  static const Field<PhorgeTransactionData, String> _f$authorPHID = Field(
    'authorPHID',
    _$authorPHID,
  );
  static String _$type(PhorgeTransactionData v) => v.type;
  static const Field<PhorgeTransactionData, String> _f$type = Field(
    'type',
    _$type,
  );
  static dynamic _$oldValue(PhorgeTransactionData v) => v.oldValue;
  static const Field<PhorgeTransactionData, dynamic> _f$oldValue = Field(
    'oldValue',
    _$oldValue,
    opt: true,
  );
  static dynamic _$newValue(PhorgeTransactionData v) => v.newValue;
  static const Field<PhorgeTransactionData, dynamic> _f$newValue = Field(
    'newValue',
    _$newValue,
    opt: true,
  );
  static String? _$commentText(PhorgeTransactionData v) => v.commentText;
  static const Field<PhorgeTransactionData, String> _f$commentText = Field(
    'commentText',
    _$commentText,
    opt: true,
  );
  static DateTime _$dateCreated(PhorgeTransactionData v) => v.dateCreated;
  static const Field<PhorgeTransactionData, DateTime> _f$dateCreated = Field(
    'dateCreated',
    _$dateCreated,
  );

  @override
  final MappableFields<PhorgeTransactionData> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #objectPHID: _f$objectPHID,
    #authorPHID: _f$authorPHID,
    #type: _f$type,
    #oldValue: _f$oldValue,
    #newValue: _f$newValue,
    #commentText: _f$commentText,
    #dateCreated: _f$dateCreated,
  };

  static PhorgeTransactionData _instantiate(DecodingData data) {
    return PhorgeTransactionData(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      objectPHID: data.dec(_f$objectPHID),
      authorPHID: data.dec(_f$authorPHID),
      type: data.dec(_f$type),
      oldValue: data.dec(_f$oldValue),
      newValue: data.dec(_f$newValue),
      commentText: data.dec(_f$commentText),
      dateCreated: data.dec(_f$dateCreated),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTransactionData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTransactionData>(map);
  }

  static PhorgeTransactionData fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTransactionData>(json);
  }
}

mixin PhorgeTransactionDataMappable {
  String toJson() {
    return PhorgeTransactionDataMapper.ensureInitialized()
        .encodeJson<PhorgeTransactionData>(this as PhorgeTransactionData);
  }

  Map<String, dynamic> toMap() {
    return PhorgeTransactionDataMapper.ensureInitialized()
        .encodeMap<PhorgeTransactionData>(this as PhorgeTransactionData);
  }

  PhorgeTransactionDataCopyWith<
    PhorgeTransactionData,
    PhorgeTransactionData,
    PhorgeTransactionData
  >
  get copyWith =>
      _PhorgeTransactionDataCopyWithImpl<
        PhorgeTransactionData,
        PhorgeTransactionData
      >(this as PhorgeTransactionData, $identity, $identity);
  @override
  String toString() {
    return PhorgeTransactionDataMapper.ensureInitialized().stringifyValue(
      this as PhorgeTransactionData,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTransactionDataMapper.ensureInitialized().equalsValue(
      this as PhorgeTransactionData,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTransactionDataMapper.ensureInitialized().hashValue(
      this as PhorgeTransactionData,
    );
  }
}

extension PhorgeTransactionDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTransactionData, $Out> {
  PhorgeTransactionDataCopyWith<$R, PhorgeTransactionData, $Out>
  get $asPhorgeTransactionData => $base.as(
    (v, t, t2) => _PhorgeTransactionDataCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTransactionDataCopyWith<
  $R,
  $In extends PhorgeTransactionData,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? phid,
    String? objectPHID,
    String? authorPHID,
    String? type,
    dynamic oldValue,
    dynamic newValue,
    String? commentText,
    DateTime? dateCreated,
  });
  PhorgeTransactionDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTransactionDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTransactionData, $Out>
    implements PhorgeTransactionDataCopyWith<$R, PhorgeTransactionData, $Out> {
  _PhorgeTransactionDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTransactionData> $mapper =
      PhorgeTransactionDataMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? phid,
    String? objectPHID,
    String? authorPHID,
    String? type,
    Object? oldValue = $none,
    Object? newValue = $none,
    Object? commentText = $none,
    DateTime? dateCreated,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (objectPHID != null) #objectPHID: objectPHID,
      if (authorPHID != null) #authorPHID: authorPHID,
      if (type != null) #type: type,
      if (oldValue != $none) #oldValue: oldValue,
      if (newValue != $none) #newValue: newValue,
      if (commentText != $none) #commentText: commentText,
      if (dateCreated != null) #dateCreated: dateCreated,
    }),
  );
  @override
  PhorgeTransactionData $make(CopyWithData data) => PhorgeTransactionData(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    objectPHID: data.get(#objectPHID, or: $value.objectPHID),
    authorPHID: data.get(#authorPHID, or: $value.authorPHID),
    type: data.get(#type, or: $value.type),
    oldValue: data.get(#oldValue, or: $value.oldValue),
    newValue: data.get(#newValue, or: $value.newValue),
    commentText: data.get(#commentText, or: $value.commentText),
    dateCreated: data.get(#dateCreated, or: $value.dateCreated),
  );

  @override
  PhorgeTransactionDataCopyWith<$R2, PhorgeTransactionData, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTransactionDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

