// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'slack_message_dto.dart';

class SlackMessageDtoMapper extends ClassMapperBase<SlackMessageDto> {
  SlackMessageDtoMapper._();

  static SlackMessageDtoMapper? _instance;
  static SlackMessageDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SlackMessageDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SlackMessageDto';

  static String _$channelId(SlackMessageDto v) => v.channelId;
  static const Field<SlackMessageDto, String> _f$channelId = Field(
    'channelId',
    _$channelId,
  );
  static String _$text(SlackMessageDto v) => v.text;
  static const Field<SlackMessageDto, String> _f$text = Field('text', _$text);
  static String _$userId(SlackMessageDto v) => v.userId;
  static const Field<SlackMessageDto, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$ts(SlackMessageDto v) => v.ts;
  static const Field<SlackMessageDto, String> _f$ts = Field('ts', _$ts);
  static DateTime _$createdAt(SlackMessageDto v) => v.createdAt;
  static const Field<SlackMessageDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static String? _$channelLabel(SlackMessageDto v) => v.channelLabel;
  static const Field<SlackMessageDto, String> _f$channelLabel = Field(
    'channelLabel',
    _$channelLabel,
    opt: true,
  );
  static String? _$workspaceId(SlackMessageDto v) => v.workspaceId;
  static const Field<SlackMessageDto, String> _f$workspaceId = Field(
    'workspaceId',
    _$workspaceId,
    opt: true,
  );
  static String? _$threadTs(SlackMessageDto v) => v.threadTs;
  static const Field<SlackMessageDto, String> _f$threadTs = Field(
    'threadTs',
    _$threadTs,
    opt: true,
  );
  static String? _$permalink(SlackMessageDto v) => v.permalink;
  static const Field<SlackMessageDto, String> _f$permalink = Field(
    'permalink',
    _$permalink,
    opt: true,
  );
  static String? _$userDisplayName(SlackMessageDto v) => v.userDisplayName;
  static const Field<SlackMessageDto, String> _f$userDisplayName = Field(
    'userDisplayName',
    _$userDisplayName,
    opt: true,
  );
  static String? _$userUsername(SlackMessageDto v) => v.userUsername;
  static const Field<SlackMessageDto, String> _f$userUsername = Field(
    'userUsername',
    _$userUsername,
    opt: true,
  );
  static String? _$userAvatarUrl(SlackMessageDto v) => v.userAvatarUrl;
  static const Field<SlackMessageDto, String> _f$userAvatarUrl = Field(
    'userAvatarUrl',
    _$userAvatarUrl,
    opt: true,
  );
  static String? _$dabUserId(SlackMessageDto v) => v.dabUserId;
  static const Field<SlackMessageDto, String> _f$dabUserId = Field(
    'dabUserId',
    _$dabUserId,
    opt: true,
  );

  @override
  final MappableFields<SlackMessageDto> fields = const {
    #channelId: _f$channelId,
    #text: _f$text,
    #userId: _f$userId,
    #ts: _f$ts,
    #createdAt: _f$createdAt,
    #channelLabel: _f$channelLabel,
    #workspaceId: _f$workspaceId,
    #threadTs: _f$threadTs,
    #permalink: _f$permalink,
    #userDisplayName: _f$userDisplayName,
    #userUsername: _f$userUsername,
    #userAvatarUrl: _f$userAvatarUrl,
    #dabUserId: _f$dabUserId,
  };

  static SlackMessageDto _instantiate(DecodingData data) {
    return SlackMessageDto(
      channelId: data.dec(_f$channelId),
      text: data.dec(_f$text),
      userId: data.dec(_f$userId),
      ts: data.dec(_f$ts),
      createdAt: data.dec(_f$createdAt),
      channelLabel: data.dec(_f$channelLabel),
      workspaceId: data.dec(_f$workspaceId),
      threadTs: data.dec(_f$threadTs),
      permalink: data.dec(_f$permalink),
      userDisplayName: data.dec(_f$userDisplayName),
      userUsername: data.dec(_f$userUsername),
      userAvatarUrl: data.dec(_f$userAvatarUrl),
      dabUserId: data.dec(_f$dabUserId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SlackMessageDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SlackMessageDto>(map);
  }

  static SlackMessageDto fromJson(String json) {
    return ensureInitialized().decodeJson<SlackMessageDto>(json);
  }
}

mixin SlackMessageDtoMappable {
  String toJson() {
    return SlackMessageDtoMapper.ensureInitialized()
        .encodeJson<SlackMessageDto>(this as SlackMessageDto);
  }

  Map<String, dynamic> toMap() {
    return SlackMessageDtoMapper.ensureInitialized().encodeMap<SlackMessageDto>(
      this as SlackMessageDto,
    );
  }

  SlackMessageDtoCopyWith<SlackMessageDto, SlackMessageDto, SlackMessageDto>
  get copyWith =>
      _SlackMessageDtoCopyWithImpl<SlackMessageDto, SlackMessageDto>(
        this as SlackMessageDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SlackMessageDtoMapper.ensureInitialized().stringifyValue(
      this as SlackMessageDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return SlackMessageDtoMapper.ensureInitialized().equalsValue(
      this as SlackMessageDto,
      other,
    );
  }

  @override
  int get hashCode {
    return SlackMessageDtoMapper.ensureInitialized().hashValue(
      this as SlackMessageDto,
    );
  }
}

extension SlackMessageDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SlackMessageDto, $Out> {
  SlackMessageDtoCopyWith<$R, SlackMessageDto, $Out> get $asSlackMessageDto =>
      $base.as((v, t, t2) => _SlackMessageDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SlackMessageDtoCopyWith<$R, $In extends SlackMessageDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? channelId,
    String? text,
    String? userId,
    String? ts,
    DateTime? createdAt,
    String? channelLabel,
    String? workspaceId,
    String? threadTs,
    String? permalink,
    String? userDisplayName,
    String? userUsername,
    String? userAvatarUrl,
    String? dabUserId,
  });
  SlackMessageDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SlackMessageDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SlackMessageDto, $Out>
    implements SlackMessageDtoCopyWith<$R, SlackMessageDto, $Out> {
  _SlackMessageDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SlackMessageDto> $mapper =
      SlackMessageDtoMapper.ensureInitialized();
  @override
  $R call({
    String? channelId,
    String? text,
    String? userId,
    String? ts,
    DateTime? createdAt,
    Object? channelLabel = $none,
    Object? workspaceId = $none,
    Object? threadTs = $none,
    Object? permalink = $none,
    Object? userDisplayName = $none,
    Object? userUsername = $none,
    Object? userAvatarUrl = $none,
    Object? dabUserId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (channelId != null) #channelId: channelId,
      if (text != null) #text: text,
      if (userId != null) #userId: userId,
      if (ts != null) #ts: ts,
      if (createdAt != null) #createdAt: createdAt,
      if (channelLabel != $none) #channelLabel: channelLabel,
      if (workspaceId != $none) #workspaceId: workspaceId,
      if (threadTs != $none) #threadTs: threadTs,
      if (permalink != $none) #permalink: permalink,
      if (userDisplayName != $none) #userDisplayName: userDisplayName,
      if (userUsername != $none) #userUsername: userUsername,
      if (userAvatarUrl != $none) #userAvatarUrl: userAvatarUrl,
      if (dabUserId != $none) #dabUserId: dabUserId,
    }),
  );
  @override
  SlackMessageDto $make(CopyWithData data) => SlackMessageDto(
    channelId: data.get(#channelId, or: $value.channelId),
    text: data.get(#text, or: $value.text),
    userId: data.get(#userId, or: $value.userId),
    ts: data.get(#ts, or: $value.ts),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    channelLabel: data.get(#channelLabel, or: $value.channelLabel),
    workspaceId: data.get(#workspaceId, or: $value.workspaceId),
    threadTs: data.get(#threadTs, or: $value.threadTs),
    permalink: data.get(#permalink, or: $value.permalink),
    userDisplayName: data.get(#userDisplayName, or: $value.userDisplayName),
    userUsername: data.get(#userUsername, or: $value.userUsername),
    userAvatarUrl: data.get(#userAvatarUrl, or: $value.userAvatarUrl),
    dabUserId: data.get(#dabUserId, or: $value.dabUserId),
  );

  @override
  SlackMessageDtoCopyWith<$R2, SlackMessageDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SlackMessageDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

