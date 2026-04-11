// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'github_commit_dto.dart';

class GitHubCommitDtoMapper extends ClassMapperBase<GitHubCommitDto> {
  GitHubCommitDtoMapper._();

  static GitHubCommitDtoMapper? _instance;
  static GitHubCommitDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GitHubCommitDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'GitHubCommitDto';

  static String _$repo(GitHubCommitDto v) => v.repo;
  static const Field<GitHubCommitDto, String> _f$repo = Field('repo', _$repo);
  static String _$sha(GitHubCommitDto v) => v.sha;
  static const Field<GitHubCommitDto, String> _f$sha = Field('sha', _$sha);
  static String _$message(GitHubCommitDto v) => v.message;
  static const Field<GitHubCommitDto, String> _f$message = Field(
    'message',
    _$message,
  );
  static String _$url(GitHubCommitDto v) => v.url;
  static const Field<GitHubCommitDto, String> _f$url = Field('url', _$url);
  static DateTime _$committedAt(GitHubCommitDto v) => v.committedAt;
  static const Field<GitHubCommitDto, DateTime> _f$committedAt = Field(
    'committedAt',
    _$committedAt,
  );
  static String? _$branch(GitHubCommitDto v) => v.branch;
  static const Field<GitHubCommitDto, String> _f$branch = Field(
    'branch',
    _$branch,
    opt: true,
  );
  static String? _$authorLogin(GitHubCommitDto v) => v.authorLogin;
  static const Field<GitHubCommitDto, String> _f$authorLogin = Field(
    'authorLogin',
    _$authorLogin,
    opt: true,
  );
  static String? _$authorName(GitHubCommitDto v) => v.authorName;
  static const Field<GitHubCommitDto, String> _f$authorName = Field(
    'authorName',
    _$authorName,
    opt: true,
  );
  static String? _$authorEmail(GitHubCommitDto v) => v.authorEmail;
  static const Field<GitHubCommitDto, String> _f$authorEmail = Field(
    'authorEmail',
    _$authorEmail,
    opt: true,
  );
  static String? _$authorAvatarUrl(GitHubCommitDto v) => v.authorAvatarUrl;
  static const Field<GitHubCommitDto, String> _f$authorAvatarUrl = Field(
    'authorAvatarUrl',
    _$authorAvatarUrl,
    opt: true,
  );
  static String? _$userId(GitHubCommitDto v) => v.userId;
  static const Field<GitHubCommitDto, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );

  @override
  final MappableFields<GitHubCommitDto> fields = const {
    #repo: _f$repo,
    #sha: _f$sha,
    #message: _f$message,
    #url: _f$url,
    #committedAt: _f$committedAt,
    #branch: _f$branch,
    #authorLogin: _f$authorLogin,
    #authorName: _f$authorName,
    #authorEmail: _f$authorEmail,
    #authorAvatarUrl: _f$authorAvatarUrl,
    #userId: _f$userId,
  };

  static GitHubCommitDto _instantiate(DecodingData data) {
    return GitHubCommitDto(
      repo: data.dec(_f$repo),
      sha: data.dec(_f$sha),
      message: data.dec(_f$message),
      url: data.dec(_f$url),
      committedAt: data.dec(_f$committedAt),
      branch: data.dec(_f$branch),
      authorLogin: data.dec(_f$authorLogin),
      authorName: data.dec(_f$authorName),
      authorEmail: data.dec(_f$authorEmail),
      authorAvatarUrl: data.dec(_f$authorAvatarUrl),
      userId: data.dec(_f$userId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GitHubCommitDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GitHubCommitDto>(map);
  }

  static GitHubCommitDto fromJson(String json) {
    return ensureInitialized().decodeJson<GitHubCommitDto>(json);
  }
}

mixin GitHubCommitDtoMappable {
  String toJson() {
    return GitHubCommitDtoMapper.ensureInitialized()
        .encodeJson<GitHubCommitDto>(this as GitHubCommitDto);
  }

  Map<String, dynamic> toMap() {
    return GitHubCommitDtoMapper.ensureInitialized().encodeMap<GitHubCommitDto>(
      this as GitHubCommitDto,
    );
  }

  GitHubCommitDtoCopyWith<GitHubCommitDto, GitHubCommitDto, GitHubCommitDto>
  get copyWith =>
      _GitHubCommitDtoCopyWithImpl<GitHubCommitDto, GitHubCommitDto>(
        this as GitHubCommitDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return GitHubCommitDtoMapper.ensureInitialized().stringifyValue(
      this as GitHubCommitDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return GitHubCommitDtoMapper.ensureInitialized().equalsValue(
      this as GitHubCommitDto,
      other,
    );
  }

  @override
  int get hashCode {
    return GitHubCommitDtoMapper.ensureInitialized().hashValue(
      this as GitHubCommitDto,
    );
  }
}

extension GitHubCommitDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GitHubCommitDto, $Out> {
  GitHubCommitDtoCopyWith<$R, GitHubCommitDto, $Out> get $asGitHubCommitDto =>
      $base.as((v, t, t2) => _GitHubCommitDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GitHubCommitDtoCopyWith<$R, $In extends GitHubCommitDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? repo,
    String? sha,
    String? message,
    String? url,
    DateTime? committedAt,
    String? branch,
    String? authorLogin,
    String? authorName,
    String? authorEmail,
    String? authorAvatarUrl,
    String? userId,
  });
  GitHubCommitDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GitHubCommitDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GitHubCommitDto, $Out>
    implements GitHubCommitDtoCopyWith<$R, GitHubCommitDto, $Out> {
  _GitHubCommitDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GitHubCommitDto> $mapper =
      GitHubCommitDtoMapper.ensureInitialized();
  @override
  $R call({
    String? repo,
    String? sha,
    String? message,
    String? url,
    DateTime? committedAt,
    Object? branch = $none,
    Object? authorLogin = $none,
    Object? authorName = $none,
    Object? authorEmail = $none,
    Object? authorAvatarUrl = $none,
    Object? userId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (repo != null) #repo: repo,
      if (sha != null) #sha: sha,
      if (message != null) #message: message,
      if (url != null) #url: url,
      if (committedAt != null) #committedAt: committedAt,
      if (branch != $none) #branch: branch,
      if (authorLogin != $none) #authorLogin: authorLogin,
      if (authorName != $none) #authorName: authorName,
      if (authorEmail != $none) #authorEmail: authorEmail,
      if (authorAvatarUrl != $none) #authorAvatarUrl: authorAvatarUrl,
      if (userId != $none) #userId: userId,
    }),
  );
  @override
  GitHubCommitDto $make(CopyWithData data) => GitHubCommitDto(
    repo: data.get(#repo, or: $value.repo),
    sha: data.get(#sha, or: $value.sha),
    message: data.get(#message, or: $value.message),
    url: data.get(#url, or: $value.url),
    committedAt: data.get(#committedAt, or: $value.committedAt),
    branch: data.get(#branch, or: $value.branch),
    authorLogin: data.get(#authorLogin, or: $value.authorLogin),
    authorName: data.get(#authorName, or: $value.authorName),
    authorEmail: data.get(#authorEmail, or: $value.authorEmail),
    authorAvatarUrl: data.get(#authorAvatarUrl, or: $value.authorAvatarUrl),
    userId: data.get(#userId, or: $value.userId),
  );

  @override
  GitHubCommitDtoCopyWith<$R2, GitHubCommitDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _GitHubCommitDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

