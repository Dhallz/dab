// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'login_state.dart';

class LoginStateMapper extends ClassMapperBase<LoginState> {
  LoginStateMapper._();

  static LoginStateMapper? _instance;
  static LoginStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginStateMapper._());
      LoginInitialMapper.ensureInitialized();
      LoginLoadingMapper.ensureInitialized();
      LoginSuccessMapper.ensureInitialized();
      LoginFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LoginState';

  @override
  final MappableFields<LoginState> fields = const {};

  static LoginState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'LoginState',
      'status',
      '${data.value['status']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoginState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginState>(map);
  }

  static LoginState fromJson(String json) {
    return ensureInitialized().decodeJson<LoginState>(json);
  }
}

mixin LoginStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  LoginStateCopyWith<LoginState, LoginState, LoginState> get copyWith;
}

abstract class LoginStateCopyWith<$R, $In extends LoginState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  LoginStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class LoginInitialMapper extends SubClassMapperBase<LoginInitial> {
  LoginInitialMapper._();

  static LoginInitialMapper? _instance;
  static LoginInitialMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginInitialMapper._());
      LoginStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'LoginInitial';

  @override
  final MappableFields<LoginInitial> fields = const {};

  @override
  final String discriminatorKey = 'status';
  @override
  final dynamic discriminatorValue = 'LoginInitial';
  @override
  late final ClassMapperBase superMapper = LoginStateMapper.ensureInitialized();

  static LoginInitial _instantiate(DecodingData data) {
    return LoginInitial();
  }

  @override
  final Function instantiate = _instantiate;

  static LoginInitial fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginInitial>(map);
  }

  static LoginInitial fromJson(String json) {
    return ensureInitialized().decodeJson<LoginInitial>(json);
  }
}

mixin LoginInitialMappable {
  String toJson() {
    return LoginInitialMapper.ensureInitialized().encodeJson<LoginInitial>(
      this as LoginInitial,
    );
  }

  Map<String, dynamic> toMap() {
    return LoginInitialMapper.ensureInitialized().encodeMap<LoginInitial>(
      this as LoginInitial,
    );
  }

  LoginInitialCopyWith<LoginInitial, LoginInitial, LoginInitial> get copyWith =>
      _LoginInitialCopyWithImpl<LoginInitial, LoginInitial>(
        this as LoginInitial,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LoginInitialMapper.ensureInitialized().stringifyValue(
      this as LoginInitial,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginInitialMapper.ensureInitialized().equalsValue(
      this as LoginInitial,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginInitialMapper.ensureInitialized().hashValue(
      this as LoginInitial,
    );
  }
}

extension LoginInitialValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginInitial, $Out> {
  LoginInitialCopyWith<$R, LoginInitial, $Out> get $asLoginInitial =>
      $base.as((v, t, t2) => _LoginInitialCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginInitialCopyWith<$R, $In extends LoginInitial, $Out>
    implements LoginStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  LoginInitialCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginInitialCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginInitial, $Out>
    implements LoginInitialCopyWith<$R, LoginInitial, $Out> {
  _LoginInitialCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginInitial> $mapper =
      LoginInitialMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  LoginInitial $make(CopyWithData data) => LoginInitial();

  @override
  LoginInitialCopyWith<$R2, LoginInitial, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoginInitialCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LoginLoadingMapper extends SubClassMapperBase<LoginLoading> {
  LoginLoadingMapper._();

  static LoginLoadingMapper? _instance;
  static LoginLoadingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginLoadingMapper._());
      LoginStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'LoginLoading';

  @override
  final MappableFields<LoginLoading> fields = const {};

  @override
  final String discriminatorKey = 'status';
  @override
  final dynamic discriminatorValue = 'LoginLoading';
  @override
  late final ClassMapperBase superMapper = LoginStateMapper.ensureInitialized();

  static LoginLoading _instantiate(DecodingData data) {
    return LoginLoading();
  }

  @override
  final Function instantiate = _instantiate;

  static LoginLoading fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginLoading>(map);
  }

  static LoginLoading fromJson(String json) {
    return ensureInitialized().decodeJson<LoginLoading>(json);
  }
}

mixin LoginLoadingMappable {
  String toJson() {
    return LoginLoadingMapper.ensureInitialized().encodeJson<LoginLoading>(
      this as LoginLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return LoginLoadingMapper.ensureInitialized().encodeMap<LoginLoading>(
      this as LoginLoading,
    );
  }

  LoginLoadingCopyWith<LoginLoading, LoginLoading, LoginLoading> get copyWith =>
      _LoginLoadingCopyWithImpl<LoginLoading, LoginLoading>(
        this as LoginLoading,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LoginLoadingMapper.ensureInitialized().stringifyValue(
      this as LoginLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginLoadingMapper.ensureInitialized().equalsValue(
      this as LoginLoading,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginLoadingMapper.ensureInitialized().hashValue(
      this as LoginLoading,
    );
  }
}

extension LoginLoadingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginLoading, $Out> {
  LoginLoadingCopyWith<$R, LoginLoading, $Out> get $asLoginLoading =>
      $base.as((v, t, t2) => _LoginLoadingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginLoadingCopyWith<$R, $In extends LoginLoading, $Out>
    implements LoginStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  LoginLoadingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginLoadingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginLoading, $Out>
    implements LoginLoadingCopyWith<$R, LoginLoading, $Out> {
  _LoginLoadingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginLoading> $mapper =
      LoginLoadingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  LoginLoading $make(CopyWithData data) => LoginLoading();

  @override
  LoginLoadingCopyWith<$R2, LoginLoading, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoginLoadingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LoginSuccessMapper extends SubClassMapperBase<LoginSuccess> {
  LoginSuccessMapper._();

  static LoginSuccessMapper? _instance;
  static LoginSuccessMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginSuccessMapper._());
      LoginStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'LoginSuccess';

  @override
  final MappableFields<LoginSuccess> fields = const {};

  @override
  final String discriminatorKey = 'status';
  @override
  final dynamic discriminatorValue = 'LoginSuccess';
  @override
  late final ClassMapperBase superMapper = LoginStateMapper.ensureInitialized();

  static LoginSuccess _instantiate(DecodingData data) {
    return LoginSuccess();
  }

  @override
  final Function instantiate = _instantiate;

  static LoginSuccess fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginSuccess>(map);
  }

  static LoginSuccess fromJson(String json) {
    return ensureInitialized().decodeJson<LoginSuccess>(json);
  }
}

mixin LoginSuccessMappable {
  String toJson() {
    return LoginSuccessMapper.ensureInitialized().encodeJson<LoginSuccess>(
      this as LoginSuccess,
    );
  }

  Map<String, dynamic> toMap() {
    return LoginSuccessMapper.ensureInitialized().encodeMap<LoginSuccess>(
      this as LoginSuccess,
    );
  }

  LoginSuccessCopyWith<LoginSuccess, LoginSuccess, LoginSuccess> get copyWith =>
      _LoginSuccessCopyWithImpl<LoginSuccess, LoginSuccess>(
        this as LoginSuccess,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LoginSuccessMapper.ensureInitialized().stringifyValue(
      this as LoginSuccess,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginSuccessMapper.ensureInitialized().equalsValue(
      this as LoginSuccess,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginSuccessMapper.ensureInitialized().hashValue(
      this as LoginSuccess,
    );
  }
}

extension LoginSuccessValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginSuccess, $Out> {
  LoginSuccessCopyWith<$R, LoginSuccess, $Out> get $asLoginSuccess =>
      $base.as((v, t, t2) => _LoginSuccessCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginSuccessCopyWith<$R, $In extends LoginSuccess, $Out>
    implements LoginStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  LoginSuccessCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginSuccessCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginSuccess, $Out>
    implements LoginSuccessCopyWith<$R, LoginSuccess, $Out> {
  _LoginSuccessCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginSuccess> $mapper =
      LoginSuccessMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  LoginSuccess $make(CopyWithData data) => LoginSuccess();

  @override
  LoginSuccessCopyWith<$R2, LoginSuccess, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoginSuccessCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LoginFailureMapper extends SubClassMapperBase<LoginFailure> {
  LoginFailureMapper._();

  static LoginFailureMapper? _instance;
  static LoginFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginFailureMapper._());
      LoginStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'LoginFailure';

  static String _$error(LoginFailure v) => v.error;
  static const Field<LoginFailure, String> _f$error = Field('error', _$error);

  @override
  final MappableFields<LoginFailure> fields = const {#error: _f$error};

  @override
  final String discriminatorKey = 'status';
  @override
  final dynamic discriminatorValue = 'LoginFailure';
  @override
  late final ClassMapperBase superMapper = LoginStateMapper.ensureInitialized();

  static LoginFailure _instantiate(DecodingData data) {
    return LoginFailure(data.dec(_f$error));
  }

  @override
  final Function instantiate = _instantiate;

  static LoginFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginFailure>(map);
  }

  static LoginFailure fromJson(String json) {
    return ensureInitialized().decodeJson<LoginFailure>(json);
  }
}

mixin LoginFailureMappable {
  String toJson() {
    return LoginFailureMapper.ensureInitialized().encodeJson<LoginFailure>(
      this as LoginFailure,
    );
  }

  Map<String, dynamic> toMap() {
    return LoginFailureMapper.ensureInitialized().encodeMap<LoginFailure>(
      this as LoginFailure,
    );
  }

  LoginFailureCopyWith<LoginFailure, LoginFailure, LoginFailure> get copyWith =>
      _LoginFailureCopyWithImpl<LoginFailure, LoginFailure>(
        this as LoginFailure,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LoginFailureMapper.ensureInitialized().stringifyValue(
      this as LoginFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginFailureMapper.ensureInitialized().equalsValue(
      this as LoginFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginFailureMapper.ensureInitialized().hashValue(
      this as LoginFailure,
    );
  }
}

extension LoginFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginFailure, $Out> {
  LoginFailureCopyWith<$R, LoginFailure, $Out> get $asLoginFailure =>
      $base.as((v, t, t2) => _LoginFailureCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginFailureCopyWith<$R, $In extends LoginFailure, $Out>
    implements LoginStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? error});
  LoginFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginFailure, $Out>
    implements LoginFailureCopyWith<$R, LoginFailure, $Out> {
  _LoginFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginFailure> $mapper =
      LoginFailureMapper.ensureInitialized();
  @override
  $R call({String? error}) =>
      $apply(FieldCopyWithData({if (error != null) #error: error}));
  @override
  LoginFailure $make(CopyWithData data) =>
      LoginFailure(data.get(#error, or: $value.error));

  @override
  LoginFailureCopyWith<$R2, LoginFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoginFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

