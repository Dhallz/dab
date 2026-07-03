// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'gitlab_commit_dto.dart';

class GitLabCommitDtoMapper extends ClassMapperBase<GitLabCommitDto> {
  GitLabCommitDtoMapper._();

  static GitLabCommitDtoMapper? _instance;
  static GitLabCommitDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GitLabCommitDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'GitLabCommitDto';

  static String _$project(GitLabCommitDto v) => v.project;
  static const Field<GitLabCommitDto, String> _f$project = Field(
    'project',
    _$project,
  );
  static String _$sha(GitLabCommitDto v) => v.sha;
  static const Field<GitLabCommitDto, String> _f$sha = Field('sha', _$sha);
  static String _$message(GitLabCommitDto v) => v.message;
  static const Field<GitLabCommitDto, String> _f$message = Field(
    'message',
    _$message,
  );
  static String _$url(GitLabCommitDto v) => v.url;
  static const Field<GitLabCommitDto, String> _f$url = Field('url', _$url);
  static DateTime _$committedAt(GitLabCommitDto v) => v.committedAt;
  static const Field<GitLabCommitDto, DateTime> _f$committedAt = Field(
    'committedAt',
    _$committedAt,
  );
  static String? _$branch(GitLabCommitDto v) => v.branch;
  static const Field<GitLabCommitDto, String> _f$branch = Field(
    'branch',
    _$branch,
    opt: true,
  );
  static String? _$authorName(GitLabCommitDto v) => v.authorName;
  static const Field<GitLabCommitDto, String> _f$authorName = Field(
    'authorName',
    _$authorName,
    opt: true,
  );
  static String? _$authorEmail(GitLabCommitDto v) => v.authorEmail;
  static const Field<GitLabCommitDto, String> _f$authorEmail = Field(
    'authorEmail',
    _$authorEmail,
    opt: true,
  );
  static String? _$userId(GitLabCommitDto v) => v.userId;
  static const Field<GitLabCommitDto, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );

  @override
  final MappableFields<GitLabCommitDto> fields = const {
    #project: _f$project,
    #sha: _f$sha,
    #message: _f$message,
    #url: _f$url,
    #committedAt: _f$committedAt,
    #branch: _f$branch,
    #authorName: _f$authorName,
    #authorEmail: _f$authorEmail,
    #userId: _f$userId,
  };

  static GitLabCommitDto _instantiate(DecodingData data) {
    return GitLabCommitDto(
      project: data.dec(_f$project),
      sha: data.dec(_f$sha),
      message: data.dec(_f$message),
      url: data.dec(_f$url),
      committedAt: data.dec(_f$committedAt),
      branch: data.dec(_f$branch),
      authorName: data.dec(_f$authorName),
      authorEmail: data.dec(_f$authorEmail),
      userId: data.dec(_f$userId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GitLabCommitDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GitLabCommitDto>(map);
  }

  static GitLabCommitDto fromJson(String json) {
    return ensureInitialized().decodeJson<GitLabCommitDto>(json);
  }
}

mixin GitLabCommitDtoMappable {
  String toJson() {
    return GitLabCommitDtoMapper.ensureInitialized()
        .encodeJson<GitLabCommitDto>(this as GitLabCommitDto);
  }

  Map<String, dynamic> toMap() {
    return GitLabCommitDtoMapper.ensureInitialized().encodeMap<GitLabCommitDto>(
      this as GitLabCommitDto,
    );
  }

  GitLabCommitDtoCopyWith<GitLabCommitDto, GitLabCommitDto, GitLabCommitDto>
  get copyWith =>
      _GitLabCommitDtoCopyWithImpl<GitLabCommitDto, GitLabCommitDto>(
        this as GitLabCommitDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return GitLabCommitDtoMapper.ensureInitialized().stringifyValue(
      this as GitLabCommitDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return GitLabCommitDtoMapper.ensureInitialized().equalsValue(
      this as GitLabCommitDto,
      other,
    );
  }

  @override
  int get hashCode {
    return GitLabCommitDtoMapper.ensureInitialized().hashValue(
      this as GitLabCommitDto,
    );
  }
}

extension GitLabCommitDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GitLabCommitDto, $Out> {
  GitLabCommitDtoCopyWith<$R, GitLabCommitDto, $Out> get $asGitLabCommitDto =>
      $base.as((v, t, t2) => _GitLabCommitDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GitLabCommitDtoCopyWith<$R, $In extends GitLabCommitDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? project,
    String? sha,
    String? message,
    String? url,
    DateTime? committedAt,
    String? branch,
    String? authorName,
    String? authorEmail,
    String? userId,
  });
  GitLabCommitDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GitLabCommitDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GitLabCommitDto, $Out>
    implements GitLabCommitDtoCopyWith<$R, GitLabCommitDto, $Out> {
  _GitLabCommitDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GitLabCommitDto> $mapper =
      GitLabCommitDtoMapper.ensureInitialized();
  @override
  $R call({
    String? project,
    String? sha,
    String? message,
    String? url,
    DateTime? committedAt,
    Object? branch = $none,
    Object? authorName = $none,
    Object? authorEmail = $none,
    Object? userId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (project != null) #project: project,
      if (sha != null) #sha: sha,
      if (message != null) #message: message,
      if (url != null) #url: url,
      if (committedAt != null) #committedAt: committedAt,
      if (branch != $none) #branch: branch,
      if (authorName != $none) #authorName: authorName,
      if (authorEmail != $none) #authorEmail: authorEmail,
      if (userId != $none) #userId: userId,
    }),
  );
  @override
  GitLabCommitDto $make(CopyWithData data) => GitLabCommitDto(
    project: data.get(#project, or: $value.project),
    sha: data.get(#sha, or: $value.sha),
    message: data.get(#message, or: $value.message),
    url: data.get(#url, or: $value.url),
    committedAt: data.get(#committedAt, or: $value.committedAt),
    branch: data.get(#branch, or: $value.branch),
    authorName: data.get(#authorName, or: $value.authorName),
    authorEmail: data.get(#authorEmail, or: $value.authorEmail),
    userId: data.get(#userId, or: $value.userId),
  );

  @override
  GitLabCommitDtoCopyWith<$R2, GitLabCommitDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _GitLabCommitDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

