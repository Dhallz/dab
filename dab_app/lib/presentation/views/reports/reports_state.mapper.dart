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
      UserMapper.ensureInitialized();
      DailyReportLineMapper.ensureInitialized();
      ActivityMapper.ensureInitialized();
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
  static String _$ownerUserId(ReportsState v) => v.ownerUserId;
  static const Field<ReportsState, String> _f$ownerUserId = Field(
    'ownerUserId',
    _$ownerUserId,
    opt: true,
    def: '',
  );
  static String _$viewedUserId(ReportsState v) => v.viewedUserId;
  static const Field<ReportsState, String> _f$viewedUserId = Field(
    'viewedUserId',
    _$viewedUserId,
    opt: true,
    def: '',
  );
  static bool _$canBrowseTeam(ReportsState v) => v.canBrowseTeam;
  static const Field<ReportsState, bool> _f$canBrowseTeam = Field(
    'canBrowseTeam',
    _$canBrowseTeam,
    opt: true,
    def: false,
  );
  static List<User> _$directoryUsers(ReportsState v) => v.directoryUsers;
  static const Field<ReportsState, List<User>> _f$directoryUsers = Field(
    'directoryUsers',
    _$directoryUsers,
    opt: true,
    def: const [],
  );
  static List<String> _$availableDates(ReportsState v) => v.availableDates;
  static const Field<ReportsState, List<String>> _f$availableDates = Field(
    'availableDates',
    _$availableDates,
    opt: true,
    def: const [],
  );
  static String _$todayDate(ReportsState v) => v.todayDate;
  static const Field<ReportsState, String> _f$todayDate = Field(
    'todayDate',
    _$todayDate,
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
  static bool _$isDirty(ReportsState v) => v.isDirty;
  static const Field<ReportsState, bool> _f$isDirty = Field(
    'isDirty',
    _$isDirty,
    opt: true,
    def: false,
  );
  static bool _$isPastDeadline(ReportsState v) => v.isPastDeadline;
  static const Field<ReportsState, bool> _f$isPastDeadline = Field(
    'isPastDeadline',
    _$isPastDeadline,
    opt: true,
    def: false,
  );
  static String _$searchQuery(ReportsState v) => v.searchQuery;
  static const Field<ReportsState, String> _f$searchQuery = Field(
    'searchQuery',
    _$searchQuery,
    opt: true,
    def: '',
  );
  static List<Activity> _$searchResults(ReportsState v) => v.searchResults;
  static const Field<ReportsState, List<Activity>> _f$searchResults = Field(
    'searchResults',
    _$searchResults,
    opt: true,
    def: const [],
  );
  static ViewStatus _$searchStatus(ReportsState v) => v.searchStatus;
  static const Field<ReportsState, ViewStatus> _f$searchStatus = Field(
    'searchStatus',
    _$searchStatus,
    opt: true,
    def: ViewStatus.initial,
  );
  static List<Activity> _$searchPickerVisible(ReportsState v) =>
      v.searchPickerVisible;
  static const Field<ReportsState, List<Activity>> _f$searchPickerVisible =
      Field(
        'searchPickerVisible',
        _$searchPickerVisible,
        mode: FieldMode.member,
      );
  static bool _$isOwnReport(ReportsState v) => v.isOwnReport;
  static const Field<ReportsState, bool> _f$isOwnReport = Field(
    'isOwnReport',
    _$isOwnReport,
    mode: FieldMode.member,
  );
  static bool _$isReadOnly(ReportsState v) => v.isReadOnly;
  static const Field<ReportsState, bool> _f$isReadOnly = Field(
    'isReadOnly',
    _$isReadOnly,
    mode: FieldMode.member,
  );
  static bool _$canSave(ReportsState v) => v.canSave;
  static const Field<ReportsState, bool> _f$canSave = Field(
    'canSave',
    _$canSave,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ReportsState> fields = const {
    #status: _f$status,
    #errorMessage: _f$errorMessage,
    #date: _f$date,
    #ownerUserId: _f$ownerUserId,
    #viewedUserId: _f$viewedUserId,
    #canBrowseTeam: _f$canBrowseTeam,
    #directoryUsers: _f$directoryUsers,
    #availableDates: _f$availableDates,
    #todayDate: _f$todayDate,
    #includeFollowing: _f$includeFollowing,
    #lines: _f$lines,
    #persistInFlight: _f$persistInFlight,
    #isDirty: _f$isDirty,
    #isPastDeadline: _f$isPastDeadline,
    #searchQuery: _f$searchQuery,
    #searchResults: _f$searchResults,
    #searchStatus: _f$searchStatus,
    #searchPickerVisible: _f$searchPickerVisible,
    #isOwnReport: _f$isOwnReport,
    #isReadOnly: _f$isReadOnly,
    #canSave: _f$canSave,
  };

  static ReportsState _instantiate(DecodingData data) {
    return ReportsState(
      status: data.dec(_f$status),
      errorMessage: data.dec(_f$errorMessage),
      date: data.dec(_f$date),
      ownerUserId: data.dec(_f$ownerUserId),
      viewedUserId: data.dec(_f$viewedUserId),
      canBrowseTeam: data.dec(_f$canBrowseTeam),
      directoryUsers: data.dec(_f$directoryUsers),
      availableDates: data.dec(_f$availableDates),
      todayDate: data.dec(_f$todayDate),
      includeFollowing: data.dec(_f$includeFollowing),
      lines: data.dec(_f$lines),
      persistInFlight: data.dec(_f$persistInFlight),
      isDirty: data.dec(_f$isDirty),
      isPastDeadline: data.dec(_f$isPastDeadline),
      searchQuery: data.dec(_f$searchQuery),
      searchResults: data.dec(_f$searchResults),
      searchStatus: data.dec(_f$searchStatus),
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
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get directoryUsers;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get availableDates;
  ListCopyWith<
    $R,
    DailyReportLine,
    DailyReportLineCopyWith<$R, DailyReportLine, DailyReportLine>
  >
  get lines;
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get searchResults;
  $R call({
    ViewStatus? status,
    String? errorMessage,
    String? date,
    String? ownerUserId,
    String? viewedUserId,
    bool? canBrowseTeam,
    List<User>? directoryUsers,
    List<String>? availableDates,
    String? todayDate,
    bool? includeFollowing,
    List<DailyReportLine>? lines,
    bool? persistInFlight,
    bool? isDirty,
    bool? isPastDeadline,
    String? searchQuery,
    List<Activity>? searchResults,
    ViewStatus? searchStatus,
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
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get directoryUsers =>
      ListCopyWith(
        $value.directoryUsers,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(directoryUsers: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get availableDates => ListCopyWith(
    $value.availableDates,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(availableDates: v),
  );
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
  ListCopyWith<$R, Activity, ActivityCopyWith<$R, Activity, Activity>>
  get searchResults => ListCopyWith(
    $value.searchResults,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(searchResults: v),
  );
  @override
  $R call({
    ViewStatus? status,
    Object? errorMessage = $none,
    String? date,
    String? ownerUserId,
    String? viewedUserId,
    bool? canBrowseTeam,
    List<User>? directoryUsers,
    List<String>? availableDates,
    String? todayDate,
    bool? includeFollowing,
    List<DailyReportLine>? lines,
    bool? persistInFlight,
    bool? isDirty,
    bool? isPastDeadline,
    String? searchQuery,
    List<Activity>? searchResults,
    ViewStatus? searchStatus,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (errorMessage != $none) #errorMessage: errorMessage,
      if (date != null) #date: date,
      if (ownerUserId != null) #ownerUserId: ownerUserId,
      if (viewedUserId != null) #viewedUserId: viewedUserId,
      if (canBrowseTeam != null) #canBrowseTeam: canBrowseTeam,
      if (directoryUsers != null) #directoryUsers: directoryUsers,
      if (availableDates != null) #availableDates: availableDates,
      if (todayDate != null) #todayDate: todayDate,
      if (includeFollowing != null) #includeFollowing: includeFollowing,
      if (lines != null) #lines: lines,
      if (persistInFlight != null) #persistInFlight: persistInFlight,
      if (isDirty != null) #isDirty: isDirty,
      if (isPastDeadline != null) #isPastDeadline: isPastDeadline,
      if (searchQuery != null) #searchQuery: searchQuery,
      if (searchResults != null) #searchResults: searchResults,
      if (searchStatus != null) #searchStatus: searchStatus,
    }),
  );
  @override
  ReportsState $make(CopyWithData data) => ReportsState(
    status: data.get(#status, or: $value.status),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
    date: data.get(#date, or: $value.date),
    ownerUserId: data.get(#ownerUserId, or: $value.ownerUserId),
    viewedUserId: data.get(#viewedUserId, or: $value.viewedUserId),
    canBrowseTeam: data.get(#canBrowseTeam, or: $value.canBrowseTeam),
    directoryUsers: data.get(#directoryUsers, or: $value.directoryUsers),
    availableDates: data.get(#availableDates, or: $value.availableDates),
    todayDate: data.get(#todayDate, or: $value.todayDate),
    includeFollowing: data.get(#includeFollowing, or: $value.includeFollowing),
    lines: data.get(#lines, or: $value.lines),
    persistInFlight: data.get(#persistInFlight, or: $value.persistInFlight),
    isDirty: data.get(#isDirty, or: $value.isDirty),
    isPastDeadline: data.get(#isPastDeadline, or: $value.isPastDeadline),
    searchQuery: data.get(#searchQuery, or: $value.searchQuery),
    searchResults: data.get(#searchResults, or: $value.searchResults),
    searchStatus: data.get(#searchStatus, or: $value.searchStatus),
  );

  @override
  ReportsStateCopyWith<$R2, ReportsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReportsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
