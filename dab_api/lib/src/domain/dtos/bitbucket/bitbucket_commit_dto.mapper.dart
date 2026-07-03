// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'bitbucket_commit_dto.dart';

class BitbucketCommitDtoMapper extends ClassMapperBase<BitbucketCommitDto> {
  BitbucketCommitDtoMapper._();

  static BitbucketCommitDtoMapper? _instance;
  static BitbucketCommitDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BitbucketCommitDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BitbucketCommitDto';

  static String _$repo(BitbucketCommitDto v) => v.repo;
  static const Field<BitbucketCommitDto, String> _f$repo = Field(
    'repo',
    _$repo,
  );
  static String _$sha(BitbucketCommitDto v) => v.sha;
  static const Field<BitbucketCommitDto, String> _f$sha = Field('sha', _$sha);
  static String _$message(BitbucketCommitDto v) => v.message;
  static const Field<BitbucketCommitDto, String> _f$message = Field(
    'message',
    _$message,
  );
  static String _$url(BitbucketCommitDto v) => v.url;
  static const Field<BitbucketCommitDto, String> _f$url = Field('url', _$url);
  static DateTime _$committedAt(BitbucketCommitDto v) => v.committedAt;
  static const Field<BitbucketCommitDto, DateTime> _f$committedAt = Field(
    'committedAt',
    _$committedAt,
  );
  static String? _$branch(BitbucketCommitDto v) => v.branch;
  static const Field<BitbucketCommitDto, String> _f$branch = Field(
    'branch',
    _$branch,
    opt: true,
  );
  static String? _$authorName(BitbucketCommitDto v) => v.authorName;
  static const Field<BitbucketCommitDto, String> _f$authorName = Field(
    'authorName',
    _$authorName,
    opt: true,
  );
  static String? _$authorEmail(BitbucketCommitDto v) => v.authorEmail;
  static const Field<BitbucketCommitDto, String> _f$authorEmail = Field(
    'authorEmail',
    _$authorEmail,
    opt: true,
  );
  static String? _$userId(BitbucketCommitDto v) => v.userId;
  static const Field<BitbucketCommitDto, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );

  @override
  final MappableFields<BitbucketCommitDto> fields = const {
    #repo: _f$repo,
    #sha: _f$sha,
    #message: _f$message,
    #url: _f$url,
    #committedAt: _f$committedAt,
    #branch: _f$branch,
    #authorName: _f$authorName,
    #authorEmail: _f$authorEmail,
    #userId: _f$userId,
  };

  static BitbucketCommitDto _instantiate(DecodingData data) {
    return BitbucketCommitDto(
      repo: data.dec(_f$repo),
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

  static BitbucketCommitDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BitbucketCommitDto>(map);
  }

  static BitbucketCommitDto fromJson(String json) {
    return ensureInitialized().decodeJson<BitbucketCommitDto>(json);
  }
}

mixin BitbucketCommitDtoMappable {
  String toJson() {
    return BitbucketCommitDtoMapper.ensureInitialized()
        .encodeJson<BitbucketCommitDto>(this as BitbucketCommitDto);
  }

  Map<String, dynamic> toMap() {
    return BitbucketCommitDtoMapper.ensureInitialized()
        .encodeMap<BitbucketCommitDto>(this as BitbucketCommitDto);
  }

  BitbucketCommitDtoCopyWith<
    BitbucketCommitDto,
    BitbucketCommitDto,
    BitbucketCommitDto
  >
  get copyWith =>
      _BitbucketCommitDtoCopyWithImpl<BitbucketCommitDto, BitbucketCommitDto>(
        this as BitbucketCommitDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BitbucketCommitDtoMapper.ensureInitialized().stringifyValue(
      this as BitbucketCommitDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return BitbucketCommitDtoMapper.ensureInitialized().equalsValue(
      this as BitbucketCommitDto,
      other,
    );
  }

  @override
  int get hashCode {
    return BitbucketCommitDtoMapper.ensureInitialized().hashValue(
      this as BitbucketCommitDto,
    );
  }
}

extension BitbucketCommitDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BitbucketCommitDto, $Out> {
  BitbucketCommitDtoCopyWith<$R, BitbucketCommitDto, $Out>
  get $asBitbucketCommitDto => $base.as(
    (v, t, t2) => _BitbucketCommitDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class BitbucketCommitDtoCopyWith<
  $R,
  $In extends BitbucketCommitDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? repo,
    String? sha,
    String? message,
    String? url,
    DateTime? committedAt,
    String? branch,
    String? authorName,
    String? authorEmail,
    String? userId,
  });
  BitbucketCommitDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BitbucketCommitDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BitbucketCommitDto, $Out>
    implements BitbucketCommitDtoCopyWith<$R, BitbucketCommitDto, $Out> {
  _BitbucketCommitDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BitbucketCommitDto> $mapper =
      BitbucketCommitDtoMapper.ensureInitialized();
  @override
  $R call({
    String? repo,
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
      if (repo != null) #repo: repo,
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
  BitbucketCommitDto $make(CopyWithData data) => BitbucketCommitDto(
    repo: data.get(#repo, or: $value.repo),
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
  BitbucketCommitDtoCopyWith<$R2, BitbucketCommitDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BitbucketCommitDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

