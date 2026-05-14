// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'jira_issue_dto.dart';

class JiraIssueDtoMapper extends ClassMapperBase<JiraIssueDto> {
  JiraIssueDtoMapper._();

  static JiraIssueDtoMapper? _instance;
  static JiraIssueDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JiraIssueDtoMapper._());
      JiraIssueCommentDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'JiraIssueDto';

  static String _$issueKey(JiraIssueDto v) => v.issueKey;
  static const Field<JiraIssueDto, String> _f$issueKey = Field(
    'issueKey',
    _$issueKey,
  );
  static String _$projectKey(JiraIssueDto v) => v.projectKey;
  static const Field<JiraIssueDto, String> _f$projectKey = Field(
    'projectKey',
    _$projectKey,
  );
  static String _$summary(JiraIssueDto v) => v.summary;
  static const Field<JiraIssueDto, String> _f$summary = Field(
    'summary',
    _$summary,
  );
  static String _$statusName(JiraIssueDto v) => v.statusName;
  static const Field<JiraIssueDto, String> _f$statusName = Field(
    'statusName',
    _$statusName,
  );
  static String _$browseUrl(JiraIssueDto v) => v.browseUrl;
  static const Field<JiraIssueDto, String> _f$browseUrl = Field(
    'browseUrl',
    _$browseUrl,
  );
  static DateTime _$updatedAt(JiraIssueDto v) => v.updatedAt;
  static const Field<JiraIssueDto, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static String _$siteHost(JiraIssueDto v) => v.siteHost;
  static const Field<JiraIssueDto, String> _f$siteHost = Field(
    'siteHost',
    _$siteHost,
  );
  static String? _$dabUserId(JiraIssueDto v) => v.dabUserId;
  static const Field<JiraIssueDto, String> _f$dabUserId = Field(
    'dabUserId',
    _$dabUserId,
    opt: true,
  );
  static String? _$authorDisplayName(JiraIssueDto v) => v.authorDisplayName;
  static const Field<JiraIssueDto, String> _f$authorDisplayName = Field(
    'authorDisplayName',
    _$authorDisplayName,
    opt: true,
  );
  static List<JiraIssueCommentDto> _$comments(JiraIssueDto v) => v.comments;
  static const Field<JiraIssueDto, List<JiraIssueCommentDto>> _f$comments =
      Field('comments', _$comments, opt: true, def: const []);

  @override
  final MappableFields<JiraIssueDto> fields = const {
    #issueKey: _f$issueKey,
    #projectKey: _f$projectKey,
    #summary: _f$summary,
    #statusName: _f$statusName,
    #browseUrl: _f$browseUrl,
    #updatedAt: _f$updatedAt,
    #siteHost: _f$siteHost,
    #dabUserId: _f$dabUserId,
    #authorDisplayName: _f$authorDisplayName,
    #comments: _f$comments,
  };

  static JiraIssueDto _instantiate(DecodingData data) {
    return JiraIssueDto(
      issueKey: data.dec(_f$issueKey),
      projectKey: data.dec(_f$projectKey),
      summary: data.dec(_f$summary),
      statusName: data.dec(_f$statusName),
      browseUrl: data.dec(_f$browseUrl),
      updatedAt: data.dec(_f$updatedAt),
      siteHost: data.dec(_f$siteHost),
      dabUserId: data.dec(_f$dabUserId),
      authorDisplayName: data.dec(_f$authorDisplayName),
      comments: data.dec(_f$comments),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JiraIssueDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JiraIssueDto>(map);
  }

  static JiraIssueDto fromJson(String json) {
    return ensureInitialized().decodeJson<JiraIssueDto>(json);
  }
}

mixin JiraIssueDtoMappable {
  String toJson() {
    return JiraIssueDtoMapper.ensureInitialized().encodeJson<JiraIssueDto>(
      this as JiraIssueDto,
    );
  }

  Map<String, dynamic> toMap() {
    return JiraIssueDtoMapper.ensureInitialized().encodeMap<JiraIssueDto>(
      this as JiraIssueDto,
    );
  }

  JiraIssueDtoCopyWith<JiraIssueDto, JiraIssueDto, JiraIssueDto> get copyWith =>
      _JiraIssueDtoCopyWithImpl<JiraIssueDto, JiraIssueDto>(
        this as JiraIssueDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return JiraIssueDtoMapper.ensureInitialized().stringifyValue(
      this as JiraIssueDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return JiraIssueDtoMapper.ensureInitialized().equalsValue(
      this as JiraIssueDto,
      other,
    );
  }

  @override
  int get hashCode {
    return JiraIssueDtoMapper.ensureInitialized().hashValue(
      this as JiraIssueDto,
    );
  }
}

extension JiraIssueDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JiraIssueDto, $Out> {
  JiraIssueDtoCopyWith<$R, JiraIssueDto, $Out> get $asJiraIssueDto =>
      $base.as((v, t, t2) => _JiraIssueDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class JiraIssueDtoCopyWith<$R, $In extends JiraIssueDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    JiraIssueCommentDto,
    JiraIssueCommentDtoCopyWith<$R, JiraIssueCommentDto, JiraIssueCommentDto>
  >
  get comments;
  $R call({
    String? issueKey,
    String? projectKey,
    String? summary,
    String? statusName,
    String? browseUrl,
    DateTime? updatedAt,
    String? siteHost,
    String? dabUserId,
    String? authorDisplayName,
    List<JiraIssueCommentDto>? comments,
  });
  JiraIssueDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _JiraIssueDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JiraIssueDto, $Out>
    implements JiraIssueDtoCopyWith<$R, JiraIssueDto, $Out> {
  _JiraIssueDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JiraIssueDto> $mapper =
      JiraIssueDtoMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    JiraIssueCommentDto,
    JiraIssueCommentDtoCopyWith<$R, JiraIssueCommentDto, JiraIssueCommentDto>
  >
  get comments => ListCopyWith(
    $value.comments,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(comments: v),
  );
  @override
  $R call({
    String? issueKey,
    String? projectKey,
    String? summary,
    String? statusName,
    String? browseUrl,
    DateTime? updatedAt,
    String? siteHost,
    Object? dabUserId = $none,
    Object? authorDisplayName = $none,
    List<JiraIssueCommentDto>? comments,
  }) => $apply(
    FieldCopyWithData({
      if (issueKey != null) #issueKey: issueKey,
      if (projectKey != null) #projectKey: projectKey,
      if (summary != null) #summary: summary,
      if (statusName != null) #statusName: statusName,
      if (browseUrl != null) #browseUrl: browseUrl,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (siteHost != null) #siteHost: siteHost,
      if (dabUserId != $none) #dabUserId: dabUserId,
      if (authorDisplayName != $none) #authorDisplayName: authorDisplayName,
      if (comments != null) #comments: comments,
    }),
  );
  @override
  JiraIssueDto $make(CopyWithData data) => JiraIssueDto(
    issueKey: data.get(#issueKey, or: $value.issueKey),
    projectKey: data.get(#projectKey, or: $value.projectKey),
    summary: data.get(#summary, or: $value.summary),
    statusName: data.get(#statusName, or: $value.statusName),
    browseUrl: data.get(#browseUrl, or: $value.browseUrl),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    siteHost: data.get(#siteHost, or: $value.siteHost),
    dabUserId: data.get(#dabUserId, or: $value.dabUserId),
    authorDisplayName: data.get(
      #authorDisplayName,
      or: $value.authorDisplayName,
    ),
    comments: data.get(#comments, or: $value.comments),
  );

  @override
  JiraIssueDtoCopyWith<$R2, JiraIssueDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _JiraIssueDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class JiraIssueCommentDtoMapper extends ClassMapperBase<JiraIssueCommentDto> {
  JiraIssueCommentDtoMapper._();

  static JiraIssueCommentDtoMapper? _instance;
  static JiraIssueCommentDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JiraIssueCommentDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'JiraIssueCommentDto';

  static String _$id(JiraIssueCommentDto v) => v.id;
  static const Field<JiraIssueCommentDto, String> _f$id = Field('id', _$id);
  static String _$body(JiraIssueCommentDto v) => v.body;
  static const Field<JiraIssueCommentDto, String> _f$body = Field(
    'body',
    _$body,
  );
  static DateTime _$createdAt(JiraIssueCommentDto v) => v.createdAt;
  static const Field<JiraIssueCommentDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static String? _$dabUserId(JiraIssueCommentDto v) => v.dabUserId;
  static const Field<JiraIssueCommentDto, String> _f$dabUserId = Field(
    'dabUserId',
    _$dabUserId,
    opt: true,
  );
  static String? _$authorDisplayName(JiraIssueCommentDto v) =>
      v.authorDisplayName;
  static const Field<JiraIssueCommentDto, String> _f$authorDisplayName = Field(
    'authorDisplayName',
    _$authorDisplayName,
    opt: true,
  );

  @override
  final MappableFields<JiraIssueCommentDto> fields = const {
    #id: _f$id,
    #body: _f$body,
    #createdAt: _f$createdAt,
    #dabUserId: _f$dabUserId,
    #authorDisplayName: _f$authorDisplayName,
  };

  static JiraIssueCommentDto _instantiate(DecodingData data) {
    return JiraIssueCommentDto(
      id: data.dec(_f$id),
      body: data.dec(_f$body),
      createdAt: data.dec(_f$createdAt),
      dabUserId: data.dec(_f$dabUserId),
      authorDisplayName: data.dec(_f$authorDisplayName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JiraIssueCommentDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JiraIssueCommentDto>(map);
  }

  static JiraIssueCommentDto fromJson(String json) {
    return ensureInitialized().decodeJson<JiraIssueCommentDto>(json);
  }
}

mixin JiraIssueCommentDtoMappable {
  String toJson() {
    return JiraIssueCommentDtoMapper.ensureInitialized()
        .encodeJson<JiraIssueCommentDto>(this as JiraIssueCommentDto);
  }

  Map<String, dynamic> toMap() {
    return JiraIssueCommentDtoMapper.ensureInitialized()
        .encodeMap<JiraIssueCommentDto>(this as JiraIssueCommentDto);
  }

  JiraIssueCommentDtoCopyWith<
    JiraIssueCommentDto,
    JiraIssueCommentDto,
    JiraIssueCommentDto
  >
  get copyWith =>
      _JiraIssueCommentDtoCopyWithImpl<
        JiraIssueCommentDto,
        JiraIssueCommentDto
      >(this as JiraIssueCommentDto, $identity, $identity);
  @override
  String toString() {
    return JiraIssueCommentDtoMapper.ensureInitialized().stringifyValue(
      this as JiraIssueCommentDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return JiraIssueCommentDtoMapper.ensureInitialized().equalsValue(
      this as JiraIssueCommentDto,
      other,
    );
  }

  @override
  int get hashCode {
    return JiraIssueCommentDtoMapper.ensureInitialized().hashValue(
      this as JiraIssueCommentDto,
    );
  }
}

extension JiraIssueCommentDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JiraIssueCommentDto, $Out> {
  JiraIssueCommentDtoCopyWith<$R, JiraIssueCommentDto, $Out>
  get $asJiraIssueCommentDto => $base.as(
    (v, t, t2) => _JiraIssueCommentDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class JiraIssueCommentDtoCopyWith<
  $R,
  $In extends JiraIssueCommentDto,
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
  JiraIssueCommentDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _JiraIssueCommentDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JiraIssueCommentDto, $Out>
    implements JiraIssueCommentDtoCopyWith<$R, JiraIssueCommentDto, $Out> {
  _JiraIssueCommentDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JiraIssueCommentDto> $mapper =
      JiraIssueCommentDtoMapper.ensureInitialized();
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
  JiraIssueCommentDto $make(CopyWithData data) => JiraIssueCommentDto(
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
  JiraIssueCommentDtoCopyWith<$R2, JiraIssueCommentDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _JiraIssueCommentDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

