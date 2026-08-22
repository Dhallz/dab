// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'daily_report_line.dart';

class DailyReportLineMapper extends ClassMapperBase<DailyReportLine> {
  DailyReportLineMapper._();

  static DailyReportLineMapper? _instance;
  static DailyReportLineMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DailyReportLineMapper._());
      DailyReportLineRoleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DailyReportLine';

  static String _$subjectKey(DailyReportLine v) => v.subjectKey;
  static const Field<DailyReportLine, String> _f$subjectKey = Field(
    'subjectKey',
    _$subjectKey,
  );
  static bool _$included(DailyReportLine v) => v.included;
  static const Field<DailyReportLine, bool> _f$included = Field(
    'included',
    _$included,
    opt: true,
    def: true,
  );
  static String? _$note(DailyReportLine v) => v.note;
  static const Field<DailyReportLine, String> _f$note = Field(
    'note',
    _$note,
    opt: true,
  );
  static DailyReportLineRole _$role(DailyReportLine v) => v.role;
  static const Field<DailyReportLine, DailyReportLineRole> _f$role = Field(
    'role',
    _$role,
    opt: true,
    def: DailyReportLineRole.directed,
  );
  static String? _$title(DailyReportLine v) => v.title;
  static const Field<DailyReportLine, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$url(DailyReportLine v) => v.url;
  static const Field<DailyReportLine, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static DateTime? _$occurredAt(DailyReportLine v) => v.occurredAt;
  static const Field<DailyReportLine, DateTime> _f$occurredAt = Field(
    'occurredAt',
    _$occurredAt,
    opt: true,
  );
  static String? _$providerId(DailyReportLine v) => v.providerId;
  static const Field<DailyReportLine, String> _f$providerId = Field(
    'providerId',
    _$providerId,
    opt: true,
  );

  @override
  final MappableFields<DailyReportLine> fields = const {
    #subjectKey: _f$subjectKey,
    #included: _f$included,
    #note: _f$note,
    #role: _f$role,
    #title: _f$title,
    #url: _f$url,
    #occurredAt: _f$occurredAt,
    #providerId: _f$providerId,
  };

  static DailyReportLine _instantiate(DecodingData data) {
    return DailyReportLine(
      subjectKey: data.dec(_f$subjectKey),
      included: data.dec(_f$included),
      note: data.dec(_f$note),
      role: data.dec(_f$role),
      title: data.dec(_f$title),
      url: data.dec(_f$url),
      occurredAt: data.dec(_f$occurredAt),
      providerId: data.dec(_f$providerId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DailyReportLine fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DailyReportLine>(map);
  }

  static DailyReportLine fromJson(String json) {
    return ensureInitialized().decodeJson<DailyReportLine>(json);
  }
}

mixin DailyReportLineMappable {
  String toJson() {
    return DailyReportLineMapper.ensureInitialized()
        .encodeJson<DailyReportLine>(this as DailyReportLine);
  }

  Map<String, dynamic> toMap() {
    return DailyReportLineMapper.ensureInitialized().encodeMap<DailyReportLine>(
      this as DailyReportLine,
    );
  }

  DailyReportLineCopyWith<DailyReportLine, DailyReportLine, DailyReportLine>
  get copyWith =>
      _DailyReportLineCopyWithImpl<DailyReportLine, DailyReportLine>(
        this as DailyReportLine,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DailyReportLineMapper.ensureInitialized().stringifyValue(
      this as DailyReportLine,
    );
  }

  @override
  bool operator ==(Object other) {
    return DailyReportLineMapper.ensureInitialized().equalsValue(
      this as DailyReportLine,
      other,
    );
  }

  @override
  int get hashCode {
    return DailyReportLineMapper.ensureInitialized().hashValue(
      this as DailyReportLine,
    );
  }
}

extension DailyReportLineValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DailyReportLine, $Out> {
  DailyReportLineCopyWith<$R, DailyReportLine, $Out> get $asDailyReportLine =>
      $base.as((v, t, t2) => _DailyReportLineCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DailyReportLineCopyWith<$R, $In extends DailyReportLine, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? subjectKey,
    bool? included,
    String? note,
    DailyReportLineRole? role,
    String? title,
    String? url,
    DateTime? occurredAt,
    String? providerId,
  });
  DailyReportLineCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DailyReportLineCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DailyReportLine, $Out>
    implements DailyReportLineCopyWith<$R, DailyReportLine, $Out> {
  _DailyReportLineCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DailyReportLine> $mapper =
      DailyReportLineMapper.ensureInitialized();
  @override
  $R call({
    String? subjectKey,
    bool? included,
    Object? note = $none,
    DailyReportLineRole? role,
    Object? title = $none,
    Object? url = $none,
    Object? occurredAt = $none,
    Object? providerId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (subjectKey != null) #subjectKey: subjectKey,
      if (included != null) #included: included,
      if (note != $none) #note: note,
      if (role != null) #role: role,
      if (title != $none) #title: title,
      if (url != $none) #url: url,
      if (occurredAt != $none) #occurredAt: occurredAt,
      if (providerId != $none) #providerId: providerId,
    }),
  );
  @override
  DailyReportLine $make(CopyWithData data) => DailyReportLine(
    subjectKey: data.get(#subjectKey, or: $value.subjectKey),
    included: data.get(#included, or: $value.included),
    note: data.get(#note, or: $value.note),
    role: data.get(#role, or: $value.role),
    title: data.get(#title, or: $value.title),
    url: data.get(#url, or: $value.url),
    occurredAt: data.get(#occurredAt, or: $value.occurredAt),
    providerId: data.get(#providerId, or: $value.providerId),
  );

  @override
  DailyReportLineCopyWith<$R2, DailyReportLine, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DailyReportLineCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

