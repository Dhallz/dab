// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'jira_issue_dto.dart';

class JiraIssueDtoMapper extends ClassMapperBase<JiraIssueDto> {
  JiraIssueDtoMapper._();

  static JiraIssueDtoMapper? _instance;
  static JiraIssueDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JiraIssueDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'JiraIssueDto';

  static String _$key(JiraIssueDto v) => v.key;
  static const Field<JiraIssueDto, String> _f$key = Field('key', _$key);
  static String _$summary(JiraIssueDto v) => v.summary;
  static const Field<JiraIssueDto, String> _f$summary = Field(
    'summary',
    _$summary,
  );
  static String _$status(JiraIssueDto v) => v.status;
  static const Field<JiraIssueDto, String> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime _$updated(JiraIssueDto v) => v.updated;
  static const Field<JiraIssueDto, DateTime> _f$updated = Field(
    'updated',
    _$updated,
  );

  @override
  final MappableFields<JiraIssueDto> fields = const {
    #key: _f$key,
    #summary: _f$summary,
    #status: _f$status,
    #updated: _f$updated,
  };

  static JiraIssueDto _instantiate(DecodingData data) {
    return JiraIssueDto(
      key: data.dec(_f$key),
      summary: data.dec(_f$summary),
      status: data.dec(_f$status),
      updated: data.dec(_f$updated),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JiraIssueDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JiraIssueDto>(map);
  }

  static JiraIssueDto fromJson(String json) {
    return ensureInitialized().decodeJson<JiraIssueDto>(json);
  }
}

mixin JiraIssueDtoMappable {
  String toJson() {
    return JiraIssueDtoMapper.ensureInitialized().encodeJson<JiraIssueDto>(
      this as JiraIssueDto,
    );
  }

  Map<String, dynamic> toMap() {
    return JiraIssueDtoMapper.ensureInitialized().encodeMap<JiraIssueDto>(
      this as JiraIssueDto,
    );
  }

  JiraIssueDtoCopyWith<JiraIssueDto, JiraIssueDto, JiraIssueDto> get copyWith =>
      _JiraIssueDtoCopyWithImpl<JiraIssueDto, JiraIssueDto>(
        this as JiraIssueDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return JiraIssueDtoMapper.ensureInitialized().stringifyValue(
      this as JiraIssueDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return JiraIssueDtoMapper.ensureInitialized().equalsValue(
      this as JiraIssueDto,
      other,
    );
  }

  @override
  int get hashCode {
    return JiraIssueDtoMapper.ensureInitialized().hashValue(
      this as JiraIssueDto,
    );
  }
}

extension JiraIssueDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JiraIssueDto, $Out> {
  JiraIssueDtoCopyWith<$R, JiraIssueDto, $Out> get $asJiraIssueDto =>
      $base.as((v, t, t2) => _JiraIssueDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class JiraIssueDtoCopyWith<$R, $In extends JiraIssueDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? key, String? summary, String? status, DateTime? updated});
  JiraIssueDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _JiraIssueDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JiraIssueDto, $Out>
    implements JiraIssueDtoCopyWith<$R, JiraIssueDto, $Out> {
  _JiraIssueDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JiraIssueDto> $mapper =
      JiraIssueDtoMapper.ensureInitialized();
  @override
  $R call({String? key, String? summary, String? status, DateTime? updated}) =>
      $apply(
        FieldCopyWithData({
          if (key != null) #key: key,
          if (summary != null) #summary: summary,
          if (status != null) #status: status,
          if (updated != null) #updated: updated,
        }),
      );
  @override
  JiraIssueDto $make(CopyWithData data) => JiraIssueDto(
    key: data.get(#key, or: $value.key),
    summary: data.get(#summary, or: $value.summary),
    status: data.get(#status, or: $value.status),
    updated: data.get(#updated, or: $value.updated),
  );

  @override
  JiraIssueDtoCopyWith<$R2, JiraIssueDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _JiraIssueDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

