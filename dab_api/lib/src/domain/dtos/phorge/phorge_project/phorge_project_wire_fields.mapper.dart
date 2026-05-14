// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_project_wire_fields.dart';

class PhorgeProjectWireFieldsMapper
    extends ClassMapperBase<PhorgeProjectWireFields> {
  PhorgeProjectWireFieldsMapper._();

  static PhorgeProjectWireFieldsMapper? _instance;
  static PhorgeProjectWireFieldsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeProjectWireFieldsMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeProjectWireFields';

  static String? _$name(PhorgeProjectWireFields v) => v.name;
  static const Field<PhorgeProjectWireFields, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static String? _$slug(PhorgeProjectWireFields v) => v.slug;
  static const Field<PhorgeProjectWireFields, String> _f$slug = Field(
    'slug',
    _$slug,
    opt: true,
  );
  static String? _$subtype(PhorgeProjectWireFields v) => v.subtype;
  static const Field<PhorgeProjectWireFields, String> _f$subtype = Field(
    'subtype',
    _$subtype,
    opt: true,
  );
  static int? _$milestone(PhorgeProjectWireFields v) => v.milestone;
  static const Field<PhorgeProjectWireFields, int> _f$milestone = Field(
    'milestone',
    _$milestone,
    opt: true,
  );
  static Map<String, dynamic>? _$parent(PhorgeProjectWireFields v) => v.parent;
  static const Field<PhorgeProjectWireFields, Map<String, dynamic>> _f$parent =
      Field('parent', _$parent, opt: true);
  static int? _$depth(PhorgeProjectWireFields v) => v.depth;
  static const Field<PhorgeProjectWireFields, int> _f$depth = Field(
    'depth',
    _$depth,
    opt: true,
  );
  static Object? _$icon(PhorgeProjectWireFields v) => v.icon;
  static const Field<PhorgeProjectWireFields, Object> _f$icon = Field(
    'icon',
    _$icon,
    opt: true,
  );
  static Object? _$color(PhorgeProjectWireFields v) => v.color;
  static const Field<PhorgeProjectWireFields, Object> _f$color = Field(
    'color',
    _$color,
    opt: true,
  );
  static String? _$spacePHID(PhorgeProjectWireFields v) => v.spacePHID;
  static const Field<PhorgeProjectWireFields, String> _f$spacePHID = Field(
    'spacePHID',
    _$spacePHID,
    opt: true,
  );
  static int? _$dateCreated(PhorgeProjectWireFields v) => v.dateCreated;
  static const Field<PhorgeProjectWireFields, int> _f$dateCreated = Field(
    'dateCreated',
    _$dateCreated,
    opt: true,
  );
  static int? _$dateModified(PhorgeProjectWireFields v) => v.dateModified;
  static const Field<PhorgeProjectWireFields, int> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
    opt: true,
  );
  static Map<String, dynamic>? _$policy(PhorgeProjectWireFields v) => v.policy;
  static const Field<PhorgeProjectWireFields, Map<String, dynamic>> _f$policy =
      Field('policy', _$policy, opt: true);
  static Object? _$description(PhorgeProjectWireFields v) => v.description;
  static const Field<PhorgeProjectWireFields, Object> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );

  @override
  final MappableFields<PhorgeProjectWireFields> fields = const {
    #name: _f$name,
    #slug: _f$slug,
    #subtype: _f$subtype,
    #milestone: _f$milestone,
    #parent: _f$parent,
    #depth: _f$depth,
    #icon: _f$icon,
    #color: _f$color,
    #spacePHID: _f$spacePHID,
    #dateCreated: _f$dateCreated,
    #dateModified: _f$dateModified,
    #policy: _f$policy,
    #description: _f$description,
  };

  static PhorgeProjectWireFields _instantiate(DecodingData data) {
    return PhorgeProjectWireFields(
      name: data.dec(_f$name),
      slug: data.dec(_f$slug),
      subtype: data.dec(_f$subtype),
      milestone: data.dec(_f$milestone),
      parent: data.dec(_f$parent),
      depth: data.dec(_f$depth),
      icon: data.dec(_f$icon),
      color: data.dec(_f$color),
      spacePHID: data.dec(_f$spacePHID),
      dateCreated: data.dec(_f$dateCreated),
      dateModified: data.dec(_f$dateModified),
      policy: data.dec(_f$policy),
      description: data.dec(_f$description),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeProjectWireFields fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeProjectWireFields>(map);
  }

  static PhorgeProjectWireFields fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeProjectWireFields>(json);
  }
}

mixin PhorgeProjectWireFieldsMappable {
  String toJson() {
    return PhorgeProjectWireFieldsMapper.ensureInitialized()
        .encodeJson<PhorgeProjectWireFields>(this as PhorgeProjectWireFields);
  }

  Map<String, dynamic> toMap() {
    return PhorgeProjectWireFieldsMapper.ensureInitialized()
        .encodeMap<PhorgeProjectWireFields>(this as PhorgeProjectWireFields);
  }

  PhorgeProjectWireFieldsCopyWith<
    PhorgeProjectWireFields,
    PhorgeProjectWireFields,
    PhorgeProjectWireFields
  >
  get copyWith =>
      _PhorgeProjectWireFieldsCopyWithImpl<
        PhorgeProjectWireFields,
        PhorgeProjectWireFields
      >(this as PhorgeProjectWireFields, $identity, $identity);
  @override
  String toString() {
    return PhorgeProjectWireFieldsMapper.ensureInitialized().stringifyValue(
      this as PhorgeProjectWireFields,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeProjectWireFieldsMapper.ensureInitialized().equalsValue(
      this as PhorgeProjectWireFields,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeProjectWireFieldsMapper.ensureInitialized().hashValue(
      this as PhorgeProjectWireFields,
    );
  }
}

extension PhorgeProjectWireFieldsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeProjectWireFields, $Out> {
  PhorgeProjectWireFieldsCopyWith<$R, PhorgeProjectWireFields, $Out>
  get $asPhorgeProjectWireFields => $base.as(
    (v, t, t2) => _PhorgeProjectWireFieldsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeProjectWireFieldsCopyWith<
  $R,
  $In extends PhorgeProjectWireFields,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get parent;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get policy;
  $R call({
    String? name,
    String? slug,
    String? subtype,
    int? milestone,
    Map<String, dynamic>? parent,
    int? depth,
    Object? icon,
    Object? color,
    String? spacePHID,
    int? dateCreated,
    int? dateModified,
    Map<String, dynamic>? policy,
    Object? description,
  });
  PhorgeProjectWireFieldsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeProjectWireFieldsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeProjectWireFields, $Out>
    implements
        PhorgeProjectWireFieldsCopyWith<$R, PhorgeProjectWireFields, $Out> {
  _PhorgeProjectWireFieldsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeProjectWireFields> $mapper =
      PhorgeProjectWireFieldsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get parent => $value.parent != null
      ? MapCopyWith(
          $value.parent!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(parent: v),
        )
      : null;
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get policy => $value.policy != null
      ? MapCopyWith(
          $value.policy!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(policy: v),
        )
      : null;
  @override
  $R call({
    Object? name = $none,
    Object? slug = $none,
    Object? subtype = $none,
    Object? milestone = $none,
    Object? parent = $none,
    Object? depth = $none,
    Object? icon = $none,
    Object? color = $none,
    Object? spacePHID = $none,
    Object? dateCreated = $none,
    Object? dateModified = $none,
    Object? policy = $none,
    Object? description = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != $none) #name: name,
      if (slug != $none) #slug: slug,
      if (subtype != $none) #subtype: subtype,
      if (milestone != $none) #milestone: milestone,
      if (parent != $none) #parent: parent,
      if (depth != $none) #depth: depth,
      if (icon != $none) #icon: icon,
      if (color != $none) #color: color,
      if (spacePHID != $none) #spacePHID: spacePHID,
      if (dateCreated != $none) #dateCreated: dateCreated,
      if (dateModified != $none) #dateModified: dateModified,
      if (policy != $none) #policy: policy,
      if (description != $none) #description: description,
    }),
  );
  @override
  PhorgeProjectWireFields $make(CopyWithData data) => PhorgeProjectWireFields(
    name: data.get(#name, or: $value.name),
    slug: data.get(#slug, or: $value.slug),
    subtype: data.get(#subtype, or: $value.subtype),
    milestone: data.get(#milestone, or: $value.milestone),
    parent: data.get(#parent, or: $value.parent),
    depth: data.get(#depth, or: $value.depth),
    icon: data.get(#icon, or: $value.icon),
    color: data.get(#color, or: $value.color),
    spacePHID: data.get(#spacePHID, or: $value.spacePHID),
    dateCreated: data.get(#dateCreated, or: $value.dateCreated),
    dateModified: data.get(#dateModified, or: $value.dateModified),
    policy: data.get(#policy, or: $value.policy),
    description: data.get(#description, or: $value.description),
  );

  @override
  PhorgeProjectWireFieldsCopyWith<$R2, PhorgeProjectWireFields, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeProjectWireFieldsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

