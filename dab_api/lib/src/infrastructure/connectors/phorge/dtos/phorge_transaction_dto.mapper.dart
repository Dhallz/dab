// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_transaction_dto.dart';

class PhorgeTransactionDtoMapper extends ClassMapperBase<PhorgeTransactionDto> {
  PhorgeTransactionDtoMapper._();

  static PhorgeTransactionDtoMapper? _instance;
  static PhorgeTransactionDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTransactionDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTransactionDto';

  static int _$id(PhorgeTransactionDto v) => v.id;
  static const Field<PhorgeTransactionDto, int> _f$id = Field('id', _$id);
  static String _$phid(PhorgeTransactionDto v) => v.phid;
  static const Field<PhorgeTransactionDto, String> _f$phid = Field(
    'phid',
    _$phid,
  );
  static String _$objectPHID(PhorgeTransactionDto v) => v.objectPHID;
  static const Field<PhorgeTransactionDto, String> _f$objectPHID = Field(
    'objectPHID',
    _$objectPHID,
  );
  static String _$authorPHID(PhorgeTransactionDto v) => v.authorPHID;
  static const Field<PhorgeTransactionDto, String> _f$authorPHID = Field(
    'authorPHID',
    _$authorPHID,
  );
  static String _$type(PhorgeTransactionDto v) => v.type;
  static const Field<PhorgeTransactionDto, String> _f$type = Field(
    'type',
    _$type,
  );
  static dynamic _$oldValue(PhorgeTransactionDto v) => v.oldValue;
  static const Field<PhorgeTransactionDto, dynamic> _f$oldValue = Field(
    'oldValue',
    _$oldValue,
    opt: true,
  );
  static dynamic _$newValue(PhorgeTransactionDto v) => v.newValue;
  static const Field<PhorgeTransactionDto, dynamic> _f$newValue = Field(
    'newValue',
    _$newValue,
    opt: true,
  );
  static String? _$commentText(PhorgeTransactionDto v) => v.commentText;
  static const Field<PhorgeTransactionDto, String> _f$commentText = Field(
    'commentText',
    _$commentText,
    opt: true,
  );
  static DateTime _$dateCreated(PhorgeTransactionDto v) => v.dateCreated;
  static const Field<PhorgeTransactionDto, DateTime> _f$dateCreated = Field(
    'dateCreated',
    _$dateCreated,
  );

  @override
  final MappableFields<PhorgeTransactionDto> fields = const {
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

  static PhorgeTransactionDto _instantiate(DecodingData data) {
    return PhorgeTransactionDto(
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

  static PhorgeTransactionDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTransactionDto>(map);
  }

  static PhorgeTransactionDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTransactionDto>(json);
  }
}

mixin PhorgeTransactionDtoMappable {
  String toJson() {
    return PhorgeTransactionDtoMapper.ensureInitialized()
        .encodeJson<PhorgeTransactionDto>(this as PhorgeTransactionDto);
  }

  Map<String, dynamic> toMap() {
    return PhorgeTransactionDtoMapper.ensureInitialized()
        .encodeMap<PhorgeTransactionDto>(this as PhorgeTransactionDto);
  }

  PhorgeTransactionDtoCopyWith<
    PhorgeTransactionDto,
    PhorgeTransactionDto,
    PhorgeTransactionDto
  >
  get copyWith =>
      _PhorgeTransactionDtoCopyWithImpl<
        PhorgeTransactionDto,
        PhorgeTransactionDto
      >(this as PhorgeTransactionDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeTransactionDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeTransactionDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTransactionDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeTransactionDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTransactionDtoMapper.ensureInitialized().hashValue(
      this as PhorgeTransactionDto,
    );
  }
}

extension PhorgeTransactionDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTransactionDto, $Out> {
  PhorgeTransactionDtoCopyWith<$R, PhorgeTransactionDto, $Out>
  get $asPhorgeTransactionDto => $base.as(
    (v, t, t2) => _PhorgeTransactionDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTransactionDtoCopyWith<
  $R,
  $In extends PhorgeTransactionDto,
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
  PhorgeTransactionDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTransactionDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTransactionDto, $Out>
    implements PhorgeTransactionDtoCopyWith<$R, PhorgeTransactionDto, $Out> {
  _PhorgeTransactionDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTransactionDto> $mapper =
      PhorgeTransactionDtoMapper.ensureInitialized();
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
  PhorgeTransactionDto $make(CopyWithData data) => PhorgeTransactionDto(
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
  PhorgeTransactionDtoCopyWith<$R2, PhorgeTransactionDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTransactionDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

