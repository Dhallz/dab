// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_response.dart';

class AuthResponseMapper extends ClassMapperBase<AuthResponse> {
  AuthResponseMapper._();

  static AuthResponseMapper? _instance;
  static AuthResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthResponse';

  static String _$accessToken(AuthResponse v) => v.accessToken;
  static const Field<AuthResponse, String> _f$accessToken = Field(
    'accessToken',
    _$accessToken,
  );
  static String _$refreshToken(AuthResponse v) => v.refreshToken;
  static const Field<AuthResponse, String> _f$refreshToken = Field(
    'refreshToken',
    _$refreshToken,
  );
  static String _$userId(AuthResponse v) => v.userId;
  static const Field<AuthResponse, String> _f$userId = Field(
    'userId',
    _$userId,
  );

  @override
  final MappableFields<AuthResponse> fields = const {
    #accessToken: _f$accessToken,
    #refreshToken: _f$refreshToken,
    #userId: _f$userId,
  };

  static AuthResponse _instantiate(DecodingData data) {
    return AuthResponse(
      accessToken: data.dec(_f$accessToken),
      refreshToken: data.dec(_f$refreshToken),
      userId: data.dec(_f$userId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthResponse>(map);
  }

  static AuthResponse fromJson(String json) {
    return ensureInitialized().decodeJson<AuthResponse>(json);
  }
}

mixin AuthResponseMappable {
  String toJson() {
    return AuthResponseMapper.ensureInitialized().encodeJson<AuthResponse>(
      this as AuthResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return AuthResponseMapper.ensureInitialized().encodeMap<AuthResponse>(
      this as AuthResponse,
    );
  }

  AuthResponseCopyWith<AuthResponse, AuthResponse, AuthResponse> get copyWith =>
      _AuthResponseCopyWithImpl<AuthResponse, AuthResponse>(
        this as AuthResponse,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthResponseMapper.ensureInitialized().stringifyValue(
      this as AuthResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthResponseMapper.ensureInitialized().equalsValue(
      this as AuthResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthResponseMapper.ensureInitialized().hashValue(
      this as AuthResponse,
    );
  }
}

extension AuthResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthResponse, $Out> {
  AuthResponseCopyWith<$R, AuthResponse, $Out> get $asAuthResponse =>
      $base.as((v, t, t2) => _AuthResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthResponseCopyWith<$R, $In extends AuthResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? accessToken, String? refreshToken, String? userId});
  AuthResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthResponse, $Out>
    implements AuthResponseCopyWith<$R, AuthResponse, $Out> {
  _AuthResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthResponse> $mapper =
      AuthResponseMapper.ensureInitialized();
  @override
  $R call({String? accessToken, String? refreshToken, String? userId}) =>
      $apply(
        FieldCopyWithData({
          if (accessToken != null) #accessToken: accessToken,
          if (refreshToken != null) #refreshToken: refreshToken,
          if (userId != null) #userId: userId,
        }),
      );
  @override
  AuthResponse $make(CopyWithData data) => AuthResponse(
    accessToken: data.get(#accessToken, or: $value.accessToken),
    refreshToken: data.get(#refreshToken, or: $value.refreshToken),
    userId: data.get(#userId, or: $value.userId),
  );

  @override
  AuthResponseCopyWith<$R2, AuthResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

