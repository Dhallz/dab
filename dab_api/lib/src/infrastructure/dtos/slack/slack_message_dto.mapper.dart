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

  static String _$text(SlackMessageDto v) => v.text;
  static const Field<SlackMessageDto, String> _f$text = Field('text', _$text);
  static String _$user(SlackMessageDto v) => v.user;
  static const Field<SlackMessageDto, String> _f$user = Field('user', _$user);
  static String _$ts(SlackMessageDto v) => v.ts;
  static const Field<SlackMessageDto, String> _f$ts = Field('ts', _$ts);
  static String _$channel(SlackMessageDto v) => v.channel;
  static const Field<SlackMessageDto, String> _f$channel = Field(
    'channel',
    _$channel,
  );

  @override
  final MappableFields<SlackMessageDto> fields = const {
    #text: _f$text,
    #user: _f$user,
    #ts: _f$ts,
    #channel: _f$channel,
  };

  static SlackMessageDto _instantiate(DecodingData data) {
    return SlackMessageDto(
      text: data.dec(_f$text),
      user: data.dec(_f$user),
      ts: data.dec(_f$ts),
      channel: data.dec(_f$channel),
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
  $R call({String? text, String? user, String? ts, String? channel});
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
  $R call({String? text, String? user, String? ts, String? channel}) => $apply(
    FieldCopyWithData({
      if (text != null) #text: text,
      if (user != null) #user: user,
      if (ts != null) #ts: ts,
      if (channel != null) #channel: channel,
    }),
  );
  @override
  SlackMessageDto $make(CopyWithData data) => SlackMessageDto(
    text: data.get(#text, or: $value.text),
    user: data.get(#user, or: $value.user),
    ts: data.get(#ts, or: $value.ts),
    channel: data.get(#channel, or: $value.channel),
  );

  @override
  SlackMessageDtoCopyWith<$R2, SlackMessageDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SlackMessageDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

