// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'admin_island_bar_model.dart';

class AdminIslandBarModelMapper extends ClassMapperBase<AdminIslandBarModel> {
  AdminIslandBarModelMapper._();

  static AdminIslandBarModelMapper? _instance;
  static AdminIslandBarModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminIslandBarModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AdminIslandBarModel';

  static int _$activeProviders(AdminIslandBarModel v) => v.activeProviders;
  static const Field<AdminIslandBarModel, int> _f$activeProviders = Field(
    'activeProviders',
    _$activeProviders,
  );
  static int _$totalProviders(AdminIslandBarModel v) => v.totalProviders;
  static const Field<AdminIslandBarModel, int> _f$totalProviders = Field(
    'totalProviders',
    _$totalProviders,
  );
  static int _$unresolvedIdentities(AdminIslandBarModel v) =>
      v.unresolvedIdentities;
  static const Field<AdminIslandBarModel, int> _f$unresolvedIdentities = Field(
    'unresolvedIdentities',
    _$unresolvedIdentities,
  );
  static int _$usersCount(AdminIslandBarModel v) => v.usersCount;
  static const Field<AdminIslandBarModel, int> _f$usersCount = Field(
    'usersCount',
    _$usersCount,
  );
  static int _$connectionOk(AdminIslandBarModel v) => v.connectionOk;
  static const Field<AdminIslandBarModel, int> _f$connectionOk = Field(
    'connectionOk',
    _$connectionOk,
  );
  static int _$connectionFailed(AdminIslandBarModel v) => v.connectionFailed;
  static const Field<AdminIslandBarModel, int> _f$connectionFailed = Field(
    'connectionFailed',
    _$connectionFailed,
  );
  static int _$connectionUnknown(AdminIslandBarModel v) => v.connectionUnknown;
  static const Field<AdminIslandBarModel, int> _f$connectionUnknown = Field(
    'connectionUnknown',
    _$connectionUnknown,
  );

  @override
  final MappableFields<AdminIslandBarModel> fields = const {
    #activeProviders: _f$activeProviders,
    #totalProviders: _f$totalProviders,
    #unresolvedIdentities: _f$unresolvedIdentities,
    #usersCount: _f$usersCount,
    #connectionOk: _f$connectionOk,
    #connectionFailed: _f$connectionFailed,
    #connectionUnknown: _f$connectionUnknown,
  };

  static AdminIslandBarModel _instantiate(DecodingData data) {
    return AdminIslandBarModel(
      activeProviders: data.dec(_f$activeProviders),
      totalProviders: data.dec(_f$totalProviders),
      unresolvedIdentities: data.dec(_f$unresolvedIdentities),
      usersCount: data.dec(_f$usersCount),
      connectionOk: data.dec(_f$connectionOk),
      connectionFailed: data.dec(_f$connectionFailed),
      connectionUnknown: data.dec(_f$connectionUnknown),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminIslandBarModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminIslandBarModel>(map);
  }

  static AdminIslandBarModel fromJson(String json) {
    return ensureInitialized().decodeJson<AdminIslandBarModel>(json);
  }
}

mixin AdminIslandBarModelMappable {
  String toJson() {
    return AdminIslandBarModelMapper.ensureInitialized()
        .encodeJson<AdminIslandBarModel>(this as AdminIslandBarModel);
  }

  Map<String, dynamic> toMap() {
    return AdminIslandBarModelMapper.ensureInitialized()
        .encodeMap<AdminIslandBarModel>(this as AdminIslandBarModel);
  }

  AdminIslandBarModelCopyWith<
    AdminIslandBarModel,
    AdminIslandBarModel,
    AdminIslandBarModel
  >
  get copyWith =>
      _AdminIslandBarModelCopyWithImpl<
        AdminIslandBarModel,
        AdminIslandBarModel
      >(this as AdminIslandBarModel, $identity, $identity);
  @override
  String toString() {
    return AdminIslandBarModelMapper.ensureInitialized().stringifyValue(
      this as AdminIslandBarModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdminIslandBarModelMapper.ensureInitialized().equalsValue(
      this as AdminIslandBarModel,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminIslandBarModelMapper.ensureInitialized().hashValue(
      this as AdminIslandBarModel,
    );
  }
}

extension AdminIslandBarModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminIslandBarModel, $Out> {
  AdminIslandBarModelCopyWith<$R, AdminIslandBarModel, $Out>
  get $asAdminIslandBarModel => $base.as(
    (v, t, t2) => _AdminIslandBarModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminIslandBarModelCopyWith<
  $R,
  $In extends AdminIslandBarModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? activeProviders,
    int? totalProviders,
    int? unresolvedIdentities,
    int? usersCount,
    int? connectionOk,
    int? connectionFailed,
    int? connectionUnknown,
  });
  AdminIslandBarModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminIslandBarModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminIslandBarModel, $Out>
    implements AdminIslandBarModelCopyWith<$R, AdminIslandBarModel, $Out> {
  _AdminIslandBarModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminIslandBarModel> $mapper =
      AdminIslandBarModelMapper.ensureInitialized();
  @override
  $R call({
    int? activeProviders,
    int? totalProviders,
    int? unresolvedIdentities,
    int? usersCount,
    int? connectionOk,
    int? connectionFailed,
    int? connectionUnknown,
  }) => $apply(
    FieldCopyWithData({
      if (activeProviders != null) #activeProviders: activeProviders,
      if (totalProviders != null) #totalProviders: totalProviders,
      if (unresolvedIdentities != null)
        #unresolvedIdentities: unresolvedIdentities,
      if (usersCount != null) #usersCount: usersCount,
      if (connectionOk != null) #connectionOk: connectionOk,
      if (connectionFailed != null) #connectionFailed: connectionFailed,
      if (connectionUnknown != null) #connectionUnknown: connectionUnknown,
    }),
  );
  @override
  AdminIslandBarModel $make(CopyWithData data) => AdminIslandBarModel(
    activeProviders: data.get(#activeProviders, or: $value.activeProviders),
    totalProviders: data.get(#totalProviders, or: $value.totalProviders),
    unresolvedIdentities: data.get(
      #unresolvedIdentities,
      or: $value.unresolvedIdentities,
    ),
    usersCount: data.get(#usersCount, or: $value.usersCount),
    connectionOk: data.get(#connectionOk, or: $value.connectionOk),
    connectionFailed: data.get(#connectionFailed, or: $value.connectionFailed),
    connectionUnknown: data.get(
      #connectionUnknown,
      or: $value.connectionUnknown,
    ),
  );

  @override
  AdminIslandBarModelCopyWith<$R2, AdminIslandBarModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminIslandBarModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

