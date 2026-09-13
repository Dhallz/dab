// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'figma_file_dto.dart';

class FigmaFileDtoMapper extends ClassMapperBase<FigmaFileDto> {
  FigmaFileDtoMapper._();

  static FigmaFileDtoMapper? _instance;
  static FigmaFileDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FigmaFileDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FigmaFileDto';

  static String _$fileKey(FigmaFileDto v) => v.fileKey;
  static const Field<FigmaFileDto, String> _f$fileKey = Field(
    'fileKey',
    _$fileKey,
  );
  static String _$fileName(FigmaFileDto v) => v.fileName;
  static const Field<FigmaFileDto, String> _f$fileName = Field(
    'fileName',
    _$fileName,
  );
  static DateTime _$createdAt(FigmaFileDto v) => v.createdAt;
  static const Field<FigmaFileDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static String? _$commentId(FigmaFileDto v) => v.commentId;
  static const Field<FigmaFileDto, String> _f$commentId = Field(
    'commentId',
    _$commentId,
    opt: true,
  );
  static String? _$commentMessage(FigmaFileDto v) => v.commentMessage;
  static const Field<FigmaFileDto, String> _f$commentMessage = Field(
    'commentMessage',
    _$commentMessage,
    opt: true,
  );
  static String? _$parentId(FigmaFileDto v) => v.parentId;
  static const Field<FigmaFileDto, String> _f$parentId = Field(
    'parentId',
    _$parentId,
    opt: true,
  );
  static String? _$authorId(FigmaFileDto v) => v.authorId;
  static const Field<FigmaFileDto, String> _f$authorId = Field(
    'authorId',
    _$authorId,
    opt: true,
  );
  static String? _$authorHandle(FigmaFileDto v) => v.authorHandle;
  static const Field<FigmaFileDto, String> _f$authorHandle = Field(
    'authorHandle',
    _$authorHandle,
    opt: true,
  );
  static List<String> _$mentionIds(FigmaFileDto v) => v.mentionIds;
  static const Field<FigmaFileDto, List<String>> _f$mentionIds = Field(
    'mentionIds',
    _$mentionIds,
    opt: true,
    def: const [],
  );
  static bool _$lastEdited(FigmaFileDto v) => v.lastEdited;
  static const Field<FigmaFileDto, bool> _f$lastEdited = Field(
    'lastEdited',
    _$lastEdited,
    opt: true,
    def: false,
  );
  static String? _$dabUserId(FigmaFileDto v) => v.dabUserId;
  static const Field<FigmaFileDto, String> _f$dabUserId = Field(
    'dabUserId',
    _$dabUserId,
    opt: true,
  );

  @override
  final MappableFields<FigmaFileDto> fields = const {
    #fileKey: _f$fileKey,
    #fileName: _f$fileName,
    #createdAt: _f$createdAt,
    #commentId: _f$commentId,
    #commentMessage: _f$commentMessage,
    #parentId: _f$parentId,
    #authorId: _f$authorId,
    #authorHandle: _f$authorHandle,
    #mentionIds: _f$mentionIds,
    #lastEdited: _f$lastEdited,
    #dabUserId: _f$dabUserId,
  };

  static FigmaFileDto _instantiate(DecodingData data) {
    return FigmaFileDto(
      fileKey: data.dec(_f$fileKey),
      fileName: data.dec(_f$fileName),
      createdAt: data.dec(_f$createdAt),
      commentId: data.dec(_f$commentId),
      commentMessage: data.dec(_f$commentMessage),
      parentId: data.dec(_f$parentId),
      authorId: data.dec(_f$authorId),
      authorHandle: data.dec(_f$authorHandle),
      mentionIds: data.dec(_f$mentionIds),
      lastEdited: data.dec(_f$lastEdited),
      dabUserId: data.dec(_f$dabUserId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FigmaFileDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FigmaFileDto>(map);
  }

  static FigmaFileDto fromJson(String json) {
    return ensureInitialized().decodeJson<FigmaFileDto>(json);
  }
}

mixin FigmaFileDtoMappable {
  String toJson() {
    return FigmaFileDtoMapper.ensureInitialized().encodeJson<FigmaFileDto>(
      this as FigmaFileDto,
    );
  }

  Map<String, dynamic> toMap() {
    return FigmaFileDtoMapper.ensureInitialized().encodeMap<FigmaFileDto>(
      this as FigmaFileDto,
    );
  }

  FigmaFileDtoCopyWith<FigmaFileDto, FigmaFileDto, FigmaFileDto> get copyWith =>
      _FigmaFileDtoCopyWithImpl<FigmaFileDto, FigmaFileDto>(
        this as FigmaFileDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FigmaFileDtoMapper.ensureInitialized().stringifyValue(
      this as FigmaFileDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return FigmaFileDtoMapper.ensureInitialized().equalsValue(
      this as FigmaFileDto,
      other,
    );
  }

  @override
  int get hashCode {
    return FigmaFileDtoMapper.ensureInitialized().hashValue(
      this as FigmaFileDto,
    );
  }
}

extension FigmaFileDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FigmaFileDto, $Out> {
  FigmaFileDtoCopyWith<$R, FigmaFileDto, $Out> get $asFigmaFileDto =>
      $base.as((v, t, t2) => _FigmaFileDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FigmaFileDtoCopyWith<$R, $In extends FigmaFileDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get mentionIds;
  $R call({
    String? fileKey,
    String? fileName,
    DateTime? createdAt,
    String? commentId,
    String? commentMessage,
    String? parentId,
    String? authorId,
    String? authorHandle,
    List<String>? mentionIds,
    bool? lastEdited,
    String? dabUserId,
  });
  FigmaFileDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FigmaFileDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FigmaFileDto, $Out>
    implements FigmaFileDtoCopyWith<$R, FigmaFileDto, $Out> {
  _FigmaFileDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FigmaFileDto> $mapper =
      FigmaFileDtoMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get mentionIds =>
      ListCopyWith(
        $value.mentionIds,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(mentionIds: v),
      );
  @override
  $R call({
    String? fileKey,
    String? fileName,
    DateTime? createdAt,
    Object? commentId = $none,
    Object? commentMessage = $none,
    Object? parentId = $none,
    Object? authorId = $none,
    Object? authorHandle = $none,
    List<String>? mentionIds,
    bool? lastEdited,
    Object? dabUserId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (fileKey != null) #fileKey: fileKey,
      if (fileName != null) #fileName: fileName,
      if (createdAt != null) #createdAt: createdAt,
      if (commentId != $none) #commentId: commentId,
      if (commentMessage != $none) #commentMessage: commentMessage,
      if (parentId != $none) #parentId: parentId,
      if (authorId != $none) #authorId: authorId,
      if (authorHandle != $none) #authorHandle: authorHandle,
      if (mentionIds != null) #mentionIds: mentionIds,
      if (lastEdited != null) #lastEdited: lastEdited,
      if (dabUserId != $none) #dabUserId: dabUserId,
    }),
  );
  @override
  FigmaFileDto $make(CopyWithData data) => FigmaFileDto(
    fileKey: data.get(#fileKey, or: $value.fileKey),
    fileName: data.get(#fileName, or: $value.fileName),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    commentId: data.get(#commentId, or: $value.commentId),
    commentMessage: data.get(#commentMessage, or: $value.commentMessage),
    parentId: data.get(#parentId, or: $value.parentId),
    authorId: data.get(#authorId, or: $value.authorId),
    authorHandle: data.get(#authorHandle, or: $value.authorHandle),
    mentionIds: data.get(#mentionIds, or: $value.mentionIds),
    lastEdited: data.get(#lastEdited, or: $value.lastEdited),
    dabUserId: data.get(#dabUserId, or: $value.dabUserId),
  );

  @override
  FigmaFileDtoCopyWith<$R2, FigmaFileDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FigmaFileDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

