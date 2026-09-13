// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_provider_credential_summary.dart';

class UserProviderCredentialSummaryMapper
    extends ClassMapperBase<UserProviderCredentialSummary> {
  UserProviderCredentialSummaryMapper._();

  static UserProviderCredentialSummaryMapper? _instance;
  static UserProviderCredentialSummaryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = UserProviderCredentialSummaryMapper._(),
      );
      UserProviderCredentialStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserProviderCredentialSummary';

  static String _$providerId(UserProviderCredentialSummary v) => v.providerId;
  static const Field<UserProviderCredentialSummary, String> _f$providerId =
      Field('providerId', _$providerId);
  static UserProviderCredentialStatus _$status(
    UserProviderCredentialSummary v,
  ) => v.status;
  static const Field<
    UserProviderCredentialSummary,
    UserProviderCredentialStatus
  >
  _f$status = Field('status', _$status);
  static bool _$hasSecret(UserProviderCredentialSummary v) => v.hasSecret;
  static const Field<UserProviderCredentialSummary, bool> _f$hasSecret = Field(
    'hasSecret',
    _$hasSecret,
  );
  static bool _$isSharedBot(UserProviderCredentialSummary v) => v.isSharedBot;
  static const Field<UserProviderCredentialSummary, bool> _f$isSharedBot =
      Field('isSharedBot', _$isSharedBot, opt: true, def: false);
  static String? _$externalId(UserProviderCredentialSummary v) => v.externalId;
  static const Field<UserProviderCredentialSummary, String> _f$externalId =
      Field('externalId', _$externalId, opt: true);
  static String? _$externalUsername(UserProviderCredentialSummary v) =>
      v.externalUsername;
  static const Field<UserProviderCredentialSummary, String>
  _f$externalUsername = Field(
    'externalUsername',
    _$externalUsername,
    opt: true,
  );
  static DateTime? _$updatedAt(UserProviderCredentialSummary v) => v.updatedAt;
  static const Field<UserProviderCredentialSummary, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, opt: true);

  @override
  final MappableFields<UserProviderCredentialSummary> fields = const {
    #providerId: _f$providerId,
    #status: _f$status,
    #hasSecret: _f$hasSecret,
    #isSharedBot: _f$isSharedBot,
    #externalId: _f$externalId,
    #externalUsername: _f$externalUsername,
    #updatedAt: _f$updatedAt,
  };

  static UserProviderCredentialSummary _instantiate(DecodingData data) {
    return UserProviderCredentialSummary(
      providerId: data.dec(_f$providerId),
      status: data.dec(_f$status),
      hasSecret: data.dec(_f$hasSecret),
      isSharedBot: data.dec(_f$isSharedBot),
      externalId: data.dec(_f$externalId),
      externalUsername: data.dec(_f$externalUsername),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserProviderCredentialSummary fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserProviderCredentialSummary>(map);
  }

  static UserProviderCredentialSummary fromJson(String json) {
    return ensureInitialized().decodeJson<UserProviderCredentialSummary>(json);
  }
}

mixin UserProviderCredentialSummaryMappable {
  String toJson() {
    return UserProviderCredentialSummaryMapper.ensureInitialized()
        .encodeJson<UserProviderCredentialSummary>(
          this as UserProviderCredentialSummary,
        );
  }

  Map<String, dynamic> toMap() {
    return UserProviderCredentialSummaryMapper.ensureInitialized()
        .encodeMap<UserProviderCredentialSummary>(
          this as UserProviderCredentialSummary,
        );
  }

  UserProviderCredentialSummaryCopyWith<
    UserProviderCredentialSummary,
    UserProviderCredentialSummary,
    UserProviderCredentialSummary
  >
  get copyWith =>
      _UserProviderCredentialSummaryCopyWithImpl<
        UserProviderCredentialSummary,
        UserProviderCredentialSummary
      >(this as UserProviderCredentialSummary, $identity, $identity);
  @override
  String toString() {
    return UserProviderCredentialSummaryMapper.ensureInitialized()
        .stringifyValue(this as UserProviderCredentialSummary);
  }

  @override
  bool operator ==(Object other) {
    return UserProviderCredentialSummaryMapper.ensureInitialized().equalsValue(
      this as UserProviderCredentialSummary,
      other,
    );
  }

  @override
  int get hashCode {
    return UserProviderCredentialSummaryMapper.ensureInitialized().hashValue(
      this as UserProviderCredentialSummary,
    );
  }
}

extension UserProviderCredentialSummaryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserProviderCredentialSummary, $Out> {
  UserProviderCredentialSummaryCopyWith<$R, UserProviderCredentialSummary, $Out>
  get $asUserProviderCredentialSummary => $base.as(
    (v, t, t2) =>
        _UserProviderCredentialSummaryCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UserProviderCredentialSummaryCopyWith<
  $R,
  $In extends UserProviderCredentialSummary,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? providerId,
    UserProviderCredentialStatus? status,
    bool? hasSecret,
    bool? isSharedBot,
    String? externalId,
    String? externalUsername,
    DateTime? updatedAt,
  });
  UserProviderCredentialSummaryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserProviderCredentialSummaryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserProviderCredentialSummary, $Out>
    implements
        UserProviderCredentialSummaryCopyWith<
          $R,
          UserProviderCredentialSummary,
          $Out
        > {
  _UserProviderCredentialSummaryCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<UserProviderCredentialSummary> $mapper =
      UserProviderCredentialSummaryMapper.ensureInitialized();
  @override
  $R call({
    String? providerId,
    UserProviderCredentialStatus? status,
    bool? hasSecret,
    bool? isSharedBot,
    Object? externalId = $none,
    Object? externalUsername = $none,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (providerId != null) #providerId: providerId,
      if (status != null) #status: status,
      if (hasSecret != null) #hasSecret: hasSecret,
      if (isSharedBot != null) #isSharedBot: isSharedBot,
      if (externalId != $none) #externalId: externalId,
      if (externalUsername != $none) #externalUsername: externalUsername,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  UserProviderCredentialSummary $make(CopyWithData data) =>
      UserProviderCredentialSummary(
        providerId: data.get(#providerId, or: $value.providerId),
        status: data.get(#status, or: $value.status),
        hasSecret: data.get(#hasSecret, or: $value.hasSecret),
        isSharedBot: data.get(#isSharedBot, or: $value.isSharedBot),
        externalId: data.get(#externalId, or: $value.externalId),
        externalUsername: data.get(
          #externalUsername,
          or: $value.externalUsername,
        ),
        updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      );

  @override
  UserProviderCredentialSummaryCopyWith<
    $R2,
    UserProviderCredentialSummary,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserProviderCredentialSummaryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

