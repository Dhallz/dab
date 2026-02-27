// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'login_event.dart';

class LoginEventMapper extends ClassMapperBase<LoginEvent> {
  LoginEventMapper._();

  static LoginEventMapper? _instance;
  static LoginEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginEventMapper._());
      LoginSubmittedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LoginEvent';

  @override
  final MappableFields<LoginEvent> fields = const {};

  static LoginEvent _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'LoginEvent',
      'type',
      '${data.value['type']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoginEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginEvent>(map);
  }

  static LoginEvent fromJson(String json) {
    return ensureInitialized().decodeJson<LoginEvent>(json);
  }
}

mixin LoginEventMappable {
  String toJson();
  Map<String, dynamic> toMap();
  LoginEventCopyWith<LoginEvent, LoginEvent, LoginEvent> get copyWith;
}

abstract class LoginEventCopyWith<$R, $In extends LoginEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  LoginEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class LoginSubmittedMapper extends SubClassMapperBase<LoginSubmitted> {
  LoginSubmittedMapper._();

  static LoginSubmittedMapper? _instance;
  static LoginSubmittedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginSubmittedMapper._());
      LoginEventMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'LoginSubmitted';

  static String _$email(LoginSubmitted v) => v.email;
  static const Field<LoginSubmitted, String> _f$email = Field('email', _$email);
  static String _$password(LoginSubmitted v) => v.password;
  static const Field<LoginSubmitted, String> _f$password = Field(
    'password',
    _$password,
  );

  @override
  final MappableFields<LoginSubmitted> fields = const {
    #email: _f$email,
    #password: _f$password,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'LoginSubmitted';
  @override
  late final ClassMapperBase superMapper = LoginEventMapper.ensureInitialized();

  static LoginSubmitted _instantiate(DecodingData data) {
    return LoginSubmitted(
      email: data.dec(_f$email),
      password: data.dec(_f$password),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoginSubmitted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginSubmitted>(map);
  }

  static LoginSubmitted fromJson(String json) {
    return ensureInitialized().decodeJson<LoginSubmitted>(json);
  }
}

mixin LoginSubmittedMappable {
  String toJson() {
    return LoginSubmittedMapper.ensureInitialized().encodeJson<LoginSubmitted>(
      this as LoginSubmitted,
    );
  }

  Map<String, dynamic> toMap() {
    return LoginSubmittedMapper.ensureInitialized().encodeMap<LoginSubmitted>(
      this as LoginSubmitted,
    );
  }

  LoginSubmittedCopyWith<LoginSubmitted, LoginSubmitted, LoginSubmitted>
  get copyWith => _LoginSubmittedCopyWithImpl<LoginSubmitted, LoginSubmitted>(
    this as LoginSubmitted,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return LoginSubmittedMapper.ensureInitialized().stringifyValue(
      this as LoginSubmitted,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginSubmittedMapper.ensureInitialized().equalsValue(
      this as LoginSubmitted,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginSubmittedMapper.ensureInitialized().hashValue(
      this as LoginSubmitted,
    );
  }
}

extension LoginSubmittedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginSubmitted, $Out> {
  LoginSubmittedCopyWith<$R, LoginSubmitted, $Out> get $asLoginSubmitted =>
      $base.as((v, t, t2) => _LoginSubmittedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginSubmittedCopyWith<$R, $In extends LoginSubmitted, $Out>
    implements LoginEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? email, String? password});
  LoginSubmittedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LoginSubmittedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginSubmitted, $Out>
    implements LoginSubmittedCopyWith<$R, LoginSubmitted, $Out> {
  _LoginSubmittedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginSubmitted> $mapper =
      LoginSubmittedMapper.ensureInitialized();
  @override
  $R call({String? email, String? password}) => $apply(
    FieldCopyWithData({
      if (email != null) #email: email,
      if (password != null) #password: password,
    }),
  );
  @override
  LoginSubmitted $make(CopyWithData data) => LoginSubmitted(
    email: data.get(#email, or: $value.email),
    password: data.get(#password, or: $value.password),
  );

  @override
  LoginSubmittedCopyWith<$R2, LoginSubmitted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoginSubmittedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

