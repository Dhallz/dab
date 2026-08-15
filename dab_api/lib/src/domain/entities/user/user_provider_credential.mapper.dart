// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_provider_credential.dart';

class UserProviderCredentialMapper
    extends ClassMapperBase<UserProviderCredential> {
  UserProviderCredentialMapper._();

  static UserProviderCredentialMapper? _instance;
  static UserProviderCredentialMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserProviderCredentialMapper._());
      UserProviderCredentialStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserProviderCredential';

  static String _$id(UserProviderCredential v) => v.id;
  static const Field<UserProviderCredential, String> _f$id = Field('id', _$id);
  static String _$userId(UserProviderCredential v) => v.userId;
  static const Field<UserProviderCredential, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$providerId(UserProviderCredential v) => v.providerId;
  static const Field<UserProviderCredential, String> _f$providerId = Field(
    'providerId',
    _$providerId,
  );
  static Map<String, dynamic> _$settings(UserProviderCredential v) =>
      v.settings;
  static const Field<UserProviderCredential, Map<String, dynamic>> _f$settings =
      Field('settings', _$settings, opt: true, def: const {});
  static UserProviderCredentialStatus _$status(UserProviderCredential v) =>
      v.status;
  static const Field<UserProviderCredential, UserProviderCredentialStatus>
  _f$status = Field('status', _$status);
  static DateTime _$createdAt(UserProviderCredential v) => v.createdAt;
  static const Field<UserProviderCredential, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime? _$updatedAt(UserProviderCredential v) => v.updatedAt;
  static const Field<UserProviderCredential, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
  );

  @override
  final MappableFields<UserProviderCredential> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #providerId: _f$providerId,
    #settings: _f$settings,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static UserProviderCredential _instantiate(DecodingData data) {
    return UserProviderCredential(
      id: data.dec(_f$id),
      userId: data.dec(_f$userId),
      providerId: data.dec(_f$providerId),
      settings: data.dec(_f$settings),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserProviderCredential fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserProviderCredential>(map);
  }

  static UserProviderCredential fromJson(String json) {
    return ensureInitialized().decodeJson<UserProviderCredential>(json);
  }
}

mixin UserProviderCredentialMappable {
  String toJson() {
    return UserProviderCredentialMapper.ensureInitialized()
        .encodeJson<UserProviderCredential>(this as UserProviderCredential);
  }

  Map<String, dynamic> toMap() {
    return UserProviderCredentialMapper.ensureInitialized()
        .encodeMap<UserProviderCredential>(this as UserProviderCredential);
  }

  UserProviderCredentialCopyWith<
    UserProviderCredential,
    UserProviderCredential,
    UserProviderCredential
  >
  get copyWith =>
      _UserProviderCredentialCopyWithImpl<
        UserProviderCredential,
        UserProviderCredential
      >(this as UserProviderCredential, $identity, $identity);
  @override
  String toString() {
    return UserProviderCredentialMapper.ensureInitialized().stringifyValue(
      this as UserProviderCredential,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserProviderCredentialMapper.ensureInitialized().equalsValue(
      this as UserProviderCredential,
      other,
    );
  }

  @override
  int get hashCode {
    return UserProviderCredentialMapper.ensureInitialized().hashValue(
      this as UserProviderCredential,
    );
  }
}

extension UserProviderCredentialValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserProviderCredential, $Out> {
  UserProviderCredentialCopyWith<$R, UserProviderCredential, $Out>
  get $asUserProviderCredential => $base.as(
    (v, t, t2) => _UserProviderCredentialCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UserProviderCredentialCopyWith<
  $R,
  $In extends UserProviderCredential,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get settings;
  $R call({
    String? id,
    String? userId,
    String? providerId,
    Map<String, dynamic>? settings,
    UserProviderCredentialStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  UserProviderCredentialCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserProviderCredentialCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserProviderCredential, $Out>
    implements
        UserProviderCredentialCopyWith<$R, UserProviderCredential, $Out> {
  _UserProviderCredentialCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserProviderCredential> $mapper =
      UserProviderCredentialMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get settings => MapCopyWith(
    $value.settings,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(settings: v),
  );
  @override
  $R call({
    String? id,
    String? userId,
    String? providerId,
    Map<String, dynamic>? settings,
    UserProviderCredentialStatus? status,
    DateTime? createdAt,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (userId != null) #userId: userId,
      if (providerId != null) #providerId: providerId,
      if (settings != null) #settings: settings,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  UserProviderCredential $make(CopyWithData data) => UserProviderCredential(
    id: data.get(#id, or: $value.id),
    userId: data.get(#userId, or: $value.userId),
    providerId: data.get(#providerId, or: $value.providerId),
    settings: data.get(#settings, or: $value.settings),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  UserProviderCredentialCopyWith<$R2, UserProviderCredential, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserProviderCredentialCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

