// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_identity.dart';

class UserIdentityMapper extends ClassMapperBase<UserIdentity> {
  UserIdentityMapper._();

  static UserIdentityMapper? _instance;
  static UserIdentityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserIdentityMapper._());
      UserIdentityStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserIdentity';

  static String _$id(UserIdentity v) => v.id;
  static const Field<UserIdentity, String> _f$id = Field('id', _$id);
  static String _$userId(UserIdentity v) => v.userId;
  static const Field<UserIdentity, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$providerId(UserIdentity v) => v.providerId;
  static const Field<UserIdentity, String> _f$providerId = Field(
    'providerId',
    _$providerId,
  );
  static String _$externalId(UserIdentity v) => v.externalId;
  static const Field<UserIdentity, String> _f$externalId = Field(
    'externalId',
    _$externalId,
  );
  static UserIdentityStatus _$status(UserIdentity v) => v.status;
  static const Field<UserIdentity, UserIdentityStatus> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime _$createdAt(UserIdentity v) => v.createdAt;
  static const Field<UserIdentity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime? _$updatedAt(UserIdentity v) => v.updatedAt;
  static const Field<UserIdentity, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
  );

  @override
  final MappableFields<UserIdentity> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #providerId: _f$providerId,
    #externalId: _f$externalId,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static UserIdentity _instantiate(DecodingData data) {
    return UserIdentity(
      id: data.dec(_f$id),
      userId: data.dec(_f$userId),
      providerId: data.dec(_f$providerId),
      externalId: data.dec(_f$externalId),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserIdentity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserIdentity>(map);
  }

  static UserIdentity fromJson(String json) {
    return ensureInitialized().decodeJson<UserIdentity>(json);
  }
}

mixin UserIdentityMappable {
  String toJson() {
    return UserIdentityMapper.ensureInitialized().encodeJson<UserIdentity>(
      this as UserIdentity,
    );
  }

  Map<String, dynamic> toMap() {
    return UserIdentityMapper.ensureInitialized().encodeMap<UserIdentity>(
      this as UserIdentity,
    );
  }

  UserIdentityCopyWith<UserIdentity, UserIdentity, UserIdentity> get copyWith =>
      _UserIdentityCopyWithImpl<UserIdentity, UserIdentity>(
        this as UserIdentity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserIdentityMapper.ensureInitialized().stringifyValue(
      this as UserIdentity,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserIdentityMapper.ensureInitialized().equalsValue(
      this as UserIdentity,
      other,
    );
  }

  @override
  int get hashCode {
    return UserIdentityMapper.ensureInitialized().hashValue(
      this as UserIdentity,
    );
  }
}

extension UserIdentityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserIdentity, $Out> {
  UserIdentityCopyWith<$R, UserIdentity, $Out> get $asUserIdentity =>
      $base.as((v, t, t2) => _UserIdentityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserIdentityCopyWith<$R, $In extends UserIdentity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? userId,
    String? providerId,
    String? externalId,
    UserIdentityStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  UserIdentityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserIdentityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserIdentity, $Out>
    implements UserIdentityCopyWith<$R, UserIdentity, $Out> {
  _UserIdentityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserIdentity> $mapper =
      UserIdentityMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? userId,
    String? providerId,
    String? externalId,
    UserIdentityStatus? status,
    DateTime? createdAt,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (userId != null) #userId: userId,
      if (providerId != null) #providerId: providerId,
      if (externalId != null) #externalId: externalId,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  UserIdentity $make(CopyWithData data) => UserIdentity(
    id: data.get(#id, or: $value.id),
    userId: data.get(#userId, or: $value.userId),
    providerId: data.get(#providerId, or: $value.providerId),
    externalId: data.get(#externalId, or: $value.externalId),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  UserIdentityCopyWith<$R2, UserIdentity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserIdentityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

