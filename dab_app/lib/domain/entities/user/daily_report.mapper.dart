// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'daily_report.dart';

class DailyReportMapper extends ClassMapperBase<DailyReport> {
  DailyReportMapper._();

  static DailyReportMapper? _instance;
  static DailyReportMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DailyReportMapper._());
      DailyReportLineMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DailyReport';

  static String _$userId(DailyReport v) => v.userId;
  static const Field<DailyReport, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
    def: '',
  );
  static String _$date(DailyReport v) => v.date;
  static const Field<DailyReport, String> _f$date = Field('date', _$date);
  static bool _$includeFollowing(DailyReport v) => v.includeFollowing;
  static const Field<DailyReport, bool> _f$includeFollowing = Field(
    'includeFollowing',
    _$includeFollowing,
    opt: true,
    def: false,
  );
  static List<DailyReportLine> _$lines(DailyReport v) => v.lines;
  static const Field<DailyReport, List<DailyReportLine>> _f$lines = Field(
    'lines',
    _$lines,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<DailyReport> fields = const {
    #userId: _f$userId,
    #date: _f$date,
    #includeFollowing: _f$includeFollowing,
    #lines: _f$lines,
  };

  static DailyReport _instantiate(DecodingData data) {
    return DailyReport(
      userId: data.dec(_f$userId),
      date: data.dec(_f$date),
      includeFollowing: data.dec(_f$includeFollowing),
      lines: data.dec(_f$lines),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DailyReport fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DailyReport>(map);
  }

  static DailyReport fromJson(String json) {
    return ensureInitialized().decodeJson<DailyReport>(json);
  }
}

mixin DailyReportMappable {
  String toJson() {
    return DailyReportMapper.ensureInitialized().encodeJson<DailyReport>(
      this as DailyReport,
    );
  }

  Map<String, dynamic> toMap() {
    return DailyReportMapper.ensureInitialized().encodeMap<DailyReport>(
      this as DailyReport,
    );
  }

  DailyReportCopyWith<DailyReport, DailyReport, DailyReport> get copyWith =>
      _DailyReportCopyWithImpl<DailyReport, DailyReport>(
        this as DailyReport,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DailyReportMapper.ensureInitialized().stringifyValue(
      this as DailyReport,
    );
  }

  @override
  bool operator ==(Object other) {
    return DailyReportMapper.ensureInitialized().equalsValue(
      this as DailyReport,
      other,
    );
  }

  @override
  int get hashCode {
    return DailyReportMapper.ensureInitialized().hashValue(this as DailyReport);
  }
}

extension DailyReportValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DailyReport, $Out> {
  DailyReportCopyWith<$R, DailyReport, $Out> get $asDailyReport =>
      $base.as((v, t, t2) => _DailyReportCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DailyReportCopyWith<$R, $In extends DailyReport, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    DailyReportLine,
    DailyReportLineCopyWith<$R, DailyReportLine, DailyReportLine>
  >
  get lines;
  $R call({
    String? userId,
    String? date,
    bool? includeFollowing,
    List<DailyReportLine>? lines,
  });
  DailyReportCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DailyReportCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DailyReport, $Out>
    implements DailyReportCopyWith<$R, DailyReport, $Out> {
  _DailyReportCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DailyReport> $mapper =
      DailyReportMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    DailyReportLine,
    DailyReportLineCopyWith<$R, DailyReportLine, DailyReportLine>
  >
  get lines => ListCopyWith(
    $value.lines,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(lines: v),
  );
  @override
  $R call({
    String? userId,
    String? date,
    bool? includeFollowing,
    List<DailyReportLine>? lines,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (date != null) #date: date,
      if (includeFollowing != null) #includeFollowing: includeFollowing,
      if (lines != null) #lines: lines,
    }),
  );
  @override
  DailyReport $make(CopyWithData data) => DailyReport(
    userId: data.get(#userId, or: $value.userId),
    date: data.get(#date, or: $value.date),
    includeFollowing: data.get(#includeFollowing, or: $value.includeFollowing),
    lines: data.get(#lines, or: $value.lines),
  );

  @override
  DailyReportCopyWith<$R2, DailyReport, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DailyReportCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

