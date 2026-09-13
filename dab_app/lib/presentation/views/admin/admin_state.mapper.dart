// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'admin_state.dart';

class AdminStateMapper extends ClassMapperBase<AdminState> {
  AdminStateMapper._();

  static AdminStateMapper? _instance;
  static AdminStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminStateMapper._());
      ViewStatusMapper.ensureInitialized();
      AdminSectionMapper.ensureInitialized();
      ProviderConfigMapper.ensureInitialized();
      UserIdentityMapper.ensureInitialized();
      UserMapper.ensureInitialized();
      ProviderConnectionStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminState';

  static ViewStatus _$status(AdminState v) => v.status;
  static const Field<AdminState, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static AdminSection _$selectedSection(AdminState v) => v.selectedSection;
  static const Field<AdminState, AdminSection> _f$selectedSection = Field(
    'selectedSection',
    _$selectedSection,
    opt: true,
    def: AdminSection.providers,
  );
  static List<ProviderConfig> _$configs(AdminState v) => v.configs;
  static const Field<AdminState, List<ProviderConfig>> _f$configs = Field(
    'configs',
    _$configs,
    opt: true,
    def: const [],
  );
  static List<UserIdentity> _$identities(AdminState v) => v.identities;
  static const Field<AdminState, List<UserIdentity>> _f$identities = Field(
    'identities',
    _$identities,
    opt: true,
    def: const [],
  );
  static List<User> _$users(AdminState v) => v.users;
  static const Field<AdminState, List<User>> _f$users = Field(
    'users',
    _$users,
    opt: true,
    def: const [],
  );
  static String _$identitySearchQuery(AdminState v) => v.identitySearchQuery;
  static const Field<AdminState, String> _f$identitySearchQuery = Field(
    'identitySearchQuery',
    _$identitySearchQuery,
    opt: true,
    def: '',
  );
  static IdentitySortField _$identitySortField(AdminState v) =>
      v.identitySortField;
  static const Field<AdminState, IdentitySortField> _f$identitySortField =
      Field(
        'identitySortField',
        _$identitySortField,
        opt: true,
        def: IdentitySortField.fullName,
      );
  static bool _$identitySortAscending(AdminState v) => v.identitySortAscending;
  static const Field<AdminState, bool> _f$identitySortAscending = Field(
    'identitySortAscending',
    _$identitySortAscending,
    opt: true,
    def: true,
  );
  static Map<String, ProviderConnectionStatus> _$connectionStatuses(
    AdminState v,
  ) => v.connectionStatuses;
  static const Field<AdminState, Map<String, ProviderConnectionStatus>>
  _f$connectionStatuses = Field(
    'connectionStatuses',
    _$connectionStatuses,
    opt: true,
    def: const {},
  );
  static Map<String, String> _$systemSettings(AdminState v) => v.systemSettings;
  static const Field<AdminState, Map<String, String>> _f$systemSettings = Field(
    'systemSettings',
    _$systemSettings,
    opt: true,
    def: const {},
  );
  static String? _$errorMessage(AdminState v) => v.errorMessage;
  static const Field<AdminState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );

  @override
  final MappableFields<AdminState> fields = const {
    #status: _f$status,
    #selectedSection: _f$selectedSection,
    #configs: _f$configs,
    #identities: _f$identities,
    #users: _f$users,
    #identitySearchQuery: _f$identitySearchQuery,
    #identitySortField: _f$identitySortField,
    #identitySortAscending: _f$identitySortAscending,
    #connectionStatuses: _f$connectionStatuses,
    #systemSettings: _f$systemSettings,
    #errorMessage: _f$errorMessage,
  };

  static AdminState _instantiate(DecodingData data) {
    return AdminState(
      status: data.dec(_f$status),
      selectedSection: data.dec(_f$selectedSection),
      configs: data.dec(_f$configs),
      identities: data.dec(_f$identities),
      users: data.dec(_f$users),
      identitySearchQuery: data.dec(_f$identitySearchQuery),
      identitySortField: data.dec(_f$identitySortField),
      identitySortAscending: data.dec(_f$identitySortAscending),
      connectionStatuses: data.dec(_f$connectionStatuses),
      systemSettings: data.dec(_f$systemSettings),
      errorMessage: data.dec(_f$errorMessage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminState>(map);
  }

  static AdminState fromJson(String json) {
    return ensureInitialized().decodeJson<AdminState>(json);
  }
}

mixin AdminStateMappable {
  String toJson() {
    return AdminStateMapper.ensureInitialized().encodeJson<AdminState>(
      this as AdminState,
    );
  }

  Map<String, dynamic> toMap() {
    return AdminStateMapper.ensureInitialized().encodeMap<AdminState>(
      this as AdminState,
    );
  }

  AdminStateCopyWith<AdminState, AdminState, AdminState> get copyWith =>
      _AdminStateCopyWithImpl<AdminState, AdminState>(
        this as AdminState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AdminStateMapper.ensureInitialized().stringifyValue(
      this as AdminState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminStateMapper.ensureInitialized().equalsValue(
      this as AdminState,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminStateMapper.ensureInitialized().hashValue(this as AdminState);
  }
}

extension AdminStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminState, $Out> {
  AdminStateCopyWith<$R, AdminState, $Out> get $asAdminState =>
      $base.as((v, t, t2) => _AdminStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AdminStateCopyWith<$R, $In extends AdminState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ProviderConfig,
    ProviderConfigCopyWith<$R, ProviderConfig, ProviderConfig>
  >
  get configs;
  ListCopyWith<
    $R,
    UserIdentity,
    UserIdentityCopyWith<$R, UserIdentity, UserIdentity>
  >
  get identities;
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get users;
  MapCopyWith<
    $R,
    String,
    ProviderConnectionStatus,
    ProviderConnectionStatusCopyWith<
      $R,
      ProviderConnectionStatus,
      ProviderConnectionStatus
    >
  >
  get connectionStatuses;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get systemSettings;
  $R call({
    ViewStatus? status,
    AdminSection? selectedSection,
    List<ProviderConfig>? configs,
    List<UserIdentity>? identities,
    List<User>? users,
    String? identitySearchQuery,
    IdentitySortField? identitySortField,
    bool? identitySortAscending,
    Map<String, ProviderConnectionStatus>? connectionStatuses,
    Map<String, String>? systemSettings,
    String? errorMessage,
  });
  AdminStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AdminStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminState, $Out>
    implements AdminStateCopyWith<$R, AdminState, $Out> {
  _AdminStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminState> $mapper =
      AdminStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ProviderConfig,
    ProviderConfigCopyWith<$R, ProviderConfig, ProviderConfig>
  >
  get configs => ListCopyWith(
    $value.configs,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(configs: v),
  );
  @override
  ListCopyWith<
    $R,
    UserIdentity,
    UserIdentityCopyWith<$R, UserIdentity, UserIdentity>
  >
  get identities => ListCopyWith(
    $value.identities,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(identities: v),
  );
  @override
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get users =>
      ListCopyWith(
        $value.users,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(users: v),
      );
  @override
  MapCopyWith<
    $R,
    String,
    ProviderConnectionStatus,
    ProviderConnectionStatusCopyWith<
      $R,
      ProviderConnectionStatus,
      ProviderConnectionStatus
    >
  >
  get connectionStatuses => MapCopyWith(
    $value.connectionStatuses,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(connectionStatuses: v),
  );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get systemSettings => MapCopyWith(
    $value.systemSettings,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(systemSettings: v),
  );
  @override
  $R call({
    ViewStatus? status,
    AdminSection? selectedSection,
    List<ProviderConfig>? configs,
    List<UserIdentity>? identities,
    List<User>? users,
    String? identitySearchQuery,
    IdentitySortField? identitySortField,
    bool? identitySortAscending,
    Map<String, ProviderConnectionStatus>? connectionStatuses,
    Map<String, String>? systemSettings,
    Object? errorMessage = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (selectedSection != null) #selectedSection: selectedSection,
      if (configs != null) #configs: configs,
      if (identities != null) #identities: identities,
      if (users != null) #users: users,
      if (identitySearchQuery != null)
        #identitySearchQuery: identitySearchQuery,
      if (identitySortField != null) #identitySortField: identitySortField,
      if (identitySortAscending != null)
        #identitySortAscending: identitySortAscending,
      if (connectionStatuses != null) #connectionStatuses: connectionStatuses,
      if (systemSettings != null) #systemSettings: systemSettings,
      if (errorMessage != $none) #errorMessage: errorMessage,
    }),
  );
  @override
  AdminState $make(CopyWithData data) => AdminState(
    status: data.get(#status, or: $value.status),
    selectedSection: data.get(#selectedSection, or: $value.selectedSection),
    configs: data.get(#configs, or: $value.configs),
    identities: data.get(#identities, or: $value.identities),
    users: data.get(#users, or: $value.users),
    identitySearchQuery: data.get(
      #identitySearchQuery,
      or: $value.identitySearchQuery,
    ),
    identitySortField: data.get(
      #identitySortField,
      or: $value.identitySortField,
    ),
    identitySortAscending: data.get(
      #identitySortAscending,
      or: $value.identitySortAscending,
    ),
    connectionStatuses: data.get(
      #connectionStatuses,
      or: $value.connectionStatuses,
    ),
    systemSettings: data.get(#systemSettings, or: $value.systemSettings),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
  );

  @override
  AdminStateCopyWith<$R2, AdminState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AdminStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

