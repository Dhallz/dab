// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'explorer_state.dart';

class ExplorerStateMapper extends ClassMapperBase<ExplorerState> {
  ExplorerStateMapper._();

  static ExplorerStateMapper? _instance;
  static ExplorerStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExplorerStateMapper._());
      ViewStatusMapper.ensureInitialized();
      ExplorerItemMapper.ensureInitialized();
      DirectoryTypeMapper.ensureInitialized();
      UserMapper.ensureInitialized();
      GroupMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExplorerState';

  static ViewStatus _$status(ExplorerState v) => v.status;
  static const Field<ExplorerState, ViewStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: ViewStatus.initial,
  );
  static List<ExplorerItem> _$items(ExplorerState v) => v.items;
  static const Field<ExplorerState, List<ExplorerItem>> _f$items = Field(
    'items',
    _$items,
    opt: true,
    def: const [],
  );
  static String? _$errorMessage(ExplorerState v) => v.errorMessage;
  static const Field<ExplorerState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );
  static DateTime _$selectedDate(ExplorerState v) => v.selectedDate;
  static const Field<ExplorerState, DateTime> _f$selectedDate = Field(
    'selectedDate',
    _$selectedDate,
  );
  static DirectoryType _$directoryType(ExplorerState v) => v.directoryType;
  static const Field<ExplorerState, DirectoryType> _f$directoryType = Field(
    'directoryType',
    _$directoryType,
    opt: true,
    def: DirectoryType.users,
  );
  static List<User> _$users(ExplorerState v) => v.users;
  static const Field<ExplorerState, List<User>> _f$users = Field(
    'users',
    _$users,
    opt: true,
    def: const [],
  );
  static List<Group> _$groups(ExplorerState v) => v.groups;
  static const Field<ExplorerState, List<Group>> _f$groups = Field(
    'groups',
    _$groups,
    opt: true,
    def: const [],
  );
  static Set<String> _$selectedUserIds(ExplorerState v) => v.selectedUserIds;
  static const Field<ExplorerState, Set<String>> _f$selectedUserIds = Field(
    'selectedUserIds',
    _$selectedUserIds,
    opt: true,
    def: const {},
  );
  static Set<String> _$selectedGroupIds(ExplorerState v) => v.selectedGroupIds;
  static const Field<ExplorerState, Set<String>> _f$selectedGroupIds = Field(
    'selectedGroupIds',
    _$selectedGroupIds,
    opt: true,
    def: const {},
  );
  static List<String> _$availableProviders(ExplorerState v) =>
      v.availableProviders;
  static const Field<ExplorerState, List<String>> _f$availableProviders = Field(
    'availableProviders',
    _$availableProviders,
    opt: true,
    def: const [],
  );
  static Set<String> _$selectedProviders(ExplorerState v) =>
      v.selectedProviders;
  static const Field<ExplorerState, Set<String>> _f$selectedProviders = Field(
    'selectedProviders',
    _$selectedProviders,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<ExplorerState> fields = const {
    #status: _f$status,
    #items: _f$items,
    #errorMessage: _f$errorMessage,
    #selectedDate: _f$selectedDate,
    #directoryType: _f$directoryType,
    #users: _f$users,
    #groups: _f$groups,
    #selectedUserIds: _f$selectedUserIds,
    #selectedGroupIds: _f$selectedGroupIds,
    #availableProviders: _f$availableProviders,
    #selectedProviders: _f$selectedProviders,
  };

  static ExplorerState _instantiate(DecodingData data) {
    return ExplorerState(
      status: data.dec(_f$status),
      items: data.dec(_f$items),
      errorMessage: data.dec(_f$errorMessage),
      selectedDate: data.dec(_f$selectedDate),
      directoryType: data.dec(_f$directoryType),
      users: data.dec(_f$users),
      groups: data.dec(_f$groups),
      selectedUserIds: data.dec(_f$selectedUserIds),
      selectedGroupIds: data.dec(_f$selectedGroupIds),
      availableProviders: data.dec(_f$availableProviders),
      selectedProviders: data.dec(_f$selectedProviders),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ExplorerState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExplorerState>(map);
  }

  static ExplorerState fromJson(String json) {
    return ensureInitialized().decodeJson<ExplorerState>(json);
  }
}

mixin ExplorerStateMappable {
  String toJson() {
    return ExplorerStateMapper.ensureInitialized().encodeJson<ExplorerState>(
      this as ExplorerState,
    );
  }

  Map<String, dynamic> toMap() {
    return ExplorerStateMapper.ensureInitialized().encodeMap<ExplorerState>(
      this as ExplorerState,
    );
  }

  ExplorerStateCopyWith<ExplorerState, ExplorerState, ExplorerState>
  get copyWith => _ExplorerStateCopyWithImpl<ExplorerState, ExplorerState>(
    this as ExplorerState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ExplorerStateMapper.ensureInitialized().stringifyValue(
      this as ExplorerState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExplorerStateMapper.ensureInitialized().equalsValue(
      this as ExplorerState,
      other,
    );
  }

  @override
  int get hashCode {
    return ExplorerStateMapper.ensureInitialized().hashValue(
      this as ExplorerState,
    );
  }
}

extension ExplorerStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExplorerState, $Out> {
  ExplorerStateCopyWith<$R, ExplorerState, $Out> get $asExplorerState =>
      $base.as((v, t, t2) => _ExplorerStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExplorerStateCopyWith<$R, $In extends ExplorerState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ExplorerItem, ObjectCopyWith<$R, ExplorerItem, ExplorerItem>>
  get items;
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get users;
  ListCopyWith<$R, Group, GroupCopyWith<$R, Group, Group>> get groups;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get availableProviders;
  $R call({
    ViewStatus? status,
    List<ExplorerItem>? items,
    String? errorMessage,
    DateTime? selectedDate,
    DirectoryType? directoryType,
    List<User>? users,
    List<Group>? groups,
    Set<String>? selectedUserIds,
    Set<String>? selectedGroupIds,
    List<String>? availableProviders,
    Set<String>? selectedProviders,
  });
  ExplorerStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExplorerStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExplorerState, $Out>
    implements ExplorerStateCopyWith<$R, ExplorerState, $Out> {
  _ExplorerStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExplorerState> $mapper =
      ExplorerStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ExplorerItem, ObjectCopyWith<$R, ExplorerItem, ExplorerItem>>
  get items => ListCopyWith(
    $value.items,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(items: v),
  );
  @override
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get users =>
      ListCopyWith(
        $value.users,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(users: v),
      );
  @override
  ListCopyWith<$R, Group, GroupCopyWith<$R, Group, Group>> get groups =>
      ListCopyWith(
        $value.groups,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(groups: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get availableProviders => ListCopyWith(
    $value.availableProviders,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(availableProviders: v),
  );
  @override
  $R call({
    ViewStatus? status,
    List<ExplorerItem>? items,
    Object? errorMessage = $none,
    DateTime? selectedDate,
    DirectoryType? directoryType,
    List<User>? users,
    List<Group>? groups,
    Set<String>? selectedUserIds,
    Set<String>? selectedGroupIds,
    List<String>? availableProviders,
    Set<String>? selectedProviders,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (items != null) #items: items,
      if (errorMessage != $none) #errorMessage: errorMessage,
      if (selectedDate != null) #selectedDate: selectedDate,
      if (directoryType != null) #directoryType: directoryType,
      if (users != null) #users: users,
      if (groups != null) #groups: groups,
      if (selectedUserIds != null) #selectedUserIds: selectedUserIds,
      if (selectedGroupIds != null) #selectedGroupIds: selectedGroupIds,
      if (availableProviders != null) #availableProviders: availableProviders,
      if (selectedProviders != null) #selectedProviders: selectedProviders,
    }),
  );
  @override
  ExplorerState $make(CopyWithData data) => ExplorerState(
    status: data.get(#status, or: $value.status),
    items: data.get(#items, or: $value.items),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
    selectedDate: data.get(#selectedDate, or: $value.selectedDate),
    directoryType: data.get(#directoryType, or: $value.directoryType),
    users: data.get(#users, or: $value.users),
    groups: data.get(#groups, or: $value.groups),
    selectedUserIds: data.get(#selectedUserIds, or: $value.selectedUserIds),
    selectedGroupIds: data.get(#selectedGroupIds, or: $value.selectedGroupIds),
    availableProviders: data.get(
      #availableProviders,
      or: $value.availableProviders,
    ),
    selectedProviders: data.get(
      #selectedProviders,
      or: $value.selectedProviders,
    ),
  );

  @override
  ExplorerStateCopyWith<$R2, ExplorerState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExplorerStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

