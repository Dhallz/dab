// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'linear_issue_dto.dart';

class LinearIssueDtoMapper extends ClassMapperBase<LinearIssueDto> {
  LinearIssueDtoMapper._();

  static LinearIssueDtoMapper? _instance;
  static LinearIssueDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LinearIssueDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LinearIssueDto';

  static String _$identifier(LinearIssueDto v) => v.identifier;
  static const Field<LinearIssueDto, String> _f$identifier = Field(
    'identifier',
    _$identifier,
  );
  static String _$title(LinearIssueDto v) => v.title;
  static const Field<LinearIssueDto, String> _f$title = Field('title', _$title);
  static String _$status(LinearIssueDto v) => v.status;
  static const Field<LinearIssueDto, String> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime _$updatedAt(LinearIssueDto v) => v.updatedAt;
  static const Field<LinearIssueDto, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );

  @override
  final MappableFields<LinearIssueDto> fields = const {
    #identifier: _f$identifier,
    #title: _f$title,
    #status: _f$status,
    #updatedAt: _f$updatedAt,
  };

  static LinearIssueDto _instantiate(DecodingData data) {
    return LinearIssueDto(
      identifier: data.dec(_f$identifier),
      title: data.dec(_f$title),
      status: data.dec(_f$status),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LinearIssueDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LinearIssueDto>(map);
  }

  static LinearIssueDto fromJson(String json) {
    return ensureInitialized().decodeJson<LinearIssueDto>(json);
  }
}

mixin LinearIssueDtoMappable {
  String toJson() {
    return LinearIssueDtoMapper.ensureInitialized().encodeJson<LinearIssueDto>(
      this as LinearIssueDto,
    );
  }

  Map<String, dynamic> toMap() {
    return LinearIssueDtoMapper.ensureInitialized().encodeMap<LinearIssueDto>(
      this as LinearIssueDto,
    );
  }

  LinearIssueDtoCopyWith<LinearIssueDto, LinearIssueDto, LinearIssueDto>
  get copyWith => _LinearIssueDtoCopyWithImpl<LinearIssueDto, LinearIssueDto>(
    this as LinearIssueDto,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return LinearIssueDtoMapper.ensureInitialized().stringifyValue(
      this as LinearIssueDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return LinearIssueDtoMapper.ensureInitialized().equalsValue(
      this as LinearIssueDto,
      other,
    );
  }

  @override
  int get hashCode {
    return LinearIssueDtoMapper.ensureInitialized().hashValue(
      this as LinearIssueDto,
    );
  }
}

extension LinearIssueDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LinearIssueDto, $Out> {
  LinearIssueDtoCopyWith<$R, LinearIssueDto, $Out> get $asLinearIssueDto =>
      $base.as((v, t, t2) => _LinearIssueDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LinearIssueDtoCopyWith<$R, $In extends LinearIssueDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? identifier,
    String? title,
    String? status,
    DateTime? updatedAt,
  });
  LinearIssueDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LinearIssueDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LinearIssueDto, $Out>
    implements LinearIssueDtoCopyWith<$R, LinearIssueDto, $Out> {
  _LinearIssueDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LinearIssueDto> $mapper =
      LinearIssueDtoMapper.ensureInitialized();
  @override
  $R call({
    String? identifier,
    String? title,
    String? status,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (identifier != null) #identifier: identifier,
      if (title != null) #title: title,
      if (status != null) #status: status,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  LinearIssueDto $make(CopyWithData data) => LinearIssueDto(
    identifier: data.get(#identifier, or: $value.identifier),
    title: data.get(#title, or: $value.title),
    status: data.get(#status, or: $value.status),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  LinearIssueDtoCopyWith<$R2, LinearIssueDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LinearIssueDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

