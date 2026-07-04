// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'provider_connectivity_report.dart';

class ConnectivitySectionStatusMapper
    extends EnumMapper<ConnectivitySectionStatus> {
  ConnectivitySectionStatusMapper._();

  static ConnectivitySectionStatusMapper? _instance;
  static ConnectivitySectionStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ConnectivitySectionStatusMapper._(),
      );
    }
    return _instance!;
  }

  static ConnectivitySectionStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ConnectivitySectionStatus decode(dynamic value) {
    switch (value) {
      case r'success':
        return ConnectivitySectionStatus.success;
      case r'failure':
        return ConnectivitySectionStatus.failure;
      case r'warning':
        return ConnectivitySectionStatus.warning;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ConnectivitySectionStatus self) {
    switch (self) {
      case ConnectivitySectionStatus.success:
        return r'success';
      case ConnectivitySectionStatus.failure:
        return r'failure';
      case ConnectivitySectionStatus.warning:
        return r'warning';
    }
  }
}

extension ConnectivitySectionStatusMapperExtension
    on ConnectivitySectionStatus {
  String toValue() {
    ConnectivitySectionStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ConnectivitySectionStatus>(this)
        as String;
  }
}

class ProviderSectionResultMapper
    extends ClassMapperBase<ProviderSectionResult> {
  ProviderSectionResultMapper._();

  static ProviderSectionResultMapper? _instance;
  static ProviderSectionResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProviderSectionResultMapper._());
      ConnectivitySectionStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ProviderSectionResult';

  static ConnectivitySectionStatus _$status(ProviderSectionResult v) =>
      v.status;
  static const Field<ProviderSectionResult, ConnectivitySectionStatus>
  _f$status = Field('status', _$status);
  static String _$message(ProviderSectionResult v) => v.message;
  static const Field<ProviderSectionResult, String> _f$message = Field(
    'message',
    _$message,
  );

  @override
  final MappableFields<ProviderSectionResult> fields = const {
    #status: _f$status,
    #message: _f$message,
  };

  static ProviderSectionResult _instantiate(DecodingData data) {
    return ProviderSectionResult(
      status: data.dec(_f$status),
      message: data.dec(_f$message),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProviderSectionResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProviderSectionResult>(map);
  }

  static ProviderSectionResult fromJson(String json) {
    return ensureInitialized().decodeJson<ProviderSectionResult>(json);
  }
}

mixin ProviderSectionResultMappable {
  String toJson() {
    return ProviderSectionResultMapper.ensureInitialized()
        .encodeJson<ProviderSectionResult>(this as ProviderSectionResult);
  }

  Map<String, dynamic> toMap() {
    return ProviderSectionResultMapper.ensureInitialized()
        .encodeMap<ProviderSectionResult>(this as ProviderSectionResult);
  }

  ProviderSectionResultCopyWith<
    ProviderSectionResult,
    ProviderSectionResult,
    ProviderSectionResult
  >
  get copyWith =>
      _ProviderSectionResultCopyWithImpl<
        ProviderSectionResult,
        ProviderSectionResult
      >(this as ProviderSectionResult, $identity, $identity);
  @override
  String toString() {
    return ProviderSectionResultMapper.ensureInitialized().stringifyValue(
      this as ProviderSectionResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProviderSectionResultMapper.ensureInitialized().equalsValue(
      this as ProviderSectionResult,
      other,
    );
  }

  @override
  int get hashCode {
    return ProviderSectionResultMapper.ensureInitialized().hashValue(
      this as ProviderSectionResult,
    );
  }
}

extension ProviderSectionResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProviderSectionResult, $Out> {
  ProviderSectionResultCopyWith<$R, ProviderSectionResult, $Out>
  get $asProviderSectionResult => $base.as(
    (v, t, t2) => _ProviderSectionResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ProviderSectionResultCopyWith<
  $R,
  $In extends ProviderSectionResult,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({ConnectivitySectionStatus? status, String? message});
  ProviderSectionResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProviderSectionResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProviderSectionResult, $Out>
    implements ProviderSectionResultCopyWith<$R, ProviderSectionResult, $Out> {
  _ProviderSectionResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProviderSectionResult> $mapper =
      ProviderSectionResultMapper.ensureInitialized();
  @override
  $R call({ConnectivitySectionStatus? status, String? message}) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (message != null) #message: message,
    }),
  );
  @override
  ProviderSectionResult $make(CopyWithData data) => ProviderSectionResult(
    status: data.get(#status, or: $value.status),
    message: data.get(#message, or: $value.message),
  );

  @override
  ProviderSectionResultCopyWith<$R2, ProviderSectionResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProviderSectionResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ProviderConnectivityReportMapper
    extends ClassMapperBase<ProviderConnectivityReport> {
  ProviderConnectivityReportMapper._();

  static ProviderConnectivityReportMapper? _instance;
  static ProviderConnectivityReportMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ProviderConnectivityReportMapper._(),
      );
      ConnectivitySectionStatusMapper.ensureInitialized();
      ProviderSectionResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ProviderConnectivityReport';

  static ConnectivitySectionStatus _$aggregate(ProviderConnectivityReport v) =>
      v.aggregate;
  static const Field<ProviderConnectivityReport, ConnectivitySectionStatus>
  _f$aggregate = Field('aggregate', _$aggregate);
  static String _$summaryMessage(ProviderConnectivityReport v) =>
      v.summaryMessage;
  static const Field<ProviderConnectivityReport, String> _f$summaryMessage =
      Field('summaryMessage', _$summaryMessage);
  static ProviderSectionResult _$core(ProviderConnectivityReport v) => v.core;
  static const Field<ProviderConnectivityReport, ProviderSectionResult>
  _f$core = Field('core', _$core);
  static ProviderSectionResult _$live(ProviderConnectivityReport v) => v.live;
  static const Field<ProviderConnectivityReport, ProviderSectionResult>
  _f$live = Field('live', _$live);
  static ProviderSectionResult _$polling(ProviderConnectivityReport v) =>
      v.polling;
  static const Field<ProviderConnectivityReport, ProviderSectionResult>
  _f$polling = Field('polling', _$polling);

  @override
  final MappableFields<ProviderConnectivityReport> fields = const {
    #aggregate: _f$aggregate,
    #summaryMessage: _f$summaryMessage,
    #core: _f$core,
    #live: _f$live,
    #polling: _f$polling,
  };

  static ProviderConnectivityReport _instantiate(DecodingData data) {
    return ProviderConnectivityReport(
      aggregate: data.dec(_f$aggregate),
      summaryMessage: data.dec(_f$summaryMessage),
      core: data.dec(_f$core),
      live: data.dec(_f$live),
      polling: data.dec(_f$polling),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProviderConnectivityReport fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProviderConnectivityReport>(map);
  }

  static ProviderConnectivityReport fromJson(String json) {
    return ensureInitialized().decodeJson<ProviderConnectivityReport>(json);
  }
}

mixin ProviderConnectivityReportMappable {
  String toJson() {
    return ProviderConnectivityReportMapper.ensureInitialized()
        .encodeJson<ProviderConnectivityReport>(
          this as ProviderConnectivityReport,
        );
  }

  Map<String, dynamic> toMap() {
    return ProviderConnectivityReportMapper.ensureInitialized()
        .encodeMap<ProviderConnectivityReport>(
          this as ProviderConnectivityReport,
        );
  }

  ProviderConnectivityReportCopyWith<
    ProviderConnectivityReport,
    ProviderConnectivityReport,
    ProviderConnectivityReport
  >
  get copyWith =>
      _ProviderConnectivityReportCopyWithImpl<
        ProviderConnectivityReport,
        ProviderConnectivityReport
      >(this as ProviderConnectivityReport, $identity, $identity);
  @override
  String toString() {
    return ProviderConnectivityReportMapper.ensureInitialized().stringifyValue(
      this as ProviderConnectivityReport,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProviderConnectivityReportMapper.ensureInitialized().equalsValue(
      this as ProviderConnectivityReport,
      other,
    );
  }

  @override
  int get hashCode {
    return ProviderConnectivityReportMapper.ensureInitialized().hashValue(
      this as ProviderConnectivityReport,
    );
  }
}

extension ProviderConnectivityReportValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProviderConnectivityReport, $Out> {
  ProviderConnectivityReportCopyWith<$R, ProviderConnectivityReport, $Out>
  get $asProviderConnectivityReport => $base.as(
    (v, t, t2) => _ProviderConnectivityReportCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ProviderConnectivityReportCopyWith<
  $R,
  $In extends ProviderConnectivityReport,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >
  get core;
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >
  get live;
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >
  get polling;
  $R call({
    ConnectivitySectionStatus? aggregate,
    String? summaryMessage,
    ProviderSectionResult? core,
    ProviderSectionResult? live,
    ProviderSectionResult? polling,
  });
  ProviderConnectivityReportCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProviderConnectivityReportCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProviderConnectivityReport, $Out>
    implements
        ProviderConnectivityReportCopyWith<
          $R,
          ProviderConnectivityReport,
          $Out
        > {
  _ProviderConnectivityReportCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProviderConnectivityReport> $mapper =
      ProviderConnectivityReportMapper.ensureInitialized();
  @override
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >
  get core => $value.core.copyWith.$chain((v) => call(core: v));
  @override
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >
  get live => $value.live.copyWith.$chain((v) => call(live: v));
  @override
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >
  get polling => $value.polling.copyWith.$chain((v) => call(polling: v));
  @override
  $R call({
    ConnectivitySectionStatus? aggregate,
    String? summaryMessage,
    ProviderSectionResult? core,
    ProviderSectionResult? live,
    ProviderSectionResult? polling,
  }) => $apply(
    FieldCopyWithData({
      if (aggregate != null) #aggregate: aggregate,
      if (summaryMessage != null) #summaryMessage: summaryMessage,
      if (core != null) #core: core,
      if (live != null) #live: live,
      if (polling != null) #polling: polling,
    }),
  );
  @override
  ProviderConnectivityReport $make(CopyWithData data) =>
      ProviderConnectivityReport(
        aggregate: data.get(#aggregate, or: $value.aggregate),
        summaryMessage: data.get(#summaryMessage, or: $value.summaryMessage),
        core: data.get(#core, or: $value.core),
        live: data.get(#live, or: $value.live),
        polling: data.get(#polling, or: $value.polling),
      );

  @override
  ProviderConnectivityReportCopyWith<$R2, ProviderConnectivityReport, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProviderConnectivityReportCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

