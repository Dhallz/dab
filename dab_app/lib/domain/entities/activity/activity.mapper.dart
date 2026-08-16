// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'activity.dart';

class ActivityMapper extends ClassMapperBase<Activity> {
  ActivityMapper._();

  static ActivityMapper? _instance;
  static ActivityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ActivityMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Activity';

  static String _$id(Activity v) => v.id;
  static const Field<Activity, String> _f$id = Field('id', _$id);
  static String _$userId(Activity v) => v.userId;
  static const Field<Activity, String> _f$userId = Field('userId', _$userId);
  static String? _$senderUserId(Activity v) => v.senderUserId;
  static const Field<Activity, String> _f$senderUserId = Field(
    'senderUserId',
    _$senderUserId,
    opt: true,
  );
  static ActivityProvider _$provider(Activity v) => v.provider;
  static const Field<Activity, ActivityProvider> _f$provider = Field(
    'provider',
    _$provider,
  );
  static String _$title(Activity v) => v.title;
  static const Field<Activity, String> _f$title = Field('title', _$title);
  static String _$content(Activity v) => v.content;
  static const Field<Activity, String> _f$content = Field('content', _$content);
  static String _$authorName(Activity v) => v.authorName;
  static const Field<Activity, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$authorAvatarUrl(Activity v) => v.authorAvatarUrl;
  static const Field<Activity, String> _f$authorAvatarUrl = Field(
    'authorAvatarUrl',
    _$authorAvatarUrl,
    opt: true,
  );
  static int _$commentCount(Activity v) => v.commentCount;
  static const Field<Activity, int> _f$commentCount = Field(
    'commentCount',
    _$commentCount,
  );
  static String? _$url(Activity v) => v.url;
  static const Field<Activity, String> _f$url = Field('url', _$url, opt: true);
  static DateTime _$createdAt(Activity v) => v.createdAt;
  static const Field<Activity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static bool _$archived(Activity v) => v.archived;
  static const Field<Activity, bool> _f$archived = Field(
    'archived',
    _$archived,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<Activity> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #senderUserId: _f$senderUserId,
    #provider: _f$provider,
    #title: _f$title,
    #content: _f$content,
    #authorName: _f$authorName,
    #authorAvatarUrl: _f$authorAvatarUrl,
    #commentCount: _f$commentCount,
    #url: _f$url,
    #createdAt: _f$createdAt,
    #archived: _f$archived,
  };

  static Activity _instantiate(DecodingData data) {
    return Activity(
      id: data.dec(_f$id),
      userId: data.dec(_f$userId),
      senderUserId: data.dec(_f$senderUserId),
      provider: data.dec(_f$provider),
      title: data.dec(_f$title),
      content: data.dec(_f$content),
      authorName: data.dec(_f$authorName),
      authorAvatarUrl: data.dec(_f$authorAvatarUrl),
      commentCount: data.dec(_f$commentCount),
      url: data.dec(_f$url),
      createdAt: data.dec(_f$createdAt),
      archived: data.dec(_f$archived),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Activity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Activity>(map);
  }

  static Activity fromJson(String json) {
    return ensureInitialized().decodeJson<Activity>(json);
  }
}

mixin ActivityMappable {
  String toJson() {
    return ActivityMapper.ensureInitialized().encodeJson<Activity>(
      this as Activity,
    );
  }

  Map<String, dynamic> toMap() {
    return ActivityMapper.ensureInitialized().encodeMap<Activity>(
      this as Activity,
    );
  }

  ActivityCopyWith<Activity, Activity, Activity> get copyWith =>
      _ActivityCopyWithImpl<Activity, Activity>(
        this as Activity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ActivityMapper.ensureInitialized().stringifyValue(this as Activity);
  }

  @override
  bool operator ==(Object other) {
    return ActivityMapper.ensureInitialized().equalsValue(
      this as Activity,
      other,
    );
  }

  @override
  int get hashCode {
    return ActivityMapper.ensureInitialized().hashValue(this as Activity);
  }
}

extension ActivityValueCopy<$R, $Out> on ObjectCopyWith<$R, Activity, $Out> {
  ActivityCopyWith<$R, Activity, $Out> get $asActivity =>
      $base.as((v, t, t2) => _ActivityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ActivityCopyWith<$R, $In extends Activity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? userId,
    String? senderUserId,
    ActivityProvider? provider,
    String? title,
    String? content,
    String? authorName,
    String? authorAvatarUrl,
    int? commentCount,
    String? url,
    DateTime? createdAt,
    bool? archived,
  });
  ActivityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ActivityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Activity, $Out>
    implements ActivityCopyWith<$R, Activity, $Out> {
  _ActivityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Activity> $mapper =
      ActivityMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? userId,
    Object? senderUserId = $none,
    ActivityProvider? provider,
    String? title,
    String? content,
    String? authorName,
    Object? authorAvatarUrl = $none,
    int? commentCount,
    Object? url = $none,
    DateTime? createdAt,
    bool? archived,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (userId != null) #userId: userId,
      if (senderUserId != $none) #senderUserId: senderUserId,
      if (provider != null) #provider: provider,
      if (title != null) #title: title,
      if (content != null) #content: content,
      if (authorName != null) #authorName: authorName,
      if (authorAvatarUrl != $none) #authorAvatarUrl: authorAvatarUrl,
      if (commentCount != null) #commentCount: commentCount,
      if (url != $none) #url: url,
      if (createdAt != null) #createdAt: createdAt,
      if (archived != null) #archived: archived,
    }),
  );
  @override
  Activity $make(CopyWithData data) => Activity(
    id: data.get(#id, or: $value.id),
    userId: data.get(#userId, or: $value.userId),
    senderUserId: data.get(#senderUserId, or: $value.senderUserId),
    provider: data.get(#provider, or: $value.provider),
    title: data.get(#title, or: $value.title),
    content: data.get(#content, or: $value.content),
    authorName: data.get(#authorName, or: $value.authorName),
    authorAvatarUrl: data.get(#authorAvatarUrl, or: $value.authorAvatarUrl),
    commentCount: data.get(#commentCount, or: $value.commentCount),
    url: data.get(#url, or: $value.url),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    archived: data.get(#archived, or: $value.archived),
  );

  @override
  ActivityCopyWith<$R2, Activity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ActivityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

