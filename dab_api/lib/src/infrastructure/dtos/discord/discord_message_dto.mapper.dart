// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
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
  static String _$timestamp(DiscordMessageDto v) => v.timestamp;
  static const Field<DiscordMessageDto, String> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static String _$channelId(DiscordMessageDto v) => v.channelId;
  static const Field<DiscordMessageDto, String> _f$channelId = Field(
    'channelId',
    _$channelId,
  );

  @override
  final MappableFields<DiscordMessageDto> fields = const {
    #content: _f$content,
    #authorId: _f$authorId,
    #timestamp: _f$timestamp,
    #channelId: _f$channelId,
  };

  static DiscordMessageDto _instantiate(DecodingData data) {
    return DiscordMessageDto(
      content: data.dec(_f$content),
      authorId: data.dec(_f$authorId),
      timestamp: data.dec(_f$timestamp),
      channelId: data.dec(_f$channelId),
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
    String? content,
    String? authorId,
    String? timestamp,
    String? channelId,
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
    String? content,
    String? authorId,
    String? timestamp,
    String? channelId,
  }) => $apply(
    FieldCopyWithData({
      if (content != null) #content: content,
      if (authorId != null) #authorId: authorId,
      if (timestamp != null) #timestamp: timestamp,
      if (channelId != null) #channelId: channelId,
    }),
  );
  @override
  DiscordMessageDto $make(CopyWithData data) => DiscordMessageDto(
    content: data.get(#content, or: $value.content),
    authorId: data.get(#authorId, or: $value.authorId),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    channelId: data.get(#channelId, or: $value.channelId),
  );

  @override
  DiscordMessageDtoCopyWith<$R2, DiscordMessageDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DiscordMessageDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

