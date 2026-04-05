// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'session.dart';

class SessionMapper extends ClassMapperBase<Session> {
  SessionMapper._();

  static SessionMapper? _instance;
  static SessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SessionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Session';

  static String _$id(Session v) => v.id;
  static const Field<Session, String> _f$id = Field('id', _$id);
  static String _$userId(Session v) => v.userId;
  static const Field<Session, String> _f$userId = Field('userId', _$userId);
  static String _$refreshToken(Session v) => v.refreshToken;
  static const Field<Session, String> _f$refreshToken = Field(
    'refreshToken',
    _$refreshToken,
  );
  static DateTime _$expiresAt(Session v) => v.expiresAt;
  static const Field<Session, DateTime> _f$expiresAt = Field(
    'expiresAt',
    _$expiresAt,
  );
  static String? _$deviceInfo(Session v) => v.deviceInfo;
  static const Field<Session, String> _f$deviceInfo = Field(
    'deviceInfo',
    _$deviceInfo,
    opt: true,
  );

  @override
  final MappableFields<Session> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #refreshToken: _f$refreshToken,
    #expiresAt: _f$expiresAt,
    #deviceInfo: _f$deviceInfo,
  };

  static Session _instantiate(DecodingData data) {
    return Session(
      id: data.dec(_f$id),
      userId: data.dec(_f$userId),
      refreshToken: data.dec(_f$refreshToken),
      expiresAt: data.dec(_f$expiresAt),
      deviceInfo: data.dec(_f$deviceInfo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Session fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Session>(map);
  }

  static Session fromJson(String json) {
    return ensureInitialized().decodeJson<Session>(json);
  }
}

mixin SessionMappable {
  String toJson() {
    return SessionMapper.ensureInitialized().encodeJson<Session>(
      this as Session,
    );
  }

  Map<String, dynamic> toMap() {
    return SessionMapper.ensureInitialized().encodeMap<Session>(
      this as Session,
    );
  }

  SessionCopyWith<Session, Session, Session> get copyWith =>
      _SessionCopyWithImpl<Session, Session>(
        this as Session,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SessionMapper.ensureInitialized().stringifyValue(this as Session);
  }

  @override
  bool operator ==(Object other) {
    return SessionMapper.ensureInitialized().equalsValue(
      this as Session,
      other,
    );
  }

  @override
  int get hashCode {
    return SessionMapper.ensureInitialized().hashValue(this as Session);
  }
}

extension SessionValueCopy<$R, $Out> on ObjectCopyWith<$R, Session, $Out> {
  SessionCopyWith<$R, Session, $Out> get $asSession =>
      $base.as((v, t, t2) => _SessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SessionCopyWith<$R, $In extends Session, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? userId,
    String? refreshToken,
    DateTime? expiresAt,
    String? deviceInfo,
  });
  SessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Session, $Out>
    implements SessionCopyWith<$R, Session, $Out> {
  _SessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Session> $mapper =
      SessionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? userId,
    String? refreshToken,
    DateTime? expiresAt,
    Object? deviceInfo = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (userId != null) #userId: userId,
      if (refreshToken != null) #refreshToken: refreshToken,
      if (expiresAt != null) #expiresAt: expiresAt,
      if (deviceInfo != $none) #deviceInfo: deviceInfo,
    }),
  );
  @override
  Session $make(CopyWithData data) => Session(
    id: data.get(#id, or: $value.id),
    userId: data.get(#userId, or: $value.userId),
    refreshToken: data.get(#refreshToken, or: $value.refreshToken),
    expiresAt: data.get(#expiresAt, or: $value.expiresAt),
    deviceInfo: data.get(#deviceInfo, or: $value.deviceInfo),
  );

  @override
  SessionCopyWith<$R2, Session, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

