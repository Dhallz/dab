// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'activity_follow.dart';

class ActivityFollowMapper extends ClassMapperBase<ActivityFollow> {
  ActivityFollowMapper._();

  static ActivityFollowMapper? _instance;
  static ActivityFollowMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ActivityFollowMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ActivityFollow';

  static String _$id(ActivityFollow v) => v.id;
  static const Field<ActivityFollow, String> _f$id = Field('id', _$id);
  static String _$userId(ActivityFollow v) => v.userId;
  static const Field<ActivityFollow, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$providerId(ActivityFollow v) => v.providerId;
  static const Field<ActivityFollow, String> _f$providerId = Field(
    'providerId',
    _$providerId,
  );
  static String _$objectKey(ActivityFollow v) => v.objectKey;
  static const Field<ActivityFollow, String> _f$objectKey = Field(
    'objectKey',
    _$objectKey,
  );
  static String? _$title(ActivityFollow v) => v.title;
  static const Field<ActivityFollow, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$url(ActivityFollow v) => v.url;
  static const Field<ActivityFollow, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static DateTime _$createdAt(ActivityFollow v) => v.createdAt;
  static const Field<ActivityFollow, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime? _$updatedAt(ActivityFollow v) => v.updatedAt;
  static const Field<ActivityFollow, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
  );

  @override
  final MappableFields<ActivityFollow> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #providerId: _f$providerId,
    #objectKey: _f$objectKey,
    #title: _f$title,
    #url: _f$url,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static ActivityFollow _instantiate(DecodingData data) {
    return ActivityFollow(
      id: data.dec(_f$id),
      userId: data.dec(_f$userId),
      providerId: data.dec(_f$providerId),
      objectKey: data.dec(_f$objectKey),
      title: data.dec(_f$title),
      url: data.dec(_f$url),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ActivityFollow fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ActivityFollow>(map);
  }

  static ActivityFollow fromJson(String json) {
    return ensureInitialized().decodeJson<ActivityFollow>(json);
  }
}

mixin ActivityFollowMappable {
  String toJson() {
    return ActivityFollowMapper.ensureInitialized().encodeJson<ActivityFollow>(
      this as ActivityFollow,
    );
  }

  Map<String, dynamic> toMap() {
    return ActivityFollowMapper.ensureInitialized().encodeMap<ActivityFollow>(
      this as ActivityFollow,
    );
  }

  ActivityFollowCopyWith<ActivityFollow, ActivityFollow, ActivityFollow>
  get copyWith => _ActivityFollowCopyWithImpl<ActivityFollow, ActivityFollow>(
    this as ActivityFollow,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ActivityFollowMapper.ensureInitialized().stringifyValue(
      this as ActivityFollow,
    );
  }

  @override
  bool operator ==(Object other) {
    return ActivityFollowMapper.ensureInitialized().equalsValue(
      this as ActivityFollow,
      other,
    );
  }

  @override
  int get hashCode {
    return ActivityFollowMapper.ensureInitialized().hashValue(
      this as ActivityFollow,
    );
  }
}

extension ActivityFollowValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ActivityFollow, $Out> {
  ActivityFollowCopyWith<$R, ActivityFollow, $Out> get $asActivityFollow =>
      $base.as((v, t, t2) => _ActivityFollowCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ActivityFollowCopyWith<$R, $In extends ActivityFollow, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? userId,
    String? providerId,
    String? objectKey,
    String? title,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  ActivityFollowCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ActivityFollowCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ActivityFollow, $Out>
    implements ActivityFollowCopyWith<$R, ActivityFollow, $Out> {
  _ActivityFollowCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ActivityFollow> $mapper =
      ActivityFollowMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? userId,
    String? providerId,
    String? objectKey,
    Object? title = $none,
    Object? url = $none,
    DateTime? createdAt,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (userId != null) #userId: userId,
      if (providerId != null) #providerId: providerId,
      if (objectKey != null) #objectKey: objectKey,
      if (title != $none) #title: title,
      if (url != $none) #url: url,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  ActivityFollow $make(CopyWithData data) => ActivityFollow(
    id: data.get(#id, or: $value.id),
    userId: data.get(#userId, or: $value.userId),
    providerId: data.get(#providerId, or: $value.providerId),
    objectKey: data.get(#objectKey, or: $value.objectKey),
    title: data.get(#title, or: $value.title),
    url: data.get(#url, or: $value.url),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  ActivityFollowCopyWith<$R2, ActivityFollow, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ActivityFollowCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

