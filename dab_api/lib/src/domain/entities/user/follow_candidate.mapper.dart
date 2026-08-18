// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'follow_candidate.dart';

class FollowCandidateMapper extends ClassMapperBase<FollowCandidate> {
  FollowCandidateMapper._();

  static FollowCandidateMapper? _instance;
  static FollowCandidateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FollowCandidateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FollowCandidate';

  static String _$providerId(FollowCandidate v) => v.providerId;
  static const Field<FollowCandidate, String> _f$providerId = Field(
    'providerId',
    _$providerId,
  );
  static String _$objectKey(FollowCandidate v) => v.objectKey;
  static const Field<FollowCandidate, String> _f$objectKey = Field(
    'objectKey',
    _$objectKey,
  );
  static String _$title(FollowCandidate v) => v.title;
  static const Field<FollowCandidate, String> _f$title = Field(
    'title',
    _$title,
  );
  static String? _$url(FollowCandidate v) => v.url;
  static const Field<FollowCandidate, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static String _$kind(FollowCandidate v) => v.kind;
  static const Field<FollowCandidate, String> _f$kind = Field(
    'kind',
    _$kind,
    opt: true,
    def: 'issue',
  );

  @override
  final MappableFields<FollowCandidate> fields = const {
    #providerId: _f$providerId,
    #objectKey: _f$objectKey,
    #title: _f$title,
    #url: _f$url,
    #kind: _f$kind,
  };

  static FollowCandidate _instantiate(DecodingData data) {
    return FollowCandidate(
      providerId: data.dec(_f$providerId),
      objectKey: data.dec(_f$objectKey),
      title: data.dec(_f$title),
      url: data.dec(_f$url),
      kind: data.dec(_f$kind),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FollowCandidate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FollowCandidate>(map);
  }

  static FollowCandidate fromJson(String json) {
    return ensureInitialized().decodeJson<FollowCandidate>(json);
  }
}

mixin FollowCandidateMappable {
  String toJson() {
    return FollowCandidateMapper.ensureInitialized()
        .encodeJson<FollowCandidate>(this as FollowCandidate);
  }

  Map<String, dynamic> toMap() {
    return FollowCandidateMapper.ensureInitialized().encodeMap<FollowCandidate>(
      this as FollowCandidate,
    );
  }

  FollowCandidateCopyWith<FollowCandidate, FollowCandidate, FollowCandidate>
  get copyWith =>
      _FollowCandidateCopyWithImpl<FollowCandidate, FollowCandidate>(
        this as FollowCandidate,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FollowCandidateMapper.ensureInitialized().stringifyValue(
      this as FollowCandidate,
    );
  }

  @override
  bool operator ==(Object other) {
    return FollowCandidateMapper.ensureInitialized().equalsValue(
      this as FollowCandidate,
      other,
    );
  }

  @override
  int get hashCode {
    return FollowCandidateMapper.ensureInitialized().hashValue(
      this as FollowCandidate,
    );
  }
}

extension FollowCandidateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FollowCandidate, $Out> {
  FollowCandidateCopyWith<$R, FollowCandidate, $Out> get $asFollowCandidate =>
      $base.as((v, t, t2) => _FollowCandidateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FollowCandidateCopyWith<$R, $In extends FollowCandidate, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? providerId,
    String? objectKey,
    String? title,
    String? url,
    String? kind,
  });
  FollowCandidateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FollowCandidateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FollowCandidate, $Out>
    implements FollowCandidateCopyWith<$R, FollowCandidate, $Out> {
  _FollowCandidateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FollowCandidate> $mapper =
      FollowCandidateMapper.ensureInitialized();
  @override
  $R call({
    String? providerId,
    String? objectKey,
    String? title,
    Object? url = $none,
    String? kind,
  }) => $apply(
    FieldCopyWithData({
      if (providerId != null) #providerId: providerId,
      if (objectKey != null) #objectKey: objectKey,
      if (title != null) #title: title,
      if (url != $none) #url: url,
      if (kind != null) #kind: kind,
    }),
  );
  @override
  FollowCandidate $make(CopyWithData data) => FollowCandidate(
    providerId: data.get(#providerId, or: $value.providerId),
    objectKey: data.get(#objectKey, or: $value.objectKey),
    title: data.get(#title, or: $value.title),
    url: data.get(#url, or: $value.url),
    kind: data.get(#kind, or: $value.kind),
  );

  @override
  FollowCandidateCopyWith<$R2, FollowCandidate, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FollowCandidateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

