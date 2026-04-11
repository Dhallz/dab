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
      UserMapper.ensureInitialized();
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
  static User? _$user(AuthState v) => v.user;
  static const Field<AuthState, User> _f$user = Field(
    'user',
    _$user,
    opt: true,
  );
  static String? _$errorMessage(AuthState v) => v.errorMessage;
  static const Field<AuthState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );
  static bool _$isAuthenticated(AuthState v) => v.isAuthenticated;
  static const Field<AuthState, bool> _f$isAuthenticated = Field(
    'isAuthenticated',
    _$isAuthenticated,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<AuthState> fields = const {
    #status: _f$status,
    #user: _f$user,
    #errorMessage: _f$errorMessage,
    #isAuthenticated: _f$isAuthenticated,
  };

  static AuthState _instantiate(DecodingData data) {
    return AuthState(
      status: data.dec(_f$status),
      user: data.dec(_f$user),
      errorMessage: data.dec(_f$errorMessage),
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
  UserCopyWith<$R, User, User>? get user;
  $R call({ViewStatus? status, User? user, String? errorMessage});
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
  UserCopyWith<$R, User, User>? get user =>
      $value.user?.copyWith.$chain((v) => call(user: v));
  @override
  $R call({
    ViewStatus? status,
    Object? user = $none,
    Object? errorMessage = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (user != $none) #user: user,
      if (errorMessage != $none) #errorMessage: errorMessage,
    }),
  );
  @override
  AuthState $make(CopyWithData data) => AuthState(
    status: data.get(#status, or: $value.status),
    user: data.get(#user, or: $value.user),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
  );

  @override
  AuthStateCopyWith<$R2, AuthState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

