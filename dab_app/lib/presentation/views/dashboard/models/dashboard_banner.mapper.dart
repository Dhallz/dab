// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'dashboard_banner.dart';

class DashboardBannerMapper extends ClassMapperBase<DashboardBanner> {
  DashboardBannerMapper._();

  static DashboardBannerMapper? _instance;
  static DashboardBannerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DashboardBannerMapper._());
      DashboardBannerSeverityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardBanner';

  static String _$eventId(DashboardBanner v) => v.eventId;
  static const Field<DashboardBanner, String> _f$eventId = Field(
    'eventId',
    _$eventId,
  );
  static String _$title(DashboardBanner v) => v.title;
  static const Field<DashboardBanner, String> _f$title = Field(
    'title',
    _$title,
  );
  static Duration _$untilStart(DashboardBanner v) => v.untilStart;
  static const Field<DashboardBanner, Duration> _f$untilStart = Field(
    'untilStart',
    _$untilStart,
  );
  static int _$thresholdMinutes(DashboardBanner v) => v.thresholdMinutes;
  static const Field<DashboardBanner, int> _f$thresholdMinutes = Field(
    'thresholdMinutes',
    _$thresholdMinutes,
  );
  static String? _$url(DashboardBanner v) => v.url;
  static const Field<DashboardBanner, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static DashboardBannerSeverity _$severity(DashboardBanner v) => v.severity;
  static const Field<DashboardBanner, DashboardBannerSeverity> _f$severity =
      Field(
        'severity',
        _$severity,
        opt: true,
        def: DashboardBannerSeverity.info,
      );
  static String _$dedupeKey(DashboardBanner v) => v.dedupeKey;
  static const Field<DashboardBanner, String> _f$dedupeKey = Field(
    'dedupeKey',
    _$dedupeKey,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<DashboardBanner> fields = const {
    #eventId: _f$eventId,
    #title: _f$title,
    #untilStart: _f$untilStart,
    #thresholdMinutes: _f$thresholdMinutes,
    #url: _f$url,
    #severity: _f$severity,
    #dedupeKey: _f$dedupeKey,
  };

  static DashboardBanner _instantiate(DecodingData data) {
    return DashboardBanner(
      eventId: data.dec(_f$eventId),
      title: data.dec(_f$title),
      untilStart: data.dec(_f$untilStart),
      thresholdMinutes: data.dec(_f$thresholdMinutes),
      url: data.dec(_f$url),
      severity: data.dec(_f$severity),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardBanner fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardBanner>(map);
  }

  static DashboardBanner fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardBanner>(json);
  }
}

mixin DashboardBannerMappable {
  String toJson() {
    return DashboardBannerMapper.ensureInitialized()
        .encodeJson<DashboardBanner>(this as DashboardBanner);
  }

  Map<String, dynamic> toMap() {
    return DashboardBannerMapper.ensureInitialized().encodeMap<DashboardBanner>(
      this as DashboardBanner,
    );
  }

  DashboardBannerCopyWith<DashboardBanner, DashboardBanner, DashboardBanner>
  get copyWith =>
      _DashboardBannerCopyWithImpl<DashboardBanner, DashboardBanner>(
        this as DashboardBanner,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DashboardBannerMapper.ensureInitialized().stringifyValue(
      this as DashboardBanner,
    );
  }

  @override
  bool operator ==(Object other) {
    return DashboardBannerMapper.ensureInitialized().equalsValue(
      this as DashboardBanner,
      other,
    );
  }

  @override
  int get hashCode {
    return DashboardBannerMapper.ensureInitialized().hashValue(
      this as DashboardBanner,
    );
  }
}

extension DashboardBannerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardBanner, $Out> {
  DashboardBannerCopyWith<$R, DashboardBanner, $Out> get $asDashboardBanner =>
      $base.as((v, t, t2) => _DashboardBannerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DashboardBannerCopyWith<$R, $In extends DashboardBanner, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? eventId,
    String? title,
    Duration? untilStart,
    int? thresholdMinutes,
    String? url,
    DashboardBannerSeverity? severity,
  });
  DashboardBannerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardBannerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardBanner, $Out>
    implements DashboardBannerCopyWith<$R, DashboardBanner, $Out> {
  _DashboardBannerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DashboardBanner> $mapper =
      DashboardBannerMapper.ensureInitialized();
  @override
  $R call({
    String? eventId,
    String? title,
    Duration? untilStart,
    int? thresholdMinutes,
    Object? url = $none,
    DashboardBannerSeverity? severity,
  }) => $apply(
    FieldCopyWithData({
      if (eventId != null) #eventId: eventId,
      if (title != null) #title: title,
      if (untilStart != null) #untilStart: untilStart,
      if (thresholdMinutes != null) #thresholdMinutes: thresholdMinutes,
      if (url != $none) #url: url,
      if (severity != null) #severity: severity,
    }),
  );
  @override
  DashboardBanner $make(CopyWithData data) => DashboardBanner(
    eventId: data.get(#eventId, or: $value.eventId),
    title: data.get(#title, or: $value.title),
    untilStart: data.get(#untilStart, or: $value.untilStart),
    thresholdMinutes: data.get(#thresholdMinutes, or: $value.thresholdMinutes),
    url: data.get(#url, or: $value.url),
    severity: data.get(#severity, or: $value.severity),
  );

  @override
  DashboardBannerCopyWith<$R2, DashboardBanner, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DashboardBannerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

