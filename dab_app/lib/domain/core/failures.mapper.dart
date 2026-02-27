// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'failures.dart';

class AppFailureMapper extends ClassMapperBase<AppFailure> {
  AppFailureMapper._();

  static AppFailureMapper? _instance;
  static AppFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppFailureMapper._());
      ServerFailureMapper.ensureInitialized();
      NetworkFailureMapper.ensureInitialized();
      AuthFailureMapper.ensureInitialized();
      ValidationFailureMapper.ensureInitialized();
      UnknownFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppFailure';

  static String _$message(AppFailure v) => v.message;
  static const Field<AppFailure, String> _f$message = Field(
    'message',
    _$message,
  );

  @override
  final MappableFields<AppFailure> fields = const {#message: _f$message};

  static AppFailure _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'AppFailure',
      'type',
      '${data.value['type']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppFailure>(map);
  }

  static AppFailure fromJson(String json) {
    return ensureInitialized().decodeJson<AppFailure>(json);
  }
}

mixin AppFailureMappable {
  String toJson();
  Map<String, dynamic> toMap();
  AppFailureCopyWith<AppFailure, AppFailure, AppFailure> get copyWith;
}

abstract class AppFailureCopyWith<$R, $In extends AppFailure, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  AppFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class ServerFailureMapper extends SubClassMapperBase<ServerFailure> {
  ServerFailureMapper._();

  static ServerFailureMapper? _instance;
  static ServerFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ServerFailureMapper._());
      AppFailureMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ServerFailure';

  static String _$message(ServerFailure v) => v.message;
  static const Field<ServerFailure, String> _f$message = Field(
    'message',
    _$message,
  );
  static int? _$statusCode(ServerFailure v) => v.statusCode;
  static const Field<ServerFailure, int> _f$statusCode = Field(
    'statusCode',
    _$statusCode,
    opt: true,
  );
  static String? _$errorCode(ServerFailure v) => v.errorCode;
  static const Field<ServerFailure, String> _f$errorCode = Field(
    'errorCode',
    _$errorCode,
    opt: true,
  );

  @override
  final MappableFields<ServerFailure> fields = const {
    #message: _f$message,
    #statusCode: _f$statusCode,
    #errorCode: _f$errorCode,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'ServerFailure';
  @override
  late final ClassMapperBase superMapper = AppFailureMapper.ensureInitialized();

  static ServerFailure _instantiate(DecodingData data) {
    return ServerFailure(
      message: data.dec(_f$message),
      statusCode: data.dec(_f$statusCode),
      errorCode: data.dec(_f$errorCode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ServerFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ServerFailure>(map);
  }

  static ServerFailure fromJson(String json) {
    return ensureInitialized().decodeJson<ServerFailure>(json);
  }
}

mixin ServerFailureMappable {
  String toJson() {
    return ServerFailureMapper.ensureInitialized().encodeJson<ServerFailure>(
      this as ServerFailure,
    );
  }

  Map<String, dynamic> toMap() {
    return ServerFailureMapper.ensureInitialized().encodeMap<ServerFailure>(
      this as ServerFailure,
    );
  }

  ServerFailureCopyWith<ServerFailure, ServerFailure, ServerFailure>
  get copyWith => _ServerFailureCopyWithImpl<ServerFailure, ServerFailure>(
    this as ServerFailure,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ServerFailureMapper.ensureInitialized().stringifyValue(
      this as ServerFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return ServerFailureMapper.ensureInitialized().equalsValue(
      this as ServerFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return ServerFailureMapper.ensureInitialized().hashValue(
      this as ServerFailure,
    );
  }
}

extension ServerFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ServerFailure, $Out> {
  ServerFailureCopyWith<$R, ServerFailure, $Out> get $asServerFailure =>
      $base.as((v, t, t2) => _ServerFailureCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ServerFailureCopyWith<$R, $In extends ServerFailure, $Out>
    implements AppFailureCopyWith<$R, $In, $Out> {
  @override
  $R call({String? message, int? statusCode, String? errorCode});
  ServerFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ServerFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ServerFailure, $Out>
    implements ServerFailureCopyWith<$R, ServerFailure, $Out> {
  _ServerFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ServerFailure> $mapper =
      ServerFailureMapper.ensureInitialized();
  @override
  $R call({
    String? message,
    Object? statusCode = $none,
    Object? errorCode = $none,
  }) => $apply(
    FieldCopyWithData({
      if (message != null) #message: message,
      if (statusCode != $none) #statusCode: statusCode,
      if (errorCode != $none) #errorCode: errorCode,
    }),
  );
  @override
  ServerFailure $make(CopyWithData data) => ServerFailure(
    message: data.get(#message, or: $value.message),
    statusCode: data.get(#statusCode, or: $value.statusCode),
    errorCode: data.get(#errorCode, or: $value.errorCode),
  );

  @override
  ServerFailureCopyWith<$R2, ServerFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ServerFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NetworkFailureMapper extends SubClassMapperBase<NetworkFailure> {
  NetworkFailureMapper._();

  static NetworkFailureMapper? _instance;
  static NetworkFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NetworkFailureMapper._());
      AppFailureMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NetworkFailure';

  static String? _$technicalMessage(NetworkFailure v) => v.technicalMessage;
  static const Field<NetworkFailure, String> _f$technicalMessage = Field(
    'technicalMessage',
    _$technicalMessage,
    opt: true,
  );
  static String _$message(NetworkFailure v) => v.message;
  static const Field<NetworkFailure, String> _f$message = Field(
    'message',
    _$message,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<NetworkFailure> fields = const {
    #technicalMessage: _f$technicalMessage,
    #message: _f$message,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'NetworkFailure';
  @override
  late final ClassMapperBase superMapper = AppFailureMapper.ensureInitialized();

  static NetworkFailure _instantiate(DecodingData data) {
    return NetworkFailure(technicalMessage: data.dec(_f$technicalMessage));
  }

  @override
  final Function instantiate = _instantiate;

  static NetworkFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NetworkFailure>(map);
  }

  static NetworkFailure fromJson(String json) {
    return ensureInitialized().decodeJson<NetworkFailure>(json);
  }
}

mixin NetworkFailureMappable {
  String toJson() {
    return NetworkFailureMapper.ensureInitialized().encodeJson<NetworkFailure>(
      this as NetworkFailure,
    );
  }

  Map<String, dynamic> toMap() {
    return NetworkFailureMapper.ensureInitialized().encodeMap<NetworkFailure>(
      this as NetworkFailure,
    );
  }

  NetworkFailureCopyWith<NetworkFailure, NetworkFailure, NetworkFailure>
  get copyWith => _NetworkFailureCopyWithImpl<NetworkFailure, NetworkFailure>(
    this as NetworkFailure,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return NetworkFailureMapper.ensureInitialized().stringifyValue(
      this as NetworkFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return NetworkFailureMapper.ensureInitialized().equalsValue(
      this as NetworkFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return NetworkFailureMapper.ensureInitialized().hashValue(
      this as NetworkFailure,
    );
  }
}

extension NetworkFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NetworkFailure, $Out> {
  NetworkFailureCopyWith<$R, NetworkFailure, $Out> get $asNetworkFailure =>
      $base.as((v, t, t2) => _NetworkFailureCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NetworkFailureCopyWith<$R, $In extends NetworkFailure, $Out>
    implements AppFailureCopyWith<$R, $In, $Out> {
  @override
  $R call({String? technicalMessage});
  NetworkFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NetworkFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NetworkFailure, $Out>
    implements NetworkFailureCopyWith<$R, NetworkFailure, $Out> {
  _NetworkFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NetworkFailure> $mapper =
      NetworkFailureMapper.ensureInitialized();
  @override
  $R call({Object? technicalMessage = $none}) => $apply(
    FieldCopyWithData({
      if (technicalMessage != $none) #technicalMessage: technicalMessage,
    }),
  );
  @override
  NetworkFailure $make(CopyWithData data) => NetworkFailure(
    technicalMessage: data.get(#technicalMessage, or: $value.technicalMessage),
  );

  @override
  NetworkFailureCopyWith<$R2, NetworkFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NetworkFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthFailureMapper extends SubClassMapperBase<AuthFailure> {
  AuthFailureMapper._();

  static AuthFailureMapper? _instance;
  static AuthFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthFailureMapper._());
      AppFailureMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'AuthFailure';

  static String _$message(AuthFailure v) => v.message;
  static const Field<AuthFailure, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
    def: 'Unauthorized',
  );

  @override
  final MappableFields<AuthFailure> fields = const {#message: _f$message};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'AuthFailure';
  @override
  late final ClassMapperBase superMapper = AppFailureMapper.ensureInitialized();

  static AuthFailure _instantiate(DecodingData data) {
    return AuthFailure(data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthFailure>(map);
  }

  static AuthFailure fromJson(String json) {
    return ensureInitialized().decodeJson<AuthFailure>(json);
  }
}

mixin AuthFailureMappable {
  String toJson() {
    return AuthFailureMapper.ensureInitialized().encodeJson<AuthFailure>(
      this as AuthFailure,
    );
  }

  Map<String, dynamic> toMap() {
    return AuthFailureMapper.ensureInitialized().encodeMap<AuthFailure>(
      this as AuthFailure,
    );
  }

  AuthFailureCopyWith<AuthFailure, AuthFailure, AuthFailure> get copyWith =>
      _AuthFailureCopyWithImpl<AuthFailure, AuthFailure>(
        this as AuthFailure,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthFailureMapper.ensureInitialized().stringifyValue(
      this as AuthFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthFailureMapper.ensureInitialized().equalsValue(
      this as AuthFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthFailureMapper.ensureInitialized().hashValue(this as AuthFailure);
  }
}

extension AuthFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthFailure, $Out> {
  AuthFailureCopyWith<$R, AuthFailure, $Out> get $asAuthFailure =>
      $base.as((v, t, t2) => _AuthFailureCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthFailureCopyWith<$R, $In extends AuthFailure, $Out>
    implements AppFailureCopyWith<$R, $In, $Out> {
  @override
  $R call({String? message});
  AuthFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthFailure, $Out>
    implements AuthFailureCopyWith<$R, AuthFailure, $Out> {
  _AuthFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthFailure> $mapper =
      AuthFailureMapper.ensureInitialized();
  @override
  $R call({String? message}) =>
      $apply(FieldCopyWithData({if (message != null) #message: message}));
  @override
  AuthFailure $make(CopyWithData data) =>
      AuthFailure(data.get(#message, or: $value.message));

  @override
  AuthFailureCopyWith<$R2, AuthFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ValidationFailureMapper extends SubClassMapperBase<ValidationFailure> {
  ValidationFailureMapper._();

  static ValidationFailureMapper? _instance;
  static ValidationFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ValidationFailureMapper._());
      AppFailureMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ValidationFailure';

  static Map<String, List<String>> _$errors(ValidationFailure v) => v.errors;
  static const Field<ValidationFailure, Map<String, List<String>>> _f$errors =
      Field('errors', _$errors);
  static String _$message(ValidationFailure v) => v.message;
  static const Field<ValidationFailure, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
    def: 'Validation failed',
  );

  @override
  final MappableFields<ValidationFailure> fields = const {
    #errors: _f$errors,
    #message: _f$message,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'ValidationFailure';
  @override
  late final ClassMapperBase superMapper = AppFailureMapper.ensureInitialized();

  static ValidationFailure _instantiate(DecodingData data) {
    return ValidationFailure(
      errors: data.dec(_f$errors),
      message: data.dec(_f$message),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ValidationFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ValidationFailure>(map);
  }

  static ValidationFailure fromJson(String json) {
    return ensureInitialized().decodeJson<ValidationFailure>(json);
  }
}

mixin ValidationFailureMappable {
  String toJson() {
    return ValidationFailureMapper.ensureInitialized()
        .encodeJson<ValidationFailure>(this as ValidationFailure);
  }

  Map<String, dynamic> toMap() {
    return ValidationFailureMapper.ensureInitialized()
        .encodeMap<ValidationFailure>(this as ValidationFailure);
  }

  ValidationFailureCopyWith<
    ValidationFailure,
    ValidationFailure,
    ValidationFailure
  >
  get copyWith =>
      _ValidationFailureCopyWithImpl<ValidationFailure, ValidationFailure>(
        this as ValidationFailure,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ValidationFailureMapper.ensureInitialized().stringifyValue(
      this as ValidationFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return ValidationFailureMapper.ensureInitialized().equalsValue(
      this as ValidationFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return ValidationFailureMapper.ensureInitialized().hashValue(
      this as ValidationFailure,
    );
  }
}

extension ValidationFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ValidationFailure, $Out> {
  ValidationFailureCopyWith<$R, ValidationFailure, $Out>
  get $asValidationFailure => $base.as(
    (v, t, t2) => _ValidationFailureCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ValidationFailureCopyWith<
  $R,
  $In extends ValidationFailure,
  $Out
>
    implements AppFailureCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    String,
    List<String>,
    ObjectCopyWith<$R, List<String>, List<String>>
  >
  get errors;
  @override
  $R call({Map<String, List<String>>? errors, String? message});
  ValidationFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ValidationFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ValidationFailure, $Out>
    implements ValidationFailureCopyWith<$R, ValidationFailure, $Out> {
  _ValidationFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ValidationFailure> $mapper =
      ValidationFailureMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    String,
    List<String>,
    ObjectCopyWith<$R, List<String>, List<String>>
  >
  get errors => MapCopyWith(
    $value.errors,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(errors: v),
  );
  @override
  $R call({Map<String, List<String>>? errors, String? message}) => $apply(
    FieldCopyWithData({
      if (errors != null) #errors: errors,
      if (message != null) #message: message,
    }),
  );
  @override
  ValidationFailure $make(CopyWithData data) => ValidationFailure(
    errors: data.get(#errors, or: $value.errors),
    message: data.get(#message, or: $value.message),
  );

  @override
  ValidationFailureCopyWith<$R2, ValidationFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ValidationFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UnknownFailureMapper extends SubClassMapperBase<UnknownFailure> {
  UnknownFailureMapper._();

  static UnknownFailureMapper? _instance;
  static UnknownFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UnknownFailureMapper._());
      AppFailureMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'UnknownFailure';

  static dynamic _$originalError(UnknownFailure v) => v.originalError;
  static const Field<UnknownFailure, dynamic> _f$originalError = Field(
    'originalError',
    _$originalError,
    opt: true,
  );
  static String _$message(UnknownFailure v) => v.message;
  static const Field<UnknownFailure, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
    def: 'An unexpected error occurred',
  );

  @override
  final MappableFields<UnknownFailure> fields = const {
    #originalError: _f$originalError,
    #message: _f$message,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'UnknownFailure';
  @override
  late final ClassMapperBase superMapper = AppFailureMapper.ensureInitialized();

  static UnknownFailure _instantiate(DecodingData data) {
    return UnknownFailure(
      originalError: data.dec(_f$originalError),
      message: data.dec(_f$message),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UnknownFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UnknownFailure>(map);
  }

  static UnknownFailure fromJson(String json) {
    return ensureInitialized().decodeJson<UnknownFailure>(json);
  }
}

mixin UnknownFailureMappable {
  String toJson() {
    return UnknownFailureMapper.ensureInitialized().encodeJson<UnknownFailure>(
      this as UnknownFailure,
    );
  }

  Map<String, dynamic> toMap() {
    return UnknownFailureMapper.ensureInitialized().encodeMap<UnknownFailure>(
      this as UnknownFailure,
    );
  }

  UnknownFailureCopyWith<UnknownFailure, UnknownFailure, UnknownFailure>
  get copyWith => _UnknownFailureCopyWithImpl<UnknownFailure, UnknownFailure>(
    this as UnknownFailure,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UnknownFailureMapper.ensureInitialized().stringifyValue(
      this as UnknownFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return UnknownFailureMapper.ensureInitialized().equalsValue(
      this as UnknownFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return UnknownFailureMapper.ensureInitialized().hashValue(
      this as UnknownFailure,
    );
  }
}

extension UnknownFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UnknownFailure, $Out> {
  UnknownFailureCopyWith<$R, UnknownFailure, $Out> get $asUnknownFailure =>
      $base.as((v, t, t2) => _UnknownFailureCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UnknownFailureCopyWith<$R, $In extends UnknownFailure, $Out>
    implements AppFailureCopyWith<$R, $In, $Out> {
  @override
  $R call({dynamic originalError, String? message});
  UnknownFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UnknownFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UnknownFailure, $Out>
    implements UnknownFailureCopyWith<$R, UnknownFailure, $Out> {
  _UnknownFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UnknownFailure> $mapper =
      UnknownFailureMapper.ensureInitialized();
  @override
  $R call({Object? originalError = $none, String? message}) => $apply(
    FieldCopyWithData({
      if (originalError != $none) #originalError: originalError,
      if (message != null) #message: message,
    }),
  );
  @override
  UnknownFailure $make(CopyWithData data) => UnknownFailure(
    originalError: data.get(#originalError, or: $value.originalError),
    message: data.get(#message, or: $value.message),
  );

  @override
  UnknownFailureCopyWith<$R2, UnknownFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UnknownFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

