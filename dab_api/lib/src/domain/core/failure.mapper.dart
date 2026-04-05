// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'failure.dart';

class FailureMapper extends ClassMapperBase<Failure> {
  FailureMapper._();

  static FailureMapper? _instance;
  static FailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FailureMapper._());
      DatabaseFailureMapper.ensureInitialized();
      AuthFailureMapper.ensureInitialized();
      NotFoundFailureMapper.ensureInitialized();
      ValidationFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Failure';

  static String _$message(Failure v) => v.message;
  static const Field<Failure, String> _f$message = Field('message', _$message);

  @override
  final MappableFields<Failure> fields = const {#message: _f$message};

  static Failure _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('Failure');
  }

  @override
  final Function instantiate = _instantiate;

  static Failure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Failure>(map);
  }

  static Failure fromJson(String json) {
    return ensureInitialized().decodeJson<Failure>(json);
  }
}

mixin FailureMappable {
  String toJson();
  Map<String, dynamic> toMap();
  FailureCopyWith<Failure, Failure, Failure> get copyWith;
}

abstract class FailureCopyWith<$R, $In extends Failure, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? message});
  FailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class DatabaseFailureMapper extends ClassMapperBase<DatabaseFailure> {
  DatabaseFailureMapper._();

  static DatabaseFailureMapper? _instance;
  static DatabaseFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DatabaseFailureMapper._());
      FailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DatabaseFailure';

  static String _$message(DatabaseFailure v) => v.message;
  static const Field<DatabaseFailure, String> _f$message = Field(
    'message',
    _$message,
  );

  @override
  final MappableFields<DatabaseFailure> fields = const {#message: _f$message};

  static DatabaseFailure _instantiate(DecodingData data) {
    return DatabaseFailure(data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static DatabaseFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DatabaseFailure>(map);
  }

  static DatabaseFailure fromJson(String json) {
    return ensureInitialized().decodeJson<DatabaseFailure>(json);
  }
}

mixin DatabaseFailureMappable {
  String toJson() {
    return DatabaseFailureMapper.ensureInitialized()
        .encodeJson<DatabaseFailure>(this as DatabaseFailure);
  }

  Map<String, dynamic> toMap() {
    return DatabaseFailureMapper.ensureInitialized().encodeMap<DatabaseFailure>(
      this as DatabaseFailure,
    );
  }

  DatabaseFailureCopyWith<DatabaseFailure, DatabaseFailure, DatabaseFailure>
  get copyWith =>
      _DatabaseFailureCopyWithImpl<DatabaseFailure, DatabaseFailure>(
        this as DatabaseFailure,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DatabaseFailureMapper.ensureInitialized().stringifyValue(
      this as DatabaseFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return DatabaseFailureMapper.ensureInitialized().equalsValue(
      this as DatabaseFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return DatabaseFailureMapper.ensureInitialized().hashValue(
      this as DatabaseFailure,
    );
  }
}

extension DatabaseFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DatabaseFailure, $Out> {
  DatabaseFailureCopyWith<$R, DatabaseFailure, $Out> get $asDatabaseFailure =>
      $base.as((v, t, t2) => _DatabaseFailureCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DatabaseFailureCopyWith<$R, $In extends DatabaseFailure, $Out>
    implements FailureCopyWith<$R, $In, $Out> {
  @override
  $R call({String? message});
  DatabaseFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DatabaseFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DatabaseFailure, $Out>
    implements DatabaseFailureCopyWith<$R, DatabaseFailure, $Out> {
  _DatabaseFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DatabaseFailure> $mapper =
      DatabaseFailureMapper.ensureInitialized();
  @override
  $R call({String? message}) =>
      $apply(FieldCopyWithData({if (message != null) #message: message}));
  @override
  DatabaseFailure $make(CopyWithData data) =>
      DatabaseFailure(data.get(#message, or: $value.message));

  @override
  DatabaseFailureCopyWith<$R2, DatabaseFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DatabaseFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthFailureMapper extends ClassMapperBase<AuthFailure> {
  AuthFailureMapper._();

  static AuthFailureMapper? _instance;
  static AuthFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthFailureMapper._());
      FailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthFailure';

  static String _$message(AuthFailure v) => v.message;
  static const Field<AuthFailure, String> _f$message = Field(
    'message',
    _$message,
  );

  @override
  final MappableFields<AuthFailure> fields = const {#message: _f$message};

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
    implements FailureCopyWith<$R, $In, $Out> {
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

class NotFoundFailureMapper extends ClassMapperBase<NotFoundFailure> {
  NotFoundFailureMapper._();

  static NotFoundFailureMapper? _instance;
  static NotFoundFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotFoundFailureMapper._());
      FailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotFoundFailure';

  static String _$message(NotFoundFailure v) => v.message;
  static const Field<NotFoundFailure, String> _f$message = Field(
    'message',
    _$message,
  );

  @override
  final MappableFields<NotFoundFailure> fields = const {#message: _f$message};

  static NotFoundFailure _instantiate(DecodingData data) {
    return NotFoundFailure(data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static NotFoundFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotFoundFailure>(map);
  }

  static NotFoundFailure fromJson(String json) {
    return ensureInitialized().decodeJson<NotFoundFailure>(json);
  }
}

mixin NotFoundFailureMappable {
  String toJson() {
    return NotFoundFailureMapper.ensureInitialized()
        .encodeJson<NotFoundFailure>(this as NotFoundFailure);
  }

  Map<String, dynamic> toMap() {
    return NotFoundFailureMapper.ensureInitialized().encodeMap<NotFoundFailure>(
      this as NotFoundFailure,
    );
  }

  NotFoundFailureCopyWith<NotFoundFailure, NotFoundFailure, NotFoundFailure>
  get copyWith =>
      _NotFoundFailureCopyWithImpl<NotFoundFailure, NotFoundFailure>(
        this as NotFoundFailure,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NotFoundFailureMapper.ensureInitialized().stringifyValue(
      this as NotFoundFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotFoundFailureMapper.ensureInitialized().equalsValue(
      this as NotFoundFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return NotFoundFailureMapper.ensureInitialized().hashValue(
      this as NotFoundFailure,
    );
  }
}

extension NotFoundFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotFoundFailure, $Out> {
  NotFoundFailureCopyWith<$R, NotFoundFailure, $Out> get $asNotFoundFailure =>
      $base.as((v, t, t2) => _NotFoundFailureCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotFoundFailureCopyWith<$R, $In extends NotFoundFailure, $Out>
    implements FailureCopyWith<$R, $In, $Out> {
  @override
  $R call({String? message});
  NotFoundFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NotFoundFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotFoundFailure, $Out>
    implements NotFoundFailureCopyWith<$R, NotFoundFailure, $Out> {
  _NotFoundFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotFoundFailure> $mapper =
      NotFoundFailureMapper.ensureInitialized();
  @override
  $R call({String? message}) =>
      $apply(FieldCopyWithData({if (message != null) #message: message}));
  @override
  NotFoundFailure $make(CopyWithData data) =>
      NotFoundFailure(data.get(#message, or: $value.message));

  @override
  NotFoundFailureCopyWith<$R2, NotFoundFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NotFoundFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ValidationFailureMapper extends ClassMapperBase<ValidationFailure> {
  ValidationFailureMapper._();

  static ValidationFailureMapper? _instance;
  static ValidationFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ValidationFailureMapper._());
      FailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ValidationFailure';

  static String _$message(ValidationFailure v) => v.message;
  static const Field<ValidationFailure, String> _f$message = Field(
    'message',
    _$message,
  );

  @override
  final MappableFields<ValidationFailure> fields = const {#message: _f$message};

  static ValidationFailure _instantiate(DecodingData data) {
    return ValidationFailure(data.dec(_f$message));
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
    implements FailureCopyWith<$R, $In, $Out> {
  @override
  $R call({String? message});
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
  $R call({String? message}) =>
      $apply(FieldCopyWithData({if (message != null) #message: message}));
  @override
  ValidationFailure $make(CopyWithData data) =>
      ValidationFailure(data.get(#message, or: $value.message));

  @override
  ValidationFailureCopyWith<$R2, ValidationFailure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ValidationFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

