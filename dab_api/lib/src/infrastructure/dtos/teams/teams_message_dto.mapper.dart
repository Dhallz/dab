// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
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
  static DateTime _$createdDateTime(TeamsMessageDto v) => v.createdDateTime;
  static const Field<TeamsMessageDto, DateTime> _f$createdDateTime = Field(
    'createdDateTime',
    _$createdDateTime,
  );
  static String _$channelId(TeamsMessageDto v) => v.channelId;
  static const Field<TeamsMessageDto, String> _f$channelId = Field(
    'channelId',
    _$channelId,
  );

  @override
  final MappableFields<TeamsMessageDto> fields = const {
    #content: _f$content,
    #fromId: _f$fromId,
    #createdDateTime: _f$createdDateTime,
    #channelId: _f$channelId,
  };

  static TeamsMessageDto _instantiate(DecodingData data) {
    return TeamsMessageDto(
      content: data.dec(_f$content),
      fromId: data.dec(_f$fromId),
      createdDateTime: data.dec(_f$createdDateTime),
      channelId: data.dec(_f$channelId),
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
    String? content,
    String? fromId,
    DateTime? createdDateTime,
    String? channelId,
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
    String? content,
    String? fromId,
    DateTime? createdDateTime,
    String? channelId,
  }) => $apply(
    FieldCopyWithData({
      if (content != null) #content: content,
      if (fromId != null) #fromId: fromId,
      if (createdDateTime != null) #createdDateTime: createdDateTime,
      if (channelId != null) #channelId: channelId,
    }),
  );
  @override
  TeamsMessageDto $make(CopyWithData data) => TeamsMessageDto(
    content: data.get(#content, or: $value.content),
    fromId: data.get(#fromId, or: $value.fromId),
    createdDateTime: data.get(#createdDateTime, or: $value.createdDateTime),
    channelId: data.get(#channelId, or: $value.channelId),
  );

  @override
  TeamsMessageDtoCopyWith<$R2, TeamsMessageDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TeamsMessageDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

