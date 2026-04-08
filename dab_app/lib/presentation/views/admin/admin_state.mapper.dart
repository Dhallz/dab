// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'admin_state.dart';

class AdminStatusMapper extends EnumMapper<AdminStatus> {
  AdminStatusMapper._();

  static AdminStatusMapper? _instance;
  static AdminStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminStatusMapper._());
    }
    return _instance!;
  }

  static AdminStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AdminStatus decode(dynamic value) {
    switch (value) {
      case r'initial':
        return AdminStatus.initial;
      case r'loading':
        return AdminStatus.loading;
      case r'success':
        return AdminStatus.success;
      case r'failure':
        return AdminStatus.failure;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AdminStatus self) {
    switch (self) {
      case AdminStatus.initial:
        return r'initial';
      case AdminStatus.loading:
        return r'loading';
      case AdminStatus.success:
        return r'success';
      case AdminStatus.failure:
        return r'failure';
    }
  }
}

extension AdminStatusMapperExtension on AdminStatus {
  String toValue() {
    AdminStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AdminStatus>(this) as String;
  }
}

class AdminSectionMapper extends EnumMapper<AdminSection> {
  AdminSectionMapper._();

  static AdminSectionMapper? _instance;
  static AdminSectionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminSectionMapper._());
    }
    return _instance!;
  }

  static AdminSection fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AdminSection decode(dynamic value) {
    switch (value) {
      case r'providers':
        return AdminSection.providers;
      case r'security':
        return AdminSection.security;
      case r'identities':
        return AdminSection.identities;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AdminSection self) {
    switch (self) {
      case AdminSection.providers:
        return r'providers';
      case AdminSection.security:
        return r'security';
      case AdminSection.identities:
        return r'identities';
    }
  }
}

extension AdminSectionMapperExtension on AdminSection {
  String toValue() {
    AdminSectionMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AdminSection>(this) as String;
  }
}

class ProviderConnectionStatusMapper
    extends ClassMapperBase<ProviderConnectionStatus> {
  ProviderConnectionStatusMapper._();

  static ProviderConnectionStatusMapper? _instance;
  static ProviderConnectionStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ProviderConnectionStatusMapper._(),
      );
      AdminStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ProviderConnectionStatus';

  static AdminStatus _$status(ProviderConnectionStatus v) => v.status;
  static const Field<ProviderConnectionStatus, AdminStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: AdminStatus.initial,
  );
  static String? _$message(ProviderConnectionStatus v) => v.message;
  static const Field<ProviderConnectionStatus, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );
  static DateTime? _$lastCheck(ProviderConnectionStatus v) => v.lastCheck;
  static const Field<ProviderConnectionStatus, DateTime> _f$lastCheck = Field(
    'lastCheck',
    _$lastCheck,
    opt: true,
  );

  @override
  final MappableFields<ProviderConnectionStatus> fields = const {
    #status: _f$status,
    #message: _f$message,
    #lastCheck: _f$lastCheck,
  };

  static ProviderConnectionStatus _instantiate(DecodingData data) {
    return ProviderConnectionStatus(
      status: data.dec(_f$status),
      message: data.dec(_f$message),
      lastCheck: data.dec(_f$lastCheck),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProviderConnectionStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProviderConnectionStatus>(map);
  }

  static ProviderConnectionStatus fromJson(String json) {
    return ensureInitialized().decodeJson<ProviderConnectionStatus>(json);
  }
}

mixin ProviderConnectionStatusMappable {
  String toJson() {
    return ProviderConnectionStatusMapper.ensureInitialized()
        .encodeJson<ProviderConnectionStatus>(this as ProviderConnectionStatus);
  }

  Map<String, dynamic> toMap() {
    return ProviderConnectionStatusMapper.ensureInitialized()
        .encodeMap<ProviderConnectionStatus>(this as ProviderConnectionStatus);
  }

  ProviderConnectionStatusCopyWith<
    ProviderConnectionStatus,
    ProviderConnectionStatus,
    ProviderConnectionStatus
  >
  get copyWith =>
      _ProviderConnectionStatusCopyWithImpl<
        ProviderConnectionStatus,
        ProviderConnectionStatus
      >(this as ProviderConnectionStatus, $identity, $identity);
  @override
  String toString() {
    return ProviderConnectionStatusMapper.ensureInitialized().stringifyValue(
      this as ProviderConnectionStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProviderConnectionStatusMapper.ensureInitialized().equalsValue(
      this as ProviderConnectionStatus,
      other,
    );
  }

  @override
  int get hashCode {
    return ProviderConnectionStatusMapper.ensureInitialized().hashValue(
      this as ProviderConnectionStatus,
    );
  }
}

extension ProviderConnectionStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProviderConnectionStatus, $Out> {
  ProviderConnectionStatusCopyWith<$R, ProviderConnectionStatus, $Out>
  get $asProviderConnectionStatus => $base.as(
    (v, t, t2) => _ProviderConnectionStatusCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ProviderConnectionStatusCopyWith<
  $R,
  $In extends ProviderConnectionStatus,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({AdminStatus? status, String? message, DateTime? lastCheck});
  ProviderConnectionStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProviderConnectionStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProviderConnectionStatus, $Out>
    implements
        ProviderConnectionStatusCopyWith<$R, ProviderConnectionStatus, $Out> {
  _ProviderConnectionStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProviderConnectionStatus> $mapper =
      ProviderConnectionStatusMapper.ensureInitialized();
  @override
  $R call({
    AdminStatus? status,
    Object? message = $none,
    Object? lastCheck = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (message != $none) #message: message,
      if (lastCheck != $none) #lastCheck: lastCheck,
    }),
  );
  @override
  ProviderConnectionStatus $make(CopyWithData data) => ProviderConnectionStatus(
    status: data.get(#status, or: $value.status),
    message: data.get(#message, or: $value.message),
    lastCheck: data.get(#lastCheck, or: $value.lastCheck),
  );

  @override
  ProviderConnectionStatusCopyWith<$R2, ProviderConnectionStatus, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProviderConnectionStatusCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminStateMapper extends ClassMapperBase<AdminState> {
  AdminStateMapper._();

  static AdminStateMapper? _instance;
  static AdminStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminStateMapper._());
      AdminStatusMapper.ensureInitialized();
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

  static AdminStatus _$status(AdminState v) => v.status;
  static const Field<AdminState, AdminStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: AdminStatus.initial,
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
    #connectionStatuses: _f$connectionStatuses,
    #errorMessage: _f$errorMessage,
  };

  static AdminState _instantiate(DecodingData data) {
    return AdminState(
      status: data.dec(_f$status),
      selectedSection: data.dec(_f$selectedSection),
      configs: data.dec(_f$configs),
      identities: data.dec(_f$identities),
      users: data.dec(_f$users),
      connectionStatuses: data.dec(_f$connectionStatuses),
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
  $R call({
    AdminStatus? status,
    AdminSection? selectedSection,
    List<ProviderConfig>? configs,
    List<UserIdentity>? identities,
    List<User>? users,
    Map<String, ProviderConnectionStatus>? connectionStatuses,
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
  $R call({
    AdminStatus? status,
    AdminSection? selectedSection,
    List<ProviderConfig>? configs,
    List<UserIdentity>? identities,
    List<User>? users,
    Map<String, ProviderConnectionStatus>? connectionStatuses,
    Object? errorMessage = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (selectedSection != null) #selectedSection: selectedSection,
      if (configs != null) #configs: configs,
      if (identities != null) #identities: identities,
      if (users != null) #users: users,
      if (connectionStatuses != null) #connectionStatuses: connectionStatuses,
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
    connectionStatuses: data.get(
      #connectionStatuses,
      or: $value.connectionStatuses,
    ),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
  );

  @override
  AdminStateCopyWith<$R2, AdminState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AdminStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

