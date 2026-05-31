// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'teams_message_dto.dart';

class TeamsMessageDtoMapper extends ClassMapperBase<TeamsMessageDto> {
  TeamsMessageDtoMapper._();

  static TeamsMessageDtoMapper? _instance;
  static TeamsMessageDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TeamsMessageDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TeamsMessageDto';

  static String _$teamId(TeamsMessageDto v) => v.teamId;
  static const Field<TeamsMessageDto, String> _f$teamId = Field(
    'teamId',
    _$teamId,
  );
  static String _$channelId(TeamsMessageDto v) => v.channelId;
  static const Field<TeamsMessageDto, String> _f$channelId = Field(
    'channelId',
    _$channelId,
  );
  static String _$messageId(TeamsMessageDto v) => v.messageId;
  static const Field<TeamsMessageDto, String> _f$messageId = Field(
    'messageId',
    _$messageId,
  );
  static String _$content(TeamsMessageDto v) => v.content;
  static const Field<TeamsMessageDto, String> _f$content = Field(
    'content',
    _$content,
  );
  static String _$fromId(TeamsMessageDto v) => v.fromId;
  static const Field<TeamsMessageDto, String> _f$fromId = Field(
    'fromId',
    _$fromId,
  );
  static DateTime _$createdAt(TeamsMessageDto v) => v.createdAt;
  static const Field<TeamsMessageDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static String? _$channelLabel(TeamsMessageDto v) => v.channelLabel;
  static const Field<TeamsMessageDto, String> _f$channelLabel = Field(
    'channelLabel',
    _$channelLabel,
    opt: true,
  );
  static String? _$tenantId(TeamsMessageDto v) => v.tenantId;
  static const Field<TeamsMessageDto, String> _f$tenantId = Field(
    'tenantId',
    _$tenantId,
    opt: true,
  );
  static String? _$replyToId(TeamsMessageDto v) => v.replyToId;
  static const Field<TeamsMessageDto, String> _f$replyToId = Field(
    'replyToId',
    _$replyToId,
    opt: true,
  );
  static String? _$permalink(TeamsMessageDto v) => v.permalink;
  static const Field<TeamsMessageDto, String> _f$permalink = Field(
    'permalink',
    _$permalink,
    opt: true,
  );
  static String? _$userDisplayName(TeamsMessageDto v) => v.userDisplayName;
  static const Field<TeamsMessageDto, String> _f$userDisplayName = Field(
    'userDisplayName',
    _$userDisplayName,
    opt: true,
  );
  static String? _$userUsername(TeamsMessageDto v) => v.userUsername;
  static const Field<TeamsMessageDto, String> _f$userUsername = Field(
    'userUsername',
    _$userUsername,
    opt: true,
  );
  static String? _$userAvatarUrl(TeamsMessageDto v) => v.userAvatarUrl;
  static const Field<TeamsMessageDto, String> _f$userAvatarUrl = Field(
    'userAvatarUrl',
    _$userAvatarUrl,
    opt: true,
  );
  static String? _$dabUserId(TeamsMessageDto v) => v.dabUserId;
  static const Field<TeamsMessageDto, String> _f$dabUserId = Field(
    'dabUserId',
    _$dabUserId,
    opt: true,
  );

  @override
  final MappableFields<TeamsMessageDto> fields = const {
    #teamId: _f$teamId,
    #channelId: _f$channelId,
    #messageId: _f$messageId,
    #content: _f$content,
    #fromId: _f$fromId,
    #createdAt: _f$createdAt,
    #channelLabel: _f$channelLabel,
    #tenantId: _f$tenantId,
    #replyToId: _f$replyToId,
    #permalink: _f$permalink,
    #userDisplayName: _f$userDisplayName,
    #userUsername: _f$userUsername,
    #userAvatarUrl: _f$userAvatarUrl,
    #dabUserId: _f$dabUserId,
  };

  static TeamsMessageDto _instantiate(DecodingData data) {
    return TeamsMessageDto(
      teamId: data.dec(_f$teamId),
      channelId: data.dec(_f$channelId),
      messageId: data.dec(_f$messageId),
      content: data.dec(_f$content),
      fromId: data.dec(_f$fromId),
      createdAt: data.dec(_f$createdAt),
      channelLabel: data.dec(_f$channelLabel),
      tenantId: data.dec(_f$tenantId),
      replyToId: data.dec(_f$replyToId),
      permalink: data.dec(_f$permalink),
      userDisplayName: data.dec(_f$userDisplayName),
      userUsername: data.dec(_f$userUsername),
      userAvatarUrl: data.dec(_f$userAvatarUrl),
      dabUserId: data.dec(_f$dabUserId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TeamsMessageDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TeamsMessageDto>(map);
  }

  static TeamsMessageDto fromJson(String json) {
    return ensureInitialized().decodeJson<TeamsMessageDto>(json);
  }
}

mixin TeamsMessageDtoMappable {
  String toJson() {
    return TeamsMessageDtoMapper.ensureInitialized()
        .encodeJson<TeamsMessageDto>(this as TeamsMessageDto);
  }

  Map<String, dynamic> toMap() {
    return TeamsMessageDtoMapper.ensureInitialized().encodeMap<TeamsMessageDto>(
      this as TeamsMessageDto,
    );
  }

  TeamsMessageDtoCopyWith<TeamsMessageDto, TeamsMessageDto, TeamsMessageDto>
  get copyWith =>
      _TeamsMessageDtoCopyWithImpl<TeamsMessageDto, TeamsMessageDto>(
        this as TeamsMessageDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TeamsMessageDtoMapper.ensureInitialized().stringifyValue(
      this as TeamsMessageDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return TeamsMessageDtoMapper.ensureInitialized().equalsValue(
      this as TeamsMessageDto,
      other,
    );
  }

  @override
  int get hashCode {
    return TeamsMessageDtoMapper.ensureInitialized().hashValue(
      this as TeamsMessageDto,
    );
  }
}

extension TeamsMessageDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TeamsMessageDto, $Out> {
  TeamsMessageDtoCopyWith<$R, TeamsMessageDto, $Out> get $asTeamsMessageDto =>
      $base.as((v, t, t2) => _TeamsMessageDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TeamsMessageDtoCopyWith<$R, $In extends TeamsMessageDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? teamId,
    String? channelId,
    String? messageId,
    String? content,
    String? fromId,
    DateTime? createdAt,
    String? channelLabel,
    String? tenantId,
    String? replyToId,
    String? permalink,
    String? userDisplayName,
    String? userUsername,
    String? userAvatarUrl,
    String? dabUserId,
  });
  TeamsMessageDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TeamsMessageDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TeamsMessageDto, $Out>
    implements TeamsMessageDtoCopyWith<$R, TeamsMessageDto, $Out> {
  _TeamsMessageDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TeamsMessageDto> $mapper =
      TeamsMessageDtoMapper.ensureInitialized();
  @override
  $R call({
    String? teamId,
    String? channelId,
    String? messageId,
    String? content,
    String? fromId,
    DateTime? createdAt,
    Object? channelLabel = $none,
    Object? tenantId = $none,
    Object? replyToId = $none,
    Object? permalink = $none,
    Object? userDisplayName = $none,
    Object? userUsername = $none,
    Object? userAvatarUrl = $none,
    Object? dabUserId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (teamId != null) #teamId: teamId,
      if (channelId != null) #channelId: channelId,
      if (messageId != null) #messageId: messageId,
      if (content != null) #content: content,
      if (fromId != null) #fromId: fromId,
      if (createdAt != null) #createdAt: createdAt,
      if (channelLabel != $none) #channelLabel: channelLabel,
      if (tenantId != $none) #tenantId: tenantId,
      if (replyToId != $none) #replyToId: replyToId,
      if (permalink != $none) #permalink: permalink,
      if (userDisplayName != $none) #userDisplayName: userDisplayName,
      if (userUsername != $none) #userUsername: userUsername,
      if (userAvatarUrl != $none) #userAvatarUrl: userAvatarUrl,
      if (dabUserId != $none) #dabUserId: dabUserId,
    }),
  );
  @override
  TeamsMessageDto $make(CopyWithData data) => TeamsMessageDto(
    teamId: data.get(#teamId, or: $value.teamId),
    channelId: data.get(#channelId, or: $value.channelId),
    messageId: data.get(#messageId, or: $value.messageId),
    content: data.get(#content, or: $value.content),
    fromId: data.get(#fromId, or: $value.fromId),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    channelLabel: data.get(#channelLabel, or: $value.channelLabel),
    tenantId: data.get(#tenantId, or: $value.tenantId),
    replyToId: data.get(#replyToId, or: $value.replyToId),
    permalink: data.get(#permalink, or: $value.permalink),
    userDisplayName: data.get(#userDisplayName, or: $value.userDisplayName),
    userUsername: data.get(#userUsername, or: $value.userUsername),
    userAvatarUrl: data.get(#userAvatarUrl, or: $value.userAvatarUrl),
    dabUserId: data.get(#dabUserId, or: $value.dabUserId),
  );

  @override
  TeamsMessageDtoCopyWith<$R2, TeamsMessageDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TeamsMessageDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

