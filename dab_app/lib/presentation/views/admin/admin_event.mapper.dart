// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'admin_event.dart';

class AdminEventMapper extends ClassMapperBase<AdminEvent> {
  AdminEventMapper._();

  static AdminEventMapper? _instance;
  static AdminEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminEventMapper._());
      AdminStartedMapper.ensureInitialized();
      AdminConfigUpdatedMapper.ensureInitialized();
      AdminProviderToggledMapper.ensureInitialized();
      AdminSectionChangedMapper.ensureInitialized();
      AdminUserRoleUpdatedMapper.ensureInitialized();
      AdminIdentityLinkedMapper.ensureInitialized();
      AdminIdentityResolvedMapper.ensureInitialized();
      AdminIdentitySortChangedMapper.ensureInitialized();
      AdminIdentitySearchChangedMapper.ensureInitialized();
      AdminTestConnectionMapper.ensureInitialized();
      AdminRefreshProviderStatusesMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminEvent';

  @override
  final MappableFields<AdminEvent> fields = const {};

  static AdminEvent _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('AdminEvent');
  }

  @override
  final Function instantiate = _instantiate;

  static AdminEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminEvent>(map);
  }

  static AdminEvent fromJson(String json) {
    return ensureInitialized().decodeJson<AdminEvent>(json);
  }
}

mixin AdminEventMappable {
  String toJson();
  Map<String, dynamic> toMap();
  AdminEventCopyWith<AdminEvent, AdminEvent, AdminEvent> get copyWith;
}

abstract class AdminEventCopyWith<$R, $In extends AdminEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  AdminEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class AdminStartedMapper extends ClassMapperBase<AdminStarted> {
  AdminStartedMapper._();

  static AdminStartedMapper? _instance;
  static AdminStartedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminStartedMapper._());
      AdminEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminStarted';

  @override
  final MappableFields<AdminStarted> fields = const {};

  static AdminStarted _instantiate(DecodingData data) {
    return AdminStarted();
  }

  @override
  final Function instantiate = _instantiate;

  static AdminStarted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminStarted>(map);
  }

  static AdminStarted fromJson(String json) {
    return ensureInitialized().decodeJson<AdminStarted>(json);
  }
}

mixin AdminStartedMappable {
  String toJson() {
    return AdminStartedMapper.ensureInitialized().encodeJson<AdminStarted>(
      this as AdminStarted,
    );
  }

  Map<String, dynamic> toMap() {
    return AdminStartedMapper.ensureInitialized().encodeMap<AdminStarted>(
      this as AdminStarted,
    );
  }

  AdminStartedCopyWith<AdminStarted, AdminStarted, AdminStarted> get copyWith =>
      _AdminStartedCopyWithImpl<AdminStarted, AdminStarted>(
        this as AdminStarted,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AdminStartedMapper.ensureInitialized().stringifyValue(
      this as AdminStarted,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminStartedMapper.ensureInitialized().equalsValue(
      this as AdminStarted,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminStartedMapper.ensureInitialized().hashValue(
      this as AdminStarted,
    );
  }
}

extension AdminStartedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminStarted, $Out> {
  AdminStartedCopyWith<$R, AdminStarted, $Out> get $asAdminStarted =>
      $base.as((v, t, t2) => _AdminStartedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AdminStartedCopyWith<$R, $In extends AdminStarted, $Out>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AdminStartedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AdminStartedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminStarted, $Out>
    implements AdminStartedCopyWith<$R, AdminStarted, $Out> {
  _AdminStartedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminStarted> $mapper =
      AdminStartedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AdminStarted $make(CopyWithData data) => AdminStarted();

  @override
  AdminStartedCopyWith<$R2, AdminStarted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AdminStartedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminConfigUpdatedMapper extends ClassMapperBase<AdminConfigUpdated> {
  AdminConfigUpdatedMapper._();

  static AdminConfigUpdatedMapper? _instance;
  static AdminConfigUpdatedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminConfigUpdatedMapper._());
      AdminEventMapper.ensureInitialized();
      ProviderConfigMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminConfigUpdated';

  static ProviderConfig _$config(AdminConfigUpdated v) => v.config;
  static const Field<AdminConfigUpdated, ProviderConfig> _f$config = Field(
    'config',
    _$config,
  );

  @override
  final MappableFields<AdminConfigUpdated> fields = const {#config: _f$config};

  static AdminConfigUpdated _instantiate(DecodingData data) {
    return AdminConfigUpdated(data.dec(_f$config));
  }

  @override
  final Function instantiate = _instantiate;

  static AdminConfigUpdated fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminConfigUpdated>(map);
  }

  static AdminConfigUpdated fromJson(String json) {
    return ensureInitialized().decodeJson<AdminConfigUpdated>(json);
  }
}

mixin AdminConfigUpdatedMappable {
  String toJson() {
    return AdminConfigUpdatedMapper.ensureInitialized()
        .encodeJson<AdminConfigUpdated>(this as AdminConfigUpdated);
  }

  Map<String, dynamic> toMap() {
    return AdminConfigUpdatedMapper.ensureInitialized()
        .encodeMap<AdminConfigUpdated>(this as AdminConfigUpdated);
  }

  AdminConfigUpdatedCopyWith<
    AdminConfigUpdated,
    AdminConfigUpdated,
    AdminConfigUpdated
  >
  get copyWith =>
      _AdminConfigUpdatedCopyWithImpl<AdminConfigUpdated, AdminConfigUpdated>(
        this as AdminConfigUpdated,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AdminConfigUpdatedMapper.ensureInitialized().stringifyValue(
      this as AdminConfigUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminConfigUpdatedMapper.ensureInitialized().equalsValue(
      this as AdminConfigUpdated,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminConfigUpdatedMapper.ensureInitialized().hashValue(
      this as AdminConfigUpdated,
    );
  }
}

extension AdminConfigUpdatedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminConfigUpdated, $Out> {
  AdminConfigUpdatedCopyWith<$R, AdminConfigUpdated, $Out>
  get $asAdminConfigUpdated => $base.as(
    (v, t, t2) => _AdminConfigUpdatedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminConfigUpdatedCopyWith<
  $R,
  $In extends AdminConfigUpdated,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  ProviderConfigCopyWith<$R, ProviderConfig, ProviderConfig> get config;
  @override
  $R call({ProviderConfig? config});
  AdminConfigUpdatedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminConfigUpdatedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminConfigUpdated, $Out>
    implements AdminConfigUpdatedCopyWith<$R, AdminConfigUpdated, $Out> {
  _AdminConfigUpdatedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminConfigUpdated> $mapper =
      AdminConfigUpdatedMapper.ensureInitialized();
  @override
  ProviderConfigCopyWith<$R, ProviderConfig, ProviderConfig> get config =>
      $value.config.copyWith.$chain((v) => call(config: v));
  @override
  $R call({ProviderConfig? config}) =>
      $apply(FieldCopyWithData({if (config != null) #config: config}));
  @override
  AdminConfigUpdated $make(CopyWithData data) =>
      AdminConfigUpdated(data.get(#config, or: $value.config));

  @override
  AdminConfigUpdatedCopyWith<$R2, AdminConfigUpdated, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AdminConfigUpdatedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminProviderToggledMapper extends ClassMapperBase<AdminProviderToggled> {
  AdminProviderToggledMapper._();

  static AdminProviderToggledMapper? _instance;
  static AdminProviderToggledMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminProviderToggledMapper._());
      AdminEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminProviderToggled';

  static String _$id(AdminProviderToggled v) => v.id;
  static const Field<AdminProviderToggled, String> _f$id = Field('id', _$id);
  static bool _$isActive(AdminProviderToggled v) => v.isActive;
  static const Field<AdminProviderToggled, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
  );

  @override
  final MappableFields<AdminProviderToggled> fields = const {
    #id: _f$id,
    #isActive: _f$isActive,
  };

  static AdminProviderToggled _instantiate(DecodingData data) {
    return AdminProviderToggled(
      id: data.dec(_f$id),
      isActive: data.dec(_f$isActive),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminProviderToggled fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminProviderToggled>(map);
  }

  static AdminProviderToggled fromJson(String json) {
    return ensureInitialized().decodeJson<AdminProviderToggled>(json);
  }
}

mixin AdminProviderToggledMappable {
  String toJson() {
    return AdminProviderToggledMapper.ensureInitialized()
        .encodeJson<AdminProviderToggled>(this as AdminProviderToggled);
  }

  Map<String, dynamic> toMap() {
    return AdminProviderToggledMapper.ensureInitialized()
        .encodeMap<AdminProviderToggled>(this as AdminProviderToggled);
  }

  AdminProviderToggledCopyWith<
    AdminProviderToggled,
    AdminProviderToggled,
    AdminProviderToggled
  >
  get copyWith =>
      _AdminProviderToggledCopyWithImpl<
        AdminProviderToggled,
        AdminProviderToggled
      >(this as AdminProviderToggled, $identity, $identity);
  @override
  String toString() {
    return AdminProviderToggledMapper.ensureInitialized().stringifyValue(
      this as AdminProviderToggled,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminProviderToggledMapper.ensureInitialized().equalsValue(
      this as AdminProviderToggled,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminProviderToggledMapper.ensureInitialized().hashValue(
      this as AdminProviderToggled,
    );
  }
}

extension AdminProviderToggledValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminProviderToggled, $Out> {
  AdminProviderToggledCopyWith<$R, AdminProviderToggled, $Out>
  get $asAdminProviderToggled => $base.as(
    (v, t, t2) => _AdminProviderToggledCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminProviderToggledCopyWith<
  $R,
  $In extends AdminProviderToggled,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, bool? isActive});
  AdminProviderToggledCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminProviderToggledCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminProviderToggled, $Out>
    implements AdminProviderToggledCopyWith<$R, AdminProviderToggled, $Out> {
  _AdminProviderToggledCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminProviderToggled> $mapper =
      AdminProviderToggledMapper.ensureInitialized();
  @override
  $R call({String? id, bool? isActive}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (isActive != null) #isActive: isActive,
    }),
  );
  @override
  AdminProviderToggled $make(CopyWithData data) => AdminProviderToggled(
    id: data.get(#id, or: $value.id),
    isActive: data.get(#isActive, or: $value.isActive),
  );

  @override
  AdminProviderToggledCopyWith<$R2, AdminProviderToggled, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminProviderToggledCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminSectionChangedMapper extends ClassMapperBase<AdminSectionChanged> {
  AdminSectionChangedMapper._();

  static AdminSectionChangedMapper? _instance;
  static AdminSectionChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminSectionChangedMapper._());
      AdminEventMapper.ensureInitialized();
      AdminSectionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminSectionChanged';

  static AdminSection _$section(AdminSectionChanged v) => v.section;
  static const Field<AdminSectionChanged, AdminSection> _f$section = Field(
    'section',
    _$section,
  );

  @override
  final MappableFields<AdminSectionChanged> fields = const {
    #section: _f$section,
  };

  static AdminSectionChanged _instantiate(DecodingData data) {
    return AdminSectionChanged(data.dec(_f$section));
  }

  @override
  final Function instantiate = _instantiate;

  static AdminSectionChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminSectionChanged>(map);
  }

  static AdminSectionChanged fromJson(String json) {
    return ensureInitialized().decodeJson<AdminSectionChanged>(json);
  }
}

mixin AdminSectionChangedMappable {
  String toJson() {
    return AdminSectionChangedMapper.ensureInitialized()
        .encodeJson<AdminSectionChanged>(this as AdminSectionChanged);
  }

  Map<String, dynamic> toMap() {
    return AdminSectionChangedMapper.ensureInitialized()
        .encodeMap<AdminSectionChanged>(this as AdminSectionChanged);
  }

  AdminSectionChangedCopyWith<
    AdminSectionChanged,
    AdminSectionChanged,
    AdminSectionChanged
  >
  get copyWith =>
      _AdminSectionChangedCopyWithImpl<
        AdminSectionChanged,
        AdminSectionChanged
      >(this as AdminSectionChanged, $identity, $identity);
  @override
  String toString() {
    return AdminSectionChangedMapper.ensureInitialized().stringifyValue(
      this as AdminSectionChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminSectionChangedMapper.ensureInitialized().equalsValue(
      this as AdminSectionChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminSectionChangedMapper.ensureInitialized().hashValue(
      this as AdminSectionChanged,
    );
  }
}

extension AdminSectionChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminSectionChanged, $Out> {
  AdminSectionChangedCopyWith<$R, AdminSectionChanged, $Out>
  get $asAdminSectionChanged => $base.as(
    (v, t, t2) => _AdminSectionChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminSectionChangedCopyWith<
  $R,
  $In extends AdminSectionChanged,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call({AdminSection? section});
  AdminSectionChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminSectionChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminSectionChanged, $Out>
    implements AdminSectionChangedCopyWith<$R, AdminSectionChanged, $Out> {
  _AdminSectionChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminSectionChanged> $mapper =
      AdminSectionChangedMapper.ensureInitialized();
  @override
  $R call({AdminSection? section}) =>
      $apply(FieldCopyWithData({if (section != null) #section: section}));
  @override
  AdminSectionChanged $make(CopyWithData data) =>
      AdminSectionChanged(data.get(#section, or: $value.section));

  @override
  AdminSectionChangedCopyWith<$R2, AdminSectionChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminSectionChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminUserRoleUpdatedMapper extends ClassMapperBase<AdminUserRoleUpdated> {
  AdminUserRoleUpdatedMapper._();

  static AdminUserRoleUpdatedMapper? _instance;
  static AdminUserRoleUpdatedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminUserRoleUpdatedMapper._());
      AdminEventMapper.ensureInitialized();
      UserRoleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminUserRoleUpdated';

  static String _$userId(AdminUserRoleUpdated v) => v.userId;
  static const Field<AdminUserRoleUpdated, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static UserRole _$role(AdminUserRoleUpdated v) => v.role;
  static const Field<AdminUserRoleUpdated, UserRole> _f$role = Field(
    'role',
    _$role,
  );

  @override
  final MappableFields<AdminUserRoleUpdated> fields = const {
    #userId: _f$userId,
    #role: _f$role,
  };

  static AdminUserRoleUpdated _instantiate(DecodingData data) {
    return AdminUserRoleUpdated(
      userId: data.dec(_f$userId),
      role: data.dec(_f$role),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminUserRoleUpdated fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminUserRoleUpdated>(map);
  }

  static AdminUserRoleUpdated fromJson(String json) {
    return ensureInitialized().decodeJson<AdminUserRoleUpdated>(json);
  }
}

mixin AdminUserRoleUpdatedMappable {
  String toJson() {
    return AdminUserRoleUpdatedMapper.ensureInitialized()
        .encodeJson<AdminUserRoleUpdated>(this as AdminUserRoleUpdated);
  }

  Map<String, dynamic> toMap() {
    return AdminUserRoleUpdatedMapper.ensureInitialized()
        .encodeMap<AdminUserRoleUpdated>(this as AdminUserRoleUpdated);
  }

  AdminUserRoleUpdatedCopyWith<
    AdminUserRoleUpdated,
    AdminUserRoleUpdated,
    AdminUserRoleUpdated
  >
  get copyWith =>
      _AdminUserRoleUpdatedCopyWithImpl<
        AdminUserRoleUpdated,
        AdminUserRoleUpdated
      >(this as AdminUserRoleUpdated, $identity, $identity);
  @override
  String toString() {
    return AdminUserRoleUpdatedMapper.ensureInitialized().stringifyValue(
      this as AdminUserRoleUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminUserRoleUpdatedMapper.ensureInitialized().equalsValue(
      this as AdminUserRoleUpdated,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminUserRoleUpdatedMapper.ensureInitialized().hashValue(
      this as AdminUserRoleUpdated,
    );
  }
}

extension AdminUserRoleUpdatedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminUserRoleUpdated, $Out> {
  AdminUserRoleUpdatedCopyWith<$R, AdminUserRoleUpdated, $Out>
  get $asAdminUserRoleUpdated => $base.as(
    (v, t, t2) => _AdminUserRoleUpdatedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminUserRoleUpdatedCopyWith<
  $R,
  $In extends AdminUserRoleUpdated,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? userId, UserRole? role});
  AdminUserRoleUpdatedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminUserRoleUpdatedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminUserRoleUpdated, $Out>
    implements AdminUserRoleUpdatedCopyWith<$R, AdminUserRoleUpdated, $Out> {
  _AdminUserRoleUpdatedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminUserRoleUpdated> $mapper =
      AdminUserRoleUpdatedMapper.ensureInitialized();
  @override
  $R call({String? userId, UserRole? role}) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (role != null) #role: role,
    }),
  );
  @override
  AdminUserRoleUpdated $make(CopyWithData data) => AdminUserRoleUpdated(
    userId: data.get(#userId, or: $value.userId),
    role: data.get(#role, or: $value.role),
  );

  @override
  AdminUserRoleUpdatedCopyWith<$R2, AdminUserRoleUpdated, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminUserRoleUpdatedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminIdentityLinkedMapper extends ClassMapperBase<AdminIdentityLinked> {
  AdminIdentityLinkedMapper._();

  static AdminIdentityLinkedMapper? _instance;
  static AdminIdentityLinkedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminIdentityLinkedMapper._());
      AdminEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminIdentityLinked';

  static String _$userId(AdminIdentityLinked v) => v.userId;
  static const Field<AdminIdentityLinked, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$providerId(AdminIdentityLinked v) => v.providerId;
  static const Field<AdminIdentityLinked, String> _f$providerId = Field(
    'providerId',
    _$providerId,
  );
  static String _$externalId(AdminIdentityLinked v) => v.externalId;
  static const Field<AdminIdentityLinked, String> _f$externalId = Field(
    'externalId',
    _$externalId,
  );
  static String? _$externalUsername(AdminIdentityLinked v) =>
      v.externalUsername;
  static const Field<AdminIdentityLinked, String> _f$externalUsername = Field(
    'externalUsername',
    _$externalUsername,
    opt: true,
  );

  @override
  final MappableFields<AdminIdentityLinked> fields = const {
    #userId: _f$userId,
    #providerId: _f$providerId,
    #externalId: _f$externalId,
    #externalUsername: _f$externalUsername,
  };

  static AdminIdentityLinked _instantiate(DecodingData data) {
    return AdminIdentityLinked(
      userId: data.dec(_f$userId),
      providerId: data.dec(_f$providerId),
      externalId: data.dec(_f$externalId),
      externalUsername: data.dec(_f$externalUsername),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminIdentityLinked fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminIdentityLinked>(map);
  }

  static AdminIdentityLinked fromJson(String json) {
    return ensureInitialized().decodeJson<AdminIdentityLinked>(json);
  }
}

mixin AdminIdentityLinkedMappable {
  String toJson() {
    return AdminIdentityLinkedMapper.ensureInitialized()
        .encodeJson<AdminIdentityLinked>(this as AdminIdentityLinked);
  }

  Map<String, dynamic> toMap() {
    return AdminIdentityLinkedMapper.ensureInitialized()
        .encodeMap<AdminIdentityLinked>(this as AdminIdentityLinked);
  }

  AdminIdentityLinkedCopyWith<
    AdminIdentityLinked,
    AdminIdentityLinked,
    AdminIdentityLinked
  >
  get copyWith =>
      _AdminIdentityLinkedCopyWithImpl<
        AdminIdentityLinked,
        AdminIdentityLinked
      >(this as AdminIdentityLinked, $identity, $identity);
  @override
  String toString() {
    return AdminIdentityLinkedMapper.ensureInitialized().stringifyValue(
      this as AdminIdentityLinked,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminIdentityLinkedMapper.ensureInitialized().equalsValue(
      this as AdminIdentityLinked,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminIdentityLinkedMapper.ensureInitialized().hashValue(
      this as AdminIdentityLinked,
    );
  }
}

extension AdminIdentityLinkedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminIdentityLinked, $Out> {
  AdminIdentityLinkedCopyWith<$R, AdminIdentityLinked, $Out>
  get $asAdminIdentityLinked => $base.as(
    (v, t, t2) => _AdminIdentityLinkedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminIdentityLinkedCopyWith<
  $R,
  $In extends AdminIdentityLinked,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? userId,
    String? providerId,
    String? externalId,
    String? externalUsername,
  });
  AdminIdentityLinkedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminIdentityLinkedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminIdentityLinked, $Out>
    implements AdminIdentityLinkedCopyWith<$R, AdminIdentityLinked, $Out> {
  _AdminIdentityLinkedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminIdentityLinked> $mapper =
      AdminIdentityLinkedMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    String? providerId,
    String? externalId,
    Object? externalUsername = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (providerId != null) #providerId: providerId,
      if (externalId != null) #externalId: externalId,
      if (externalUsername != $none) #externalUsername: externalUsername,
    }),
  );
  @override
  AdminIdentityLinked $make(CopyWithData data) => AdminIdentityLinked(
    userId: data.get(#userId, or: $value.userId),
    providerId: data.get(#providerId, or: $value.providerId),
    externalId: data.get(#externalId, or: $value.externalId),
    externalUsername: data.get(#externalUsername, or: $value.externalUsername),
  );

  @override
  AdminIdentityLinkedCopyWith<$R2, AdminIdentityLinked, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminIdentityLinkedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminIdentityResolvedMapper
    extends ClassMapperBase<AdminIdentityResolved> {
  AdminIdentityResolvedMapper._();

  static AdminIdentityResolvedMapper? _instance;
  static AdminIdentityResolvedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminIdentityResolvedMapper._());
      AdminEventMapper.ensureInitialized();
      UserIdentityStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminIdentityResolved';

  static String _$userId(AdminIdentityResolved v) => v.userId;
  static const Field<AdminIdentityResolved, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$providerId(AdminIdentityResolved v) => v.providerId;
  static const Field<AdminIdentityResolved, String> _f$providerId = Field(
    'providerId',
    _$providerId,
  );
  static UserIdentityStatus _$status(AdminIdentityResolved v) => v.status;
  static const Field<AdminIdentityResolved, UserIdentityStatus> _f$status =
      Field('status', _$status);

  @override
  final MappableFields<AdminIdentityResolved> fields = const {
    #userId: _f$userId,
    #providerId: _f$providerId,
    #status: _f$status,
  };

  static AdminIdentityResolved _instantiate(DecodingData data) {
    return AdminIdentityResolved(
      userId: data.dec(_f$userId),
      providerId: data.dec(_f$providerId),
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminIdentityResolved fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminIdentityResolved>(map);
  }

  static AdminIdentityResolved fromJson(String json) {
    return ensureInitialized().decodeJson<AdminIdentityResolved>(json);
  }
}

mixin AdminIdentityResolvedMappable {
  String toJson() {
    return AdminIdentityResolvedMapper.ensureInitialized()
        .encodeJson<AdminIdentityResolved>(this as AdminIdentityResolved);
  }

  Map<String, dynamic> toMap() {
    return AdminIdentityResolvedMapper.ensureInitialized()
        .encodeMap<AdminIdentityResolved>(this as AdminIdentityResolved);
  }

  AdminIdentityResolvedCopyWith<
    AdminIdentityResolved,
    AdminIdentityResolved,
    AdminIdentityResolved
  >
  get copyWith =>
      _AdminIdentityResolvedCopyWithImpl<
        AdminIdentityResolved,
        AdminIdentityResolved
      >(this as AdminIdentityResolved, $identity, $identity);
  @override
  String toString() {
    return AdminIdentityResolvedMapper.ensureInitialized().stringifyValue(
      this as AdminIdentityResolved,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminIdentityResolvedMapper.ensureInitialized().equalsValue(
      this as AdminIdentityResolved,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminIdentityResolvedMapper.ensureInitialized().hashValue(
      this as AdminIdentityResolved,
    );
  }
}

extension AdminIdentityResolvedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminIdentityResolved, $Out> {
  AdminIdentityResolvedCopyWith<$R, AdminIdentityResolved, $Out>
  get $asAdminIdentityResolved => $base.as(
    (v, t, t2) => _AdminIdentityResolvedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminIdentityResolvedCopyWith<
  $R,
  $In extends AdminIdentityResolved,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? userId, String? providerId, UserIdentityStatus? status});
  AdminIdentityResolvedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminIdentityResolvedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminIdentityResolved, $Out>
    implements AdminIdentityResolvedCopyWith<$R, AdminIdentityResolved, $Out> {
  _AdminIdentityResolvedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminIdentityResolved> $mapper =
      AdminIdentityResolvedMapper.ensureInitialized();
  @override
  $R call({String? userId, String? providerId, UserIdentityStatus? status}) =>
      $apply(
        FieldCopyWithData({
          if (userId != null) #userId: userId,
          if (providerId != null) #providerId: providerId,
          if (status != null) #status: status,
        }),
      );
  @override
  AdminIdentityResolved $make(CopyWithData data) => AdminIdentityResolved(
    userId: data.get(#userId, or: $value.userId),
    providerId: data.get(#providerId, or: $value.providerId),
    status: data.get(#status, or: $value.status),
  );

  @override
  AdminIdentityResolvedCopyWith<$R2, AdminIdentityResolved, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminIdentityResolvedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminIdentitySortChangedMapper
    extends ClassMapperBase<AdminIdentitySortChanged> {
  AdminIdentitySortChangedMapper._();

  static AdminIdentitySortChangedMapper? _instance;
  static AdminIdentitySortChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = AdminIdentitySortChangedMapper._(),
      );
      AdminEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminIdentitySortChanged';

  static IdentitySortField _$sortField(AdminIdentitySortChanged v) =>
      v.sortField;
  static const Field<AdminIdentitySortChanged, IdentitySortField> _f$sortField =
      Field('sortField', _$sortField);
  static bool _$ascending(AdminIdentitySortChanged v) => v.ascending;
  static const Field<AdminIdentitySortChanged, bool> _f$ascending = Field(
    'ascending',
    _$ascending,
  );

  @override
  final MappableFields<AdminIdentitySortChanged> fields = const {
    #sortField: _f$sortField,
    #ascending: _f$ascending,
  };

  static AdminIdentitySortChanged _instantiate(DecodingData data) {
    return AdminIdentitySortChanged(
      sortField: data.dec(_f$sortField),
      ascending: data.dec(_f$ascending),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminIdentitySortChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminIdentitySortChanged>(map);
  }

  static AdminIdentitySortChanged fromJson(String json) {
    return ensureInitialized().decodeJson<AdminIdentitySortChanged>(json);
  }
}

mixin AdminIdentitySortChangedMappable {
  String toJson() {
    return AdminIdentitySortChangedMapper.ensureInitialized()
        .encodeJson<AdminIdentitySortChanged>(this as AdminIdentitySortChanged);
  }

  Map<String, dynamic> toMap() {
    return AdminIdentitySortChangedMapper.ensureInitialized()
        .encodeMap<AdminIdentitySortChanged>(this as AdminIdentitySortChanged);
  }

  AdminIdentitySortChangedCopyWith<
    AdminIdentitySortChanged,
    AdminIdentitySortChanged,
    AdminIdentitySortChanged
  >
  get copyWith =>
      _AdminIdentitySortChangedCopyWithImpl<
        AdminIdentitySortChanged,
        AdminIdentitySortChanged
      >(this as AdminIdentitySortChanged, $identity, $identity);
  @override
  String toString() {
    return AdminIdentitySortChangedMapper.ensureInitialized().stringifyValue(
      this as AdminIdentitySortChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminIdentitySortChangedMapper.ensureInitialized().equalsValue(
      this as AdminIdentitySortChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminIdentitySortChangedMapper.ensureInitialized().hashValue(
      this as AdminIdentitySortChanged,
    );
  }
}

extension AdminIdentitySortChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminIdentitySortChanged, $Out> {
  AdminIdentitySortChangedCopyWith<$R, AdminIdentitySortChanged, $Out>
  get $asAdminIdentitySortChanged => $base.as(
    (v, t, t2) => _AdminIdentitySortChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminIdentitySortChangedCopyWith<
  $R,
  $In extends AdminIdentitySortChanged,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call({IdentitySortField? sortField, bool? ascending});
  AdminIdentitySortChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminIdentitySortChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminIdentitySortChanged, $Out>
    implements
        AdminIdentitySortChangedCopyWith<$R, AdminIdentitySortChanged, $Out> {
  _AdminIdentitySortChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminIdentitySortChanged> $mapper =
      AdminIdentitySortChangedMapper.ensureInitialized();
  @override
  $R call({IdentitySortField? sortField, bool? ascending}) => $apply(
    FieldCopyWithData({
      if (sortField != null) #sortField: sortField,
      if (ascending != null) #ascending: ascending,
    }),
  );
  @override
  AdminIdentitySortChanged $make(CopyWithData data) => AdminIdentitySortChanged(
    sortField: data.get(#sortField, or: $value.sortField),
    ascending: data.get(#ascending, or: $value.ascending),
  );

  @override
  AdminIdentitySortChangedCopyWith<$R2, AdminIdentitySortChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminIdentitySortChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminIdentitySearchChangedMapper
    extends ClassMapperBase<AdminIdentitySearchChanged> {
  AdminIdentitySearchChangedMapper._();

  static AdminIdentitySearchChangedMapper? _instance;
  static AdminIdentitySearchChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = AdminIdentitySearchChangedMapper._(),
      );
      AdminEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminIdentitySearchChanged';

  static String _$query(AdminIdentitySearchChanged v) => v.query;
  static const Field<AdminIdentitySearchChanged, String> _f$query = Field(
    'query',
    _$query,
  );

  @override
  final MappableFields<AdminIdentitySearchChanged> fields = const {
    #query: _f$query,
  };

  static AdminIdentitySearchChanged _instantiate(DecodingData data) {
    return AdminIdentitySearchChanged(data.dec(_f$query));
  }

  @override
  final Function instantiate = _instantiate;

  static AdminIdentitySearchChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminIdentitySearchChanged>(map);
  }

  static AdminIdentitySearchChanged fromJson(String json) {
    return ensureInitialized().decodeJson<AdminIdentitySearchChanged>(json);
  }
}

mixin AdminIdentitySearchChangedMappable {
  String toJson() {
    return AdminIdentitySearchChangedMapper.ensureInitialized()
        .encodeJson<AdminIdentitySearchChanged>(
          this as AdminIdentitySearchChanged,
        );
  }

  Map<String, dynamic> toMap() {
    return AdminIdentitySearchChangedMapper.ensureInitialized()
        .encodeMap<AdminIdentitySearchChanged>(
          this as AdminIdentitySearchChanged,
        );
  }

  AdminIdentitySearchChangedCopyWith<
    AdminIdentitySearchChanged,
    AdminIdentitySearchChanged,
    AdminIdentitySearchChanged
  >
  get copyWith =>
      _AdminIdentitySearchChangedCopyWithImpl<
        AdminIdentitySearchChanged,
        AdminIdentitySearchChanged
      >(this as AdminIdentitySearchChanged, $identity, $identity);
  @override
  String toString() {
    return AdminIdentitySearchChangedMapper.ensureInitialized().stringifyValue(
      this as AdminIdentitySearchChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminIdentitySearchChangedMapper.ensureInitialized().equalsValue(
      this as AdminIdentitySearchChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminIdentitySearchChangedMapper.ensureInitialized().hashValue(
      this as AdminIdentitySearchChanged,
    );
  }
}

extension AdminIdentitySearchChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminIdentitySearchChanged, $Out> {
  AdminIdentitySearchChangedCopyWith<$R, AdminIdentitySearchChanged, $Out>
  get $asAdminIdentitySearchChanged => $base.as(
    (v, t, t2) => _AdminIdentitySearchChangedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminIdentitySearchChangedCopyWith<
  $R,
  $In extends AdminIdentitySearchChanged,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call({String? query});
  AdminIdentitySearchChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminIdentitySearchChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminIdentitySearchChanged, $Out>
    implements
        AdminIdentitySearchChangedCopyWith<
          $R,
          AdminIdentitySearchChanged,
          $Out
        > {
  _AdminIdentitySearchChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminIdentitySearchChanged> $mapper =
      AdminIdentitySearchChangedMapper.ensureInitialized();
  @override
  $R call({String? query}) =>
      $apply(FieldCopyWithData({if (query != null) #query: query}));
  @override
  AdminIdentitySearchChanged $make(CopyWithData data) =>
      AdminIdentitySearchChanged(data.get(#query, or: $value.query));

  @override
  AdminIdentitySearchChangedCopyWith<$R2, AdminIdentitySearchChanged, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminIdentitySearchChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminTestConnectionMapper extends ClassMapperBase<AdminTestConnection> {
  AdminTestConnectionMapper._();

  static AdminTestConnectionMapper? _instance;
  static AdminTestConnectionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminTestConnectionMapper._());
      AdminEventMapper.ensureInitialized();
      ProviderConfigMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminTestConnection';

  static ProviderConfig _$config(AdminTestConnection v) => v.config;
  static const Field<AdminTestConnection, ProviderConfig> _f$config = Field(
    'config',
    _$config,
  );

  @override
  final MappableFields<AdminTestConnection> fields = const {#config: _f$config};

  static AdminTestConnection _instantiate(DecodingData data) {
    return AdminTestConnection(data.dec(_f$config));
  }

  @override
  final Function instantiate = _instantiate;

  static AdminTestConnection fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminTestConnection>(map);
  }

  static AdminTestConnection fromJson(String json) {
    return ensureInitialized().decodeJson<AdminTestConnection>(json);
  }
}

mixin AdminTestConnectionMappable {
  String toJson() {
    return AdminTestConnectionMapper.ensureInitialized()
        .encodeJson<AdminTestConnection>(this as AdminTestConnection);
  }

  Map<String, dynamic> toMap() {
    return AdminTestConnectionMapper.ensureInitialized()
        .encodeMap<AdminTestConnection>(this as AdminTestConnection);
  }

  AdminTestConnectionCopyWith<
    AdminTestConnection,
    AdminTestConnection,
    AdminTestConnection
  >
  get copyWith =>
      _AdminTestConnectionCopyWithImpl<
        AdminTestConnection,
        AdminTestConnection
      >(this as AdminTestConnection, $identity, $identity);
  @override
  String toString() {
    return AdminTestConnectionMapper.ensureInitialized().stringifyValue(
      this as AdminTestConnection,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminTestConnectionMapper.ensureInitialized().equalsValue(
      this as AdminTestConnection,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminTestConnectionMapper.ensureInitialized().hashValue(
      this as AdminTestConnection,
    );
  }
}

extension AdminTestConnectionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminTestConnection, $Out> {
  AdminTestConnectionCopyWith<$R, AdminTestConnection, $Out>
  get $asAdminTestConnection => $base.as(
    (v, t, t2) => _AdminTestConnectionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminTestConnectionCopyWith<
  $R,
  $In extends AdminTestConnection,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  ProviderConfigCopyWith<$R, ProviderConfig, ProviderConfig> get config;
  @override
  $R call({ProviderConfig? config});
  AdminTestConnectionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminTestConnectionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminTestConnection, $Out>
    implements AdminTestConnectionCopyWith<$R, AdminTestConnection, $Out> {
  _AdminTestConnectionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminTestConnection> $mapper =
      AdminTestConnectionMapper.ensureInitialized();
  @override
  ProviderConfigCopyWith<$R, ProviderConfig, ProviderConfig> get config =>
      $value.config.copyWith.$chain((v) => call(config: v));
  @override
  $R call({ProviderConfig? config}) =>
      $apply(FieldCopyWithData({if (config != null) #config: config}));
  @override
  AdminTestConnection $make(CopyWithData data) =>
      AdminTestConnection(data.get(#config, or: $value.config));

  @override
  AdminTestConnectionCopyWith<$R2, AdminTestConnection, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminTestConnectionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminRefreshProviderStatusesMapper
    extends ClassMapperBase<AdminRefreshProviderStatuses> {
  AdminRefreshProviderStatusesMapper._();

  static AdminRefreshProviderStatusesMapper? _instance;
  static AdminRefreshProviderStatusesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = AdminRefreshProviderStatusesMapper._(),
      );
      AdminEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminRefreshProviderStatuses';

  @override
  final MappableFields<AdminRefreshProviderStatuses> fields = const {};

  static AdminRefreshProviderStatuses _instantiate(DecodingData data) {
    return AdminRefreshProviderStatuses();
  }

  @override
  final Function instantiate = _instantiate;

  static AdminRefreshProviderStatuses fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminRefreshProviderStatuses>(map);
  }

  static AdminRefreshProviderStatuses fromJson(String json) {
    return ensureInitialized().decodeJson<AdminRefreshProviderStatuses>(json);
  }
}

mixin AdminRefreshProviderStatusesMappable {
  String toJson() {
    return AdminRefreshProviderStatusesMapper.ensureInitialized()
        .encodeJson<AdminRefreshProviderStatuses>(
          this as AdminRefreshProviderStatuses,
        );
  }

  Map<String, dynamic> toMap() {
    return AdminRefreshProviderStatusesMapper.ensureInitialized()
        .encodeMap<AdminRefreshProviderStatuses>(
          this as AdminRefreshProviderStatuses,
        );
  }

  AdminRefreshProviderStatusesCopyWith<
    AdminRefreshProviderStatuses,
    AdminRefreshProviderStatuses,
    AdminRefreshProviderStatuses
  >
  get copyWith =>
      _AdminRefreshProviderStatusesCopyWithImpl<
        AdminRefreshProviderStatuses,
        AdminRefreshProviderStatuses
      >(this as AdminRefreshProviderStatuses, $identity, $identity);
  @override
  String toString() {
    return AdminRefreshProviderStatusesMapper.ensureInitialized()
        .stringifyValue(this as AdminRefreshProviderStatuses);
  }

  @override
  bool operator ==(Object other) {
    return AdminRefreshProviderStatusesMapper.ensureInitialized().equalsValue(
      this as AdminRefreshProviderStatuses,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminRefreshProviderStatusesMapper.ensureInitialized().hashValue(
      this as AdminRefreshProviderStatuses,
    );
  }
}

extension AdminRefreshProviderStatusesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminRefreshProviderStatuses, $Out> {
  AdminRefreshProviderStatusesCopyWith<$R, AdminRefreshProviderStatuses, $Out>
  get $asAdminRefreshProviderStatuses => $base.as(
    (v, t, t2) => _AdminRefreshProviderStatusesCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminRefreshProviderStatusesCopyWith<
  $R,
  $In extends AdminRefreshProviderStatuses,
  $Out
>
    implements AdminEventCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AdminRefreshProviderStatusesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminRefreshProviderStatusesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminRefreshProviderStatuses, $Out>
    implements
        AdminRefreshProviderStatusesCopyWith<
          $R,
          AdminRefreshProviderStatuses,
          $Out
        > {
  _AdminRefreshProviderStatusesCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<AdminRefreshProviderStatuses> $mapper =
      AdminRefreshProviderStatusesMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AdminRefreshProviderStatuses $make(CopyWithData data) =>
      AdminRefreshProviderStatuses();

  @override
  AdminRefreshProviderStatusesCopyWith<$R2, AdminRefreshProviderStatuses, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminRefreshProviderStatusesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

