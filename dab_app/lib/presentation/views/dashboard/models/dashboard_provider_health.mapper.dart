// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'dashboard_provider_health.dart';

class DashboardProviderHealthStatusMapper
    extends EnumMapper<DashboardProviderHealthStatus> {
  DashboardProviderHealthStatusMapper._();

  static DashboardProviderHealthStatusMapper? _instance;
  static DashboardProviderHealthStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardProviderHealthStatusMapper._(),
      );
    }
    return _instance!;
  }

  static DashboardProviderHealthStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DashboardProviderHealthStatus decode(dynamic value) {
    switch (value) {
      case r'live':
        return DashboardProviderHealthStatus.live;
      case r'degraded':
        return DashboardProviderHealthStatus.degraded;
      case r'offline':
        return DashboardProviderHealthStatus.offline;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DashboardProviderHealthStatus self) {
    switch (self) {
      case DashboardProviderHealthStatus.live:
        return r'live';
      case DashboardProviderHealthStatus.degraded:
        return r'degraded';
      case DashboardProviderHealthStatus.offline:
        return r'offline';
    }
  }
}

extension DashboardProviderHealthStatusMapperExtension
    on DashboardProviderHealthStatus {
  String toValue() {
    DashboardProviderHealthStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DashboardProviderHealthStatus>(this)
        as String;
  }
}

class DashboardProviderHealthMapper
    extends ClassMapperBase<DashboardProviderHealth> {
  DashboardProviderHealthMapper._();

  static DashboardProviderHealthMapper? _instance;
  static DashboardProviderHealthMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DashboardProviderHealthMapper._(),
      );
      DashboardProviderHealthStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DashboardProviderHealth';

  static String _$providerName(DashboardProviderHealth v) => v.providerName;
  static const Field<DashboardProviderHealth, String> _f$providerName = Field(
    'providerName',
    _$providerName,
  );
  static DashboardProviderHealthStatus _$status(DashboardProviderHealth v) =>
      v.status;
  static const Field<DashboardProviderHealth, DashboardProviderHealthStatus>
  _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: DashboardProviderHealthStatus.live,
  );
  static DateTime? _$lastEventAt(DashboardProviderHealth v) => v.lastEventAt;
  static const Field<DashboardProviderHealth, DateTime> _f$lastEventAt = Field(
    'lastEventAt',
    _$lastEventAt,
    opt: true,
  );

  @override
  final MappableFields<DashboardProviderHealth> fields = const {
    #providerName: _f$providerName,
    #status: _f$status,
    #lastEventAt: _f$lastEventAt,
  };

  static DashboardProviderHealth _instantiate(DecodingData data) {
    return DashboardProviderHealth(
      providerName: data.dec(_f$providerName),
      status: data.dec(_f$status),
      lastEventAt: data.dec(_f$lastEventAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DashboardProviderHealth fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DashboardProviderHealth>(map);
  }

  static DashboardProviderHealth fromJson(String json) {
    return ensureInitialized().decodeJson<DashboardProviderHealth>(json);
  }
}

mixin DashboardProviderHealthMappable {
  String toJson() {
    return DashboardProviderHealthMapper.ensureInitialized()
        .encodeJson<DashboardProviderHealth>(this as DashboardProviderHealth);
  }

  Map<String, dynamic> toMap() {
    return DashboardProviderHealthMapper.ensureInitialized()
        .encodeMap<DashboardProviderHealth>(this as DashboardProviderHealth);
  }

  DashboardProviderHealthCopyWith<
    DashboardProviderHealth,
    DashboardProviderHealth,
    DashboardProviderHealth
  >
  get copyWith =>
      _DashboardProviderHealthCopyWithImpl<
        DashboardProviderHealth,
        DashboardProviderHealth
      >(this as DashboardProviderHealth, $identity, $identity);
  @override
  String toString() {
    return DashboardProviderHealthMapper.ensureInitialized().stringifyValue(
      this as DashboardProviderHealth,
    );
  }

  @override
  bool operator ==(Object other) {
    return DashboardProviderHealthMapper.ensureInitialized().equalsValue(
      this as DashboardProviderHealth,
      other,
    );
  }

  @override
  int get hashCode {
    return DashboardProviderHealthMapper.ensureInitialized().hashValue(
      this as DashboardProviderHealth,
    );
  }
}

extension DashboardProviderHealthValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DashboardProviderHealth, $Out> {
  DashboardProviderHealthCopyWith<$R, DashboardProviderHealth, $Out>
  get $asDashboardProviderHealth => $base.as(
    (v, t, t2) => _DashboardProviderHealthCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DashboardProviderHealthCopyWith<
  $R,
  $In extends DashboardProviderHealth,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? providerName,
    DashboardProviderHealthStatus? status,
    DateTime? lastEventAt,
  });
  DashboardProviderHealthCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DashboardProviderHealthCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DashboardProviderHealth, $Out>
    implements
        DashboardProviderHealthCopyWith<$R, DashboardProviderHealth, $Out> {
  _DashboardProviderHealthCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DashboardProviderHealth> $mapper =
      DashboardProviderHealthMapper.ensureInitialized();
  @override
  $R call({
    String? providerName,
    DashboardProviderHealthStatus? status,
    Object? lastEventAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (providerName != null) #providerName: providerName,
      if (status != null) #status: status,
      if (lastEventAt != $none) #lastEventAt: lastEventAt,
    }),
  );
  @override
  DashboardProviderHealth $make(CopyWithData data) => DashboardProviderHealth(
    providerName: data.get(#providerName, or: $value.providerName),
    status: data.get(#status, or: $value.status),
    lastEventAt: data.get(#lastEventAt, or: $value.lastEventAt),
  );

  @override
  DashboardProviderHealthCopyWith<$R2, DashboardProviderHealth, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DashboardProviderHealthCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

