// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'linear_issue_dto.dart';

class LinearIssueDtoMapper extends ClassMapperBase<LinearIssueDto> {
  LinearIssueDtoMapper._();

  static LinearIssueDtoMapper? _instance;
  static LinearIssueDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LinearIssueDtoMapper._());
      LinearIssueCommentDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LinearIssueDto';

  static String _$identifier(LinearIssueDto v) => v.identifier;
  static const Field<LinearIssueDto, String> _f$identifier = Field(
    'identifier',
    _$identifier,
  );
  static String _$teamKey(LinearIssueDto v) => v.teamKey;
  static const Field<LinearIssueDto, String> _f$teamKey = Field(
    'teamKey',
    _$teamKey,
  );
  static String _$title(LinearIssueDto v) => v.title;
  static const Field<LinearIssueDto, String> _f$title = Field('title', _$title);
  static String _$statusName(LinearIssueDto v) => v.statusName;
  static const Field<LinearIssueDto, String> _f$statusName = Field(
    'statusName',
    _$statusName,
  );
  static String _$url(LinearIssueDto v) => v.url;
  static const Field<LinearIssueDto, String> _f$url = Field('url', _$url);
  static DateTime _$updatedAt(LinearIssueDto v) => v.updatedAt;
  static const Field<LinearIssueDto, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static String? _$dabUserId(LinearIssueDto v) => v.dabUserId;
  static const Field<LinearIssueDto, String> _f$dabUserId = Field(
    'dabUserId',
    _$dabUserId,
    opt: true,
  );
  static String? _$authorDisplayName(LinearIssueDto v) => v.authorDisplayName;
  static const Field<LinearIssueDto, String> _f$authorDisplayName = Field(
    'authorDisplayName',
    _$authorDisplayName,
    opt: true,
  );
  static List<LinearIssueCommentDto> _$comments(LinearIssueDto v) => v.comments;
  static const Field<LinearIssueDto, List<LinearIssueCommentDto>> _f$comments =
      Field('comments', _$comments, opt: true, def: const []);
  static bool _$includeIssueSnapshot(LinearIssueDto v) =>
      v.includeIssueSnapshot;
  static const Field<LinearIssueDto, bool> _f$includeIssueSnapshot = Field(
    'includeIssueSnapshot',
    _$includeIssueSnapshot,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<LinearIssueDto> fields = const {
    #identifier: _f$identifier,
    #teamKey: _f$teamKey,
    #title: _f$title,
    #statusName: _f$statusName,
    #url: _f$url,
    #updatedAt: _f$updatedAt,
    #dabUserId: _f$dabUserId,
    #authorDisplayName: _f$authorDisplayName,
    #comments: _f$comments,
    #includeIssueSnapshot: _f$includeIssueSnapshot,
  };

  static LinearIssueDto _instantiate(DecodingData data) {
    return LinearIssueDto(
      identifier: data.dec(_f$identifier),
      teamKey: data.dec(_f$teamKey),
      title: data.dec(_f$title),
      statusName: data.dec(_f$statusName),
      url: data.dec(_f$url),
      updatedAt: data.dec(_f$updatedAt),
      dabUserId: data.dec(_f$dabUserId),
      authorDisplayName: data.dec(_f$authorDisplayName),
      comments: data.dec(_f$comments),
      includeIssueSnapshot: data.dec(_f$includeIssueSnapshot),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LinearIssueDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LinearIssueDto>(map);
  }

  static LinearIssueDto fromJson(String json) {
    return ensureInitialized().decodeJson<LinearIssueDto>(json);
  }
}

mixin LinearIssueDtoMappable {
  String toJson() {
    return LinearIssueDtoMapper.ensureInitialized().encodeJson<LinearIssueDto>(
      this as LinearIssueDto,
    );
  }

  Map<String, dynamic> toMap() {
    return LinearIssueDtoMapper.ensureInitialized().encodeMap<LinearIssueDto>(
      this as LinearIssueDto,
    );
  }

  LinearIssueDtoCopyWith<LinearIssueDto, LinearIssueDto, LinearIssueDto>
  get copyWith => _LinearIssueDtoCopyWithImpl<LinearIssueDto, LinearIssueDto>(
    this as LinearIssueDto,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return LinearIssueDtoMapper.ensureInitialized().stringifyValue(
      this as LinearIssueDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return LinearIssueDtoMapper.ensureInitialized().equalsValue(
      this as LinearIssueDto,
      other,
    );
  }

  @override
  int get hashCode {
    return LinearIssueDtoMapper.ensureInitialized().hashValue(
      this as LinearIssueDto,
    );
  }
}

extension LinearIssueDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LinearIssueDto, $Out> {
  LinearIssueDtoCopyWith<$R, LinearIssueDto, $Out> get $asLinearIssueDto =>
      $base.as((v, t, t2) => _LinearIssueDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LinearIssueDtoCopyWith<$R, $In extends LinearIssueDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    LinearIssueCommentDto,
    LinearIssueCommentDtoCopyWith<
      $R,
      LinearIssueCommentDto,
      LinearIssueCommentDto
    >
  >
  get comments;
  $R call({
    String? identifier,
    String? teamKey,
    String? title,
    String? statusName,
    String? url,
    DateTime? updatedAt,
    String? dabUserId,
    String? authorDisplayName,
    List<LinearIssueCommentDto>? comments,
    bool? includeIssueSnapshot,
  });
  LinearIssueDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LinearIssueDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LinearIssueDto, $Out>
    implements LinearIssueDtoCopyWith<$R, LinearIssueDto, $Out> {
  _LinearIssueDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LinearIssueDto> $mapper =
      LinearIssueDtoMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    LinearIssueCommentDto,
    LinearIssueCommentDtoCopyWith<
      $R,
      LinearIssueCommentDto,
      LinearIssueCommentDto
    >
  >
  get comments => ListCopyWith(
    $value.comments,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(comments: v),
  );
  @override
  $R call({
    String? identifier,
    String? teamKey,
    String? title,
    String? statusName,
    String? url,
    DateTime? updatedAt,
    Object? dabUserId = $none,
    Object? authorDisplayName = $none,
    List<LinearIssueCommentDto>? comments,
    bool? includeIssueSnapshot,
  }) => $apply(
    FieldCopyWithData({
      if (identifier != null) #identifier: identifier,
      if (teamKey != null) #teamKey: teamKey,
      if (title != null) #title: title,
      if (statusName != null) #statusName: statusName,
      if (url != null) #url: url,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (dabUserId != $none) #dabUserId: dabUserId,
      if (authorDisplayName != $none) #authorDisplayName: authorDisplayName,
      if (comments != null) #comments: comments,
      if (includeIssueSnapshot != null)
        #includeIssueSnapshot: includeIssueSnapshot,
    }),
  );
  @override
  LinearIssueDto $make(CopyWithData data) => LinearIssueDto(
    identifier: data.get(#identifier, or: $value.identifier),
    teamKey: data.get(#teamKey, or: $value.teamKey),
    title: data.get(#title, or: $value.title),
    statusName: data.get(#statusName, or: $value.statusName),
    url: data.get(#url, or: $value.url),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    dabUserId: data.get(#dabUserId, or: $value.dabUserId),
    authorDisplayName: data.get(
      #authorDisplayName,
      or: $value.authorDisplayName,
    ),
    comments: data.get(#comments, or: $value.comments),
    includeIssueSnapshot: data.get(
      #includeIssueSnapshot,
      or: $value.includeIssueSnapshot,
    ),
  );

  @override
  LinearIssueDtoCopyWith<$R2, LinearIssueDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LinearIssueDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LinearIssueCommentDtoMapper
    extends ClassMapperBase<LinearIssueCommentDto> {
  LinearIssueCommentDtoMapper._();

  static LinearIssueCommentDtoMapper? _instance;
  static LinearIssueCommentDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LinearIssueCommentDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LinearIssueCommentDto';

  static String _$id(LinearIssueCommentDto v) => v.id;
  static const Field<LinearIssueCommentDto, String> _f$id = Field('id', _$id);
  static String _$body(LinearIssueCommentDto v) => v.body;
  static const Field<LinearIssueCommentDto, String> _f$body = Field(
    'body',
    _$body,
  );
  static DateTime _$createdAt(LinearIssueCommentDto v) => v.createdAt;
  static const Field<LinearIssueCommentDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static String? _$dabUserId(LinearIssueCommentDto v) => v.dabUserId;
  static const Field<LinearIssueCommentDto, String> _f$dabUserId = Field(
    'dabUserId',
    _$dabUserId,
    opt: true,
  );
  static String? _$authorDisplayName(LinearIssueCommentDto v) =>
      v.authorDisplayName;
  static const Field<LinearIssueCommentDto, String> _f$authorDisplayName =
      Field('authorDisplayName', _$authorDisplayName, opt: true);

  @override
  final MappableFields<LinearIssueCommentDto> fields = const {
    #id: _f$id,
    #body: _f$body,
    #createdAt: _f$createdAt,
    #dabUserId: _f$dabUserId,
    #authorDisplayName: _f$authorDisplayName,
  };

  static LinearIssueCommentDto _instantiate(DecodingData data) {
    return LinearIssueCommentDto(
      id: data.dec(_f$id),
      body: data.dec(_f$body),
      createdAt: data.dec(_f$createdAt),
      dabUserId: data.dec(_f$dabUserId),
      authorDisplayName: data.dec(_f$authorDisplayName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LinearIssueCommentDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LinearIssueCommentDto>(map);
  }

  static LinearIssueCommentDto fromJson(String json) {
    return ensureInitialized().decodeJson<LinearIssueCommentDto>(json);
  }
}

mixin LinearIssueCommentDtoMappable {
  String toJson() {
    return LinearIssueCommentDtoMapper.ensureInitialized()
        .encodeJson<LinearIssueCommentDto>(this as LinearIssueCommentDto);
  }

  Map<String, dynamic> toMap() {
    return LinearIssueCommentDtoMapper.ensureInitialized()
        .encodeMap<LinearIssueCommentDto>(this as LinearIssueCommentDto);
  }

  LinearIssueCommentDtoCopyWith<
    LinearIssueCommentDto,
    LinearIssueCommentDto,
    LinearIssueCommentDto
  >
  get copyWith =>
      _LinearIssueCommentDtoCopyWithImpl<
        LinearIssueCommentDto,
        LinearIssueCommentDto
      >(this as LinearIssueCommentDto, $identity, $identity);
  @override
  String toString() {
    return LinearIssueCommentDtoMapper.ensureInitialized().stringifyValue(
      this as LinearIssueCommentDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return LinearIssueCommentDtoMapper.ensureInitialized().equalsValue(
      this as LinearIssueCommentDto,
      other,
    );
  }

  @override
  int get hashCode {
    return LinearIssueCommentDtoMapper.ensureInitialized().hashValue(
      this as LinearIssueCommentDto,
    );
  }
}

extension LinearIssueCommentDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LinearIssueCommentDto, $Out> {
  LinearIssueCommentDtoCopyWith<$R, LinearIssueCommentDto, $Out>
  get $asLinearIssueCommentDto => $base.as(
    (v, t, t2) => _LinearIssueCommentDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LinearIssueCommentDtoCopyWith<
  $R,
  $In extends LinearIssueCommentDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? body,
    DateTime? createdAt,
    String? dabUserId,
    String? authorDisplayName,
  });
  LinearIssueCommentDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LinearIssueCommentDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LinearIssueCommentDto, $Out>
    implements LinearIssueCommentDtoCopyWith<$R, LinearIssueCommentDto, $Out> {
  _LinearIssueCommentDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LinearIssueCommentDto> $mapper =
      LinearIssueCommentDtoMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? body,
    DateTime? createdAt,
    Object? dabUserId = $none,
    Object? authorDisplayName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (body != null) #body: body,
      if (createdAt != null) #createdAt: createdAt,
      if (dabUserId != $none) #dabUserId: dabUserId,
      if (authorDisplayName != $none) #authorDisplayName: authorDisplayName,
    }),
  );
  @override
  LinearIssueCommentDto $make(CopyWithData data) => LinearIssueCommentDto(
    id: data.get(#id, or: $value.id),
    body: data.get(#body, or: $value.body),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    dabUserId: data.get(#dabUserId, or: $value.dabUserId),
    authorDisplayName: data.get(
      #authorDisplayName,
      or: $value.authorDisplayName,
    ),
  );

  @override
  LinearIssueCommentDtoCopyWith<$R2, LinearIssueCommentDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LinearIssueCommentDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

