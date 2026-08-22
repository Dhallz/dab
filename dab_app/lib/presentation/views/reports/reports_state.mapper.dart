// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'reports_state.dart';

class ReportsStateMapper extends ClassMapperBase<ReportsState> {
  ReportsStateMapper._();

  static ReportsStateMapper? _instance;
  static ReportsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReportsStateMapper._());
      ViewStatusMapper.ensureInitialized();
      DailyReportLineMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ReportsState';

  static ViewStatus _$status(ReportsState v) => v.status;
  static const Field<ReportsState, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static String? _$errorMessage(ReportsState v) => v.errorMessage;
  static const Field<ReportsState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );
  static String _$date(ReportsState v) => v.date;
  static const Field<ReportsState, String> _f$date = Field(
    'date',
    _$date,
    opt: true,
    def: '',
  );
  static bool _$includeFollowing(ReportsState v) => v.includeFollowing;
  static const Field<ReportsState, bool> _f$includeFollowing = Field(
    'includeFollowing',
    _$includeFollowing,
    opt: true,
    def: false,
  );
  static List<DailyReportLine> _$lines(ReportsState v) => v.lines;
  static const Field<ReportsState, List<DailyReportLine>> _f$lines = Field(
    'lines',
    _$lines,
    opt: true,
    def: const [],
  );
  static bool _$persistInFlight(ReportsState v) => v.persistInFlight;
  static const Field<ReportsState, bool> _f$persistInFlight = Field(
    'persistInFlight',
    _$persistInFlight,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ReportsState> fields = const {
    #status: _f$status,
    #errorMessage: _f$errorMessage,
    #date: _f$date,
    #includeFollowing: _f$includeFollowing,
    #lines: _f$lines,
    #persistInFlight: _f$persistInFlight,
  };

  static ReportsState _instantiate(DecodingData data) {
    return ReportsState(
      status: data.dec(_f$status),
      errorMessage: data.dec(_f$errorMessage),
      date: data.dec(_f$date),
      includeFollowing: data.dec(_f$includeFollowing),
      lines: data.dec(_f$lines),
      persistInFlight: data.dec(_f$persistInFlight),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ReportsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReportsState>(map);
  }

  static ReportsState fromJson(String json) {
    return ensureInitialized().decodeJson<ReportsState>(json);
  }
}

mixin ReportsStateMappable {
  String toJson() {
    return ReportsStateMapper.ensureInitialized().encodeJson<ReportsState>(
      this as ReportsState,
    );
  }

  Map<String, dynamic> toMap() {
    return ReportsStateMapper.ensureInitialized().encodeMap<ReportsState>(
      this as ReportsState,
    );
  }

  ReportsStateCopyWith<ReportsState, ReportsState, ReportsState> get copyWith =>
      _ReportsStateCopyWithImpl<ReportsState, ReportsState>(
        this as ReportsState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReportsStateMapper.ensureInitialized().stringifyValue(
      this as ReportsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReportsStateMapper.ensureInitialized().equalsValue(
      this as ReportsState,
      other,
    );
  }

  @override
  int get hashCode {
    return ReportsStateMapper.ensureInitialized().hashValue(
      this as ReportsState,
    );
  }
}

extension ReportsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReportsState, $Out> {
  ReportsStateCopyWith<$R, ReportsState, $Out> get $asReportsState =>
      $base.as((v, t, t2) => _ReportsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReportsStateCopyWith<$R, $In extends ReportsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    DailyReportLine,
    DailyReportLineCopyWith<$R, DailyReportLine, DailyReportLine>
  >
  get lines;
  $R call({
    ViewStatus? status,
    String? errorMessage,
    String? date,
    bool? includeFollowing,
    List<DailyReportLine>? lines,
    bool? persistInFlight,
  });
  ReportsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReportsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReportsState, $Out>
    implements ReportsStateCopyWith<$R, ReportsState, $Out> {
  _ReportsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReportsState> $mapper =
      ReportsStateMapper.ensureInitialized();
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
    ViewStatus? status,
    Object? errorMessage = $none,
    String? date,
    bool? includeFollowing,
    List<DailyReportLine>? lines,
    bool? persistInFlight,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (errorMessage != $none) #errorMessage: errorMessage,
      if (date != null) #date: date,
      if (includeFollowing != null) #includeFollowing: includeFollowing,
      if (lines != null) #lines: lines,
      if (persistInFlight != null) #persistInFlight: persistInFlight,
    }),
  );
  @override
  ReportsState $make(CopyWithData data) => ReportsState(
    status: data.get(#status, or: $value.status),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
    date: data.get(#date, or: $value.date),
    includeFollowing: data.get(#includeFollowing, or: $value.includeFollowing),
    lines: data.get(#lines, or: $value.lines),
    persistInFlight: data.get(#persistInFlight, or: $value.persistInFlight),
  );

  @override
  ReportsStateCopyWith<$R2, ReportsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReportsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

