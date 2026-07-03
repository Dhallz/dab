// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'discord_message_dto.dart';

class DiscordMessageDtoMapper extends ClassMapperBase<DiscordMessageDto> {
  DiscordMessageDtoMapper._();

  static DiscordMessageDtoMapper? _instance;
  static DiscordMessageDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DiscordMessageDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DiscordMessageDto';

  static String _$messageId(DiscordMessageDto v) => v.messageId;
  static const Field<DiscordMessageDto, String> _f$messageId = Field(
    'messageId',
    _$messageId,
  );
  static String _$channelId(DiscordMessageDto v) => v.channelId;
  static const Field<DiscordMessageDto, String> _f$channelId = Field(
    'channelId',
    _$channelId,
  );
  static String _$content(DiscordMessageDto v) => v.content;
  static const Field<DiscordMessageDto, String> _f$content = Field(
    'content',
    _$content,
  );
  static String _$authorId(DiscordMessageDto v) => v.authorId;
  static const Field<DiscordMessageDto, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static DateTime _$createdAt(DiscordMessageDto v) => v.createdAt;
  static const Field<DiscordMessageDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static String? _$guildId(DiscordMessageDto v) => v.guildId;
  static const Field<DiscordMessageDto, String> _f$guildId = Field(
    'guildId',
    _$guildId,
    opt: true,
  );
  static String? _$channelLabel(DiscordMessageDto v) => v.channelLabel;
  static const Field<DiscordMessageDto, String> _f$channelLabel = Field(
    'channelLabel',
    _$channelLabel,
    opt: true,
  );
  static String? _$authorDisplayName(DiscordMessageDto v) =>
      v.authorDisplayName;
  static const Field<DiscordMessageDto, String> _f$authorDisplayName = Field(
    'authorDisplayName',
    _$authorDisplayName,
    opt: true,
  );
  static String? _$authorAvatarUrl(DiscordMessageDto v) => v.authorAvatarUrl;
  static const Field<DiscordMessageDto, String> _f$authorAvatarUrl = Field(
    'authorAvatarUrl',
    _$authorAvatarUrl,
    opt: true,
  );
  static String? _$replyToId(DiscordMessageDto v) => v.replyToId;
  static const Field<DiscordMessageDto, String> _f$replyToId = Field(
    'replyToId',
    _$replyToId,
    opt: true,
  );
  static String? _$dabUserId(DiscordMessageDto v) => v.dabUserId;
  static const Field<DiscordMessageDto, String> _f$dabUserId = Field(
    'dabUserId',
    _$dabUserId,
    opt: true,
  );

  @override
  final MappableFields<DiscordMessageDto> fields = const {
    #messageId: _f$messageId,
    #channelId: _f$channelId,
    #content: _f$content,
    #authorId: _f$authorId,
    #createdAt: _f$createdAt,
    #guildId: _f$guildId,
    #channelLabel: _f$channelLabel,
    #authorDisplayName: _f$authorDisplayName,
    #authorAvatarUrl: _f$authorAvatarUrl,
    #replyToId: _f$replyToId,
    #dabUserId: _f$dabUserId,
  };

  static DiscordMessageDto _instantiate(DecodingData data) {
    return DiscordMessageDto(
      messageId: data.dec(_f$messageId),
      channelId: data.dec(_f$channelId),
      content: data.dec(_f$content),
      authorId: data.dec(_f$authorId),
      createdAt: data.dec(_f$createdAt),
      guildId: data.dec(_f$guildId),
      channelLabel: data.dec(_f$channelLabel),
      authorDisplayName: data.dec(_f$authorDisplayName),
      authorAvatarUrl: data.dec(_f$authorAvatarUrl),
      replyToId: data.dec(_f$replyToId),
      dabUserId: data.dec(_f$dabUserId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DiscordMessageDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DiscordMessageDto>(map);
  }

  static DiscordMessageDto fromJson(String json) {
    return ensureInitialized().decodeJson<DiscordMessageDto>(json);
  }
}

mixin DiscordMessageDtoMappable {
  String toJson() {
    return DiscordMessageDtoMapper.ensureInitialized()
        .encodeJson<DiscordMessageDto>(this as DiscordMessageDto);
  }

  Map<String, dynamic> toMap() {
    return DiscordMessageDtoMapper.ensureInitialized()
        .encodeMap<DiscordMessageDto>(this as DiscordMessageDto);
  }

  DiscordMessageDtoCopyWith<
    DiscordMessageDto,
    DiscordMessageDto,
    DiscordMessageDto
  >
  get copyWith =>
      _DiscordMessageDtoCopyWithImpl<DiscordMessageDto, DiscordMessageDto>(
        this as DiscordMessageDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DiscordMessageDtoMapper.ensureInitialized().stringifyValue(
      this as DiscordMessageDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return DiscordMessageDtoMapper.ensureInitialized().equalsValue(
      this as DiscordMessageDto,
      other,
    );
  }

  @override
  int get hashCode {
    return DiscordMessageDtoMapper.ensureInitialized().hashValue(
      this as DiscordMessageDto,
    );
  }
}

extension DiscordMessageDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DiscordMessageDto, $Out> {
  DiscordMessageDtoCopyWith<$R, DiscordMessageDto, $Out>
  get $asDiscordMessageDto => $base.as(
    (v, t, t2) => _DiscordMessageDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DiscordMessageDtoCopyWith<
  $R,
  $In extends DiscordMessageDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? messageId,
    String? channelId,
    String? content,
    String? authorId,
    DateTime? createdAt,
    String? guildId,
    String? channelLabel,
    String? authorDisplayName,
    String? authorAvatarUrl,
    String? replyToId,
    String? dabUserId,
  });
  DiscordMessageDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DiscordMessageDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DiscordMessageDto, $Out>
    implements DiscordMessageDtoCopyWith<$R, DiscordMessageDto, $Out> {
  _DiscordMessageDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DiscordMessageDto> $mapper =
      DiscordMessageDtoMapper.ensureInitialized();
  @override
  $R call({
    String? messageId,
    String? channelId,
    String? content,
    String? authorId,
    DateTime? createdAt,
    Object? guildId = $none,
    Object? channelLabel = $none,
    Object? authorDisplayName = $none,
    Object? authorAvatarUrl = $none,
    Object? replyToId = $none,
    Object? dabUserId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (messageId != null) #messageId: messageId,
      if (channelId != null) #channelId: channelId,
      if (content != null) #content: content,
      if (authorId != null) #authorId: authorId,
      if (createdAt != null) #createdAt: createdAt,
      if (guildId != $none) #guildId: guildId,
      if (channelLabel != $none) #channelLabel: channelLabel,
      if (authorDisplayName != $none) #authorDisplayName: authorDisplayName,
      if (authorAvatarUrl != $none) #authorAvatarUrl: authorAvatarUrl,
      if (replyToId != $none) #replyToId: replyToId,
      if (dabUserId != $none) #dabUserId: dabUserId,
    }),
  );
  @override
  DiscordMessageDto $make(CopyWithData data) => DiscordMessageDto(
    messageId: data.get(#messageId, or: $value.messageId),
    channelId: data.get(#channelId, or: $value.channelId),
    content: data.get(#content, or: $value.content),
    authorId: data.get(#authorId, or: $value.authorId),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    guildId: data.get(#guildId, or: $value.guildId),
    channelLabel: data.get(#channelLabel, or: $value.channelLabel),
    authorDisplayName: data.get(
      #authorDisplayName,
      or: $value.authorDisplayName,
    ),
    authorAvatarUrl: data.get(#authorAvatarUrl, or: $value.authorAvatarUrl),
    replyToId: data.get(#replyToId, or: $value.replyToId),
    dabUserId: data.get(#dabUserId, or: $value.dabUserId),
  );

  @override
  DiscordMessageDtoCopyWith<$R2, DiscordMessageDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DiscordMessageDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

