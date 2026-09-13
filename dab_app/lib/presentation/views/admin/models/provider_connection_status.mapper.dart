// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'provider_connection_status.dart';

class ProviderConnectionStatusMapper
    extends ClassMapperBase<ProviderConnectionStatus> {
  ProviderConnectionStatusMapper._();

  static ProviderConnectionStatusMapper? _instance;
  static ProviderConnectionStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ProviderConnectionStatusMapper._(),
      );
      ViewStatusMapper.ensureInitialized();
      ProviderSectionResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ProviderConnectionStatus';

  static ViewStatus _$status(ProviderConnectionStatus v) => v.status;
  static const Field<ProviderConnectionStatus, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static String? _$message(ProviderConnectionStatus v) => v.message;
  static const Field<ProviderConnectionStatus, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );
  static DateTime? _$lastCheck(ProviderConnectionStatus v) => v.lastCheck;
  static const Field<ProviderConnectionStatus, DateTime> _f$lastCheck = Field(
    'lastCheck',
    _$lastCheck,
    opt: true,
  );
  static ProviderSectionResult? _$core(ProviderConnectionStatus v) => v.core;
  static const Field<ProviderConnectionStatus, ProviderSectionResult> _f$core =
      Field('core', _$core, opt: true);
  static ProviderSectionResult? _$live(ProviderConnectionStatus v) => v.live;
  static const Field<ProviderConnectionStatus, ProviderSectionResult> _f$live =
      Field('live', _$live, opt: true);
  static ProviderSectionResult? _$polling(ProviderConnectionStatus v) =>
      v.polling;
  static const Field<ProviderConnectionStatus, ProviderSectionResult>
  _f$polling = Field('polling', _$polling, opt: true);

  @override
  final MappableFields<ProviderConnectionStatus> fields = const {
    #status: _f$status,
    #message: _f$message,
    #lastCheck: _f$lastCheck,
    #core: _f$core,
    #live: _f$live,
    #polling: _f$polling,
  };

  static ProviderConnectionStatus _instantiate(DecodingData data) {
    return ProviderConnectionStatus(
      status: data.dec(_f$status),
      message: data.dec(_f$message),
      lastCheck: data.dec(_f$lastCheck),
      core: data.dec(_f$core),
      live: data.dec(_f$live),
      polling: data.dec(_f$polling),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProviderConnectionStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProviderConnectionStatus>(map);
  }

  static ProviderConnectionStatus fromJson(String json) {
    return ensureInitialized().decodeJson<ProviderConnectionStatus>(json);
  }
}

mixin ProviderConnectionStatusMappable {
  String toJson() {
    return ProviderConnectionStatusMapper.ensureInitialized()
        .encodeJson<ProviderConnectionStatus>(this as ProviderConnectionStatus);
  }

  Map<String, dynamic> toMap() {
    return ProviderConnectionStatusMapper.ensureInitialized()
        .encodeMap<ProviderConnectionStatus>(this as ProviderConnectionStatus);
  }

  ProviderConnectionStatusCopyWith<
    ProviderConnectionStatus,
    ProviderConnectionStatus,
    ProviderConnectionStatus
  >
  get copyWith =>
      _ProviderConnectionStatusCopyWithImpl<
        ProviderConnectionStatus,
        ProviderConnectionStatus
      >(this as ProviderConnectionStatus, $identity, $identity);
  @override
  String toString() {
    return ProviderConnectionStatusMapper.ensureInitialized().stringifyValue(
      this as ProviderConnectionStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProviderConnectionStatusMapper.ensureInitialized().equalsValue(
      this as ProviderConnectionStatus,
      other,
    );
  }

  @override
  int get hashCode {
    return ProviderConnectionStatusMapper.ensureInitialized().hashValue(
      this as ProviderConnectionStatus,
    );
  }
}

extension ProviderConnectionStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProviderConnectionStatus, $Out> {
  ProviderConnectionStatusCopyWith<$R, ProviderConnectionStatus, $Out>
  get $asProviderConnectionStatus => $base.as(
    (v, t, t2) => _ProviderConnectionStatusCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ProviderConnectionStatusCopyWith<
  $R,
  $In extends ProviderConnectionStatus,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >?
  get core;
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >?
  get live;
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >?
  get polling;
  $R call({
    ViewStatus? status,
    String? message,
    DateTime? lastCheck,
    ProviderSectionResult? core,
    ProviderSectionResult? live,
    ProviderSectionResult? polling,
  });
  ProviderConnectionStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProviderConnectionStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProviderConnectionStatus, $Out>
    implements
        ProviderConnectionStatusCopyWith<$R, ProviderConnectionStatus, $Out> {
  _ProviderConnectionStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProviderConnectionStatus> $mapper =
      ProviderConnectionStatusMapper.ensureInitialized();
  @override
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >?
  get core => $value.core?.copyWith.$chain((v) => call(core: v));
  @override
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >?
  get live => $value.live?.copyWith.$chain((v) => call(live: v));
  @override
  ProviderSectionResultCopyWith<
    $R,
    ProviderSectionResult,
    ProviderSectionResult
  >?
  get polling => $value.polling?.copyWith.$chain((v) => call(polling: v));
  @override
  $R call({
    ViewStatus? status,
    Object? message = $none,
    Object? lastCheck = $none,
    Object? core = $none,
    Object? live = $none,
    Object? polling = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (message != $none) #message: message,
      if (lastCheck != $none) #lastCheck: lastCheck,
      if (core != $none) #core: core,
      if (live != $none) #live: live,
      if (polling != $none) #polling: polling,
    }),
  );
  @override
  ProviderConnectionStatus $make(CopyWithData data) => ProviderConnectionStatus(
    status: data.get(#status, or: $value.status),
    message: data.get(#message, or: $value.message),
    lastCheck: data.get(#lastCheck, or: $value.lastCheck),
    core: data.get(#core, or: $value.core),
    live: data.get(#live, or: $value.live),
    polling: data.get(#polling, or: $value.polling),
  );

  @override
  ProviderConnectionStatusCopyWith<$R2, ProviderConnectionStatus, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProviderConnectionStatusCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

