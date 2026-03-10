// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'group.dart';

class GroupTypeMapper extends EnumMapper<GroupType> {
  GroupTypeMapper._();

  static GroupTypeMapper? _instance;
  static GroupTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GroupTypeMapper._());
    }
    return _instance!;
  }

  static GroupType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  GroupType decode(dynamic value) {
    switch (value) {
      case r'custom':
        return GroupType.custom;
      case r'provider':
        return GroupType.provider;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(GroupType self) {
    switch (self) {
      case GroupType.custom:
        return r'custom';
      case GroupType.provider:
        return r'provider';
    }
  }
}

extension GroupTypeMapperExtension on GroupType {
  String toValue() {
    GroupTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<GroupType>(this) as String;
  }
}

class GroupMapper extends ClassMapperBase<Group> {
  GroupMapper._();

  static GroupMapper? _instance;
  static GroupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GroupMapper._());
      GroupTypeMapper.ensureInitialized();
      UserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Group';

  static String _$id(Group v) => v.id;
  static const Field<Group, String> _f$id = Field('id', _$id);
  static String _$name(Group v) => v.name;
  static const Field<Group, String> _f$name = Field('name', _$name);
  static GroupType _$type(Group v) => v.type;
  static const Field<Group, GroupType> _f$type = Field('type', _$type);
  static List<User> _$members(Group v) => v.members;
  static const Field<Group, List<User>> _f$members = Field(
    'members',
    _$members,
    opt: true,
    def: const [],
  );
  static String? _$iconUrl(Group v) => v.iconUrl;
  static const Field<Group, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static String? _$providerName(Group v) => v.providerName;
  static const Field<Group, String> _f$providerName = Field(
    'providerName',
    _$providerName,
    opt: true,
  );

  @override
  final MappableFields<Group> fields = const {
    #id: _f$id,
    #name: _f$name,
    #type: _f$type,
    #members: _f$members,
    #iconUrl: _f$iconUrl,
    #providerName: _f$providerName,
  };

  static Group _instantiate(DecodingData data) {
    return Group(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      type: data.dec(_f$type),
      members: data.dec(_f$members),
      iconUrl: data.dec(_f$iconUrl),
      providerName: data.dec(_f$providerName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Group fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Group>(map);
  }

  static Group fromJson(String json) {
    return ensureInitialized().decodeJson<Group>(json);
  }
}

mixin GroupMappable {
  String toJson() {
    return GroupMapper.ensureInitialized().encodeJson<Group>(this as Group);
  }

  Map<String, dynamic> toMap() {
    return GroupMapper.ensureInitialized().encodeMap<Group>(this as Group);
  }

  GroupCopyWith<Group, Group, Group> get copyWith =>
      _GroupCopyWithImpl<Group, Group>(this as Group, $identity, $identity);
  @override
  String toString() {
    return GroupMapper.ensureInitialized().stringifyValue(this as Group);
  }

  @override
  bool operator ==(Object other) {
    return GroupMapper.ensureInitialized().equalsValue(this as Group, other);
  }

  @override
  int get hashCode {
    return GroupMapper.ensureInitialized().hashValue(this as Group);
  }
}

extension GroupValueCopy<$R, $Out> on ObjectCopyWith<$R, Group, $Out> {
  GroupCopyWith<$R, Group, $Out> get $asGroup =>
      $base.as((v, t, t2) => _GroupCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GroupCopyWith<$R, $In extends Group, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get members;
  $R call({
    String? id,
    String? name,
    GroupType? type,
    List<User>? members,
    String? iconUrl,
    String? providerName,
  });
  GroupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GroupCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Group, $Out>
    implements GroupCopyWith<$R, Group, $Out> {
  _GroupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Group> $mapper = GroupMapper.ensureInitialized();
  @override
  ListCopyWith<$R, User, UserCopyWith<$R, User, User>> get members =>
      ListCopyWith(
        $value.members,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(members: v),
      );
  @override
  $R call({
    String? id,
    String? name,
    GroupType? type,
    List<User>? members,
    Object? iconUrl = $none,
    Object? providerName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (type != null) #type: type,
      if (members != null) #members: members,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (providerName != $none) #providerName: providerName,
    }),
  );
  @override
  Group $make(CopyWithData data) => Group(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    type: data.get(#type, or: $value.type),
    members: data.get(#members, or: $value.members),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    providerName: data.get(#providerName, or: $value.providerName),
  );

  @override
  GroupCopyWith<$R2, Group, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GroupCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

