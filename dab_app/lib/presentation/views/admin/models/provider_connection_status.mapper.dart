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

  @override
  final MappableFields<ProviderConnectionStatus> fields = const {
    #status: _f$status,
    #message: _f$message,
    #lastCheck: _f$lastCheck,
  };

  static ProviderConnectionStatus _instantiate(DecodingData data) {
    return ProviderConnectionStatus(
      status: data.dec(_f$status),
      message: data.dec(_f$message),
      lastCheck: data.dec(_f$lastCheck),
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
  $R call({ViewStatus? status, String? message, DateTime? lastCheck});
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
  $R call({
    ViewStatus? status,
    Object? message = $none,
    Object? lastCheck = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (message != $none) #message: message,
      if (lastCheck != $none) #lastCheck: lastCheck,
    }),
  );
  @override
  ProviderConnectionStatus $make(CopyWithData data) => ProviderConnectionStatus(
    status: data.get(#status, or: $value.status),
    message: data.get(#message, or: $value.message),
    lastCheck: data.get(#lastCheck, or: $value.lastCheck),
  );

  @override
  ProviderConnectionStatusCopyWith<$R2, ProviderConnectionStatus, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProviderConnectionStatusCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

