// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_state.dart';

class AuthStateMapper extends ClassMapperBase<AuthState> {
  AuthStateMapper._();

  static AuthStateMapper? _instance;
  static AuthStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthStateMapper._());
      ViewStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthState';

  static ViewStatus _$status(AuthState v) => v.status;
  static const Field<AuthState, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static bool _$isLogin(AuthState v) => v.isLogin;
  static const Field<AuthState, bool> _f$isLogin = Field(
    'isLogin',
    _$isLogin,
    opt: true,
    def: true,
  );
  static String? _$errorMessage(AuthState v) => v.errorMessage;
  static const Field<AuthState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );
  static String _$email(AuthState v) => v.email;
  static const Field<AuthState, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
    def: '',
  );
  static String _$password(AuthState v) => v.password;
  static const Field<AuthState, String> _f$password = Field(
    'password',
    _$password,
    opt: true,
    def: '',
  );
  static String _$name(AuthState v) => v.name;
  static const Field<AuthState, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
    def: '',
  );
  static bool _$isRegister(AuthState v) => v.isRegister;
  static const Field<AuthState, bool> _f$isRegister = Field(
    'isRegister',
    _$isRegister,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<AuthState> fields = const {
    #status: _f$status,
    #isLogin: _f$isLogin,
    #errorMessage: _f$errorMessage,
    #email: _f$email,
    #password: _f$password,
    #name: _f$name,
    #isRegister: _f$isRegister,
  };

  static AuthState _instantiate(DecodingData data) {
    return AuthState(
      status: data.dec(_f$status),
      isLogin: data.dec(_f$isLogin),
      errorMessage: data.dec(_f$errorMessage),
      email: data.dec(_f$email),
      password: data.dec(_f$password),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthState>(map);
  }

  static AuthState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthState>(json);
  }
}

mixin AuthStateMappable {
  String toJson() {
    return AuthStateMapper.ensureInitialized().encodeJson<AuthState>(
      this as AuthState,
    );
  }

  Map<String, dynamic> toMap() {
    return AuthStateMapper.ensureInitialized().encodeMap<AuthState>(
      this as AuthState,
    );
  }

  AuthStateCopyWith<AuthState, AuthState, AuthState> get copyWith =>
      _AuthStateCopyWithImpl<AuthState, AuthState>(
        this as AuthState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthStateMapper.ensureInitialized().stringifyValue(
      this as AuthState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthStateMapper.ensureInitialized().equalsValue(
      this as AuthState,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthStateMapper.ensureInitialized().hashValue(this as AuthState);
  }
}

extension AuthStateValueCopy<$R, $Out> on ObjectCopyWith<$R, AuthState, $Out> {
  AuthStateCopyWith<$R, AuthState, $Out> get $asAuthState =>
      $base.as((v, t, t2) => _AuthStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthStateCopyWith<$R, $In extends AuthState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    ViewStatus? status,
    bool? isLogin,
    String? errorMessage,
    String? email,
    String? password,
    String? name,
  });
  AuthStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthState, $Out>
    implements AuthStateCopyWith<$R, AuthState, $Out> {
  _AuthStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthState> $mapper =
      AuthStateMapper.ensureInitialized();
  @override
  $R call({
    ViewStatus? status,
    bool? isLogin,
    Object? errorMessage = $none,
    String? email,
    String? password,
    String? name,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (isLogin != null) #isLogin: isLogin,
      if (errorMessage != $none) #errorMessage: errorMessage,
      if (email != null) #email: email,
      if (password != null) #password: password,
      if (name != null) #name: name,
    }),
  );
  @override
  AuthState $make(CopyWithData data) => AuthState(
    status: data.get(#status, or: $value.status),
    isLogin: data.get(#isLogin, or: $value.isLogin),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
    email: data.get(#email, or: $value.email),
    password: data.get(#password, or: $value.password),
    name: data.get(#name, or: $value.name),
  );

  @override
  AuthStateCopyWith<$R2, AuthState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

