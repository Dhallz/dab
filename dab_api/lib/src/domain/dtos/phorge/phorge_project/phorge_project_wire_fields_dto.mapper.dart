// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_project_wire_fields_dto.dart';

class PhorgeProjectWireFieldsDtoMapper
    extends ClassMapperBase<PhorgeProjectWireFieldsDto> {
  PhorgeProjectWireFieldsDtoMapper._();

  static PhorgeProjectWireFieldsDtoMapper? _instance;
  static PhorgeProjectWireFieldsDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PhorgeProjectWireFieldsDtoMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeProjectWireFieldsDto';

  static String? _$name(PhorgeProjectWireFieldsDto v) => v.name;
  static const Field<PhorgeProjectWireFieldsDto, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static String? _$slug(PhorgeProjectWireFieldsDto v) => v.slug;
  static const Field<PhorgeProjectWireFieldsDto, String> _f$slug = Field(
    'slug',
    _$slug,
    opt: true,
  );
  static String? _$subtype(PhorgeProjectWireFieldsDto v) => v.subtype;
  static const Field<PhorgeProjectWireFieldsDto, String> _f$subtype = Field(
    'subtype',
    _$subtype,
    opt: true,
  );
  static int? _$milestone(PhorgeProjectWireFieldsDto v) => v.milestone;
  static const Field<PhorgeProjectWireFieldsDto, int> _f$milestone = Field(
    'milestone',
    _$milestone,
    opt: true,
  );
  static Map<String, dynamic>? _$parent(PhorgeProjectWireFieldsDto v) =>
      v.parent;
  static const Field<PhorgeProjectWireFieldsDto, Map<String, dynamic>>
  _f$parent = Field('parent', _$parent, opt: true);
  static int? _$depth(PhorgeProjectWireFieldsDto v) => v.depth;
  static const Field<PhorgeProjectWireFieldsDto, int> _f$depth = Field(
    'depth',
    _$depth,
    opt: true,
  );
  static Object? _$icon(PhorgeProjectWireFieldsDto v) => v.icon;
  static const Field<PhorgeProjectWireFieldsDto, Object> _f$icon = Field(
    'icon',
    _$icon,
    opt: true,
  );
  static Object? _$color(PhorgeProjectWireFieldsDto v) => v.color;
  static const Field<PhorgeProjectWireFieldsDto, Object> _f$color = Field(
    'color',
    _$color,
    opt: true,
  );
  static String? _$spacePHID(PhorgeProjectWireFieldsDto v) => v.spacePHID;
  static const Field<PhorgeProjectWireFieldsDto, String> _f$spacePHID = Field(
    'spacePHID',
    _$spacePHID,
    opt: true,
  );
  static int? _$dateCreated(PhorgeProjectWireFieldsDto v) => v.dateCreated;
  static const Field<PhorgeProjectWireFieldsDto, int> _f$dateCreated = Field(
    'dateCreated',
    _$dateCreated,
    opt: true,
  );
  static int? _$dateModified(PhorgeProjectWireFieldsDto v) => v.dateModified;
  static const Field<PhorgeProjectWireFieldsDto, int> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
    opt: true,
  );
  static Map<String, dynamic>? _$policy(PhorgeProjectWireFieldsDto v) =>
      v.policy;
  static const Field<PhorgeProjectWireFieldsDto, Map<String, dynamic>>
  _f$policy = Field('policy', _$policy, opt: true);
  static Object? _$description(PhorgeProjectWireFieldsDto v) => v.description;
  static const Field<PhorgeProjectWireFieldsDto, Object> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );

  @override
  final MappableFields<PhorgeProjectWireFieldsDto> fields = const {
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

  static PhorgeProjectWireFieldsDto _instantiate(DecodingData data) {
    return PhorgeProjectWireFieldsDto(
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

  static PhorgeProjectWireFieldsDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeProjectWireFieldsDto>(map);
  }

  static PhorgeProjectWireFieldsDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeProjectWireFieldsDto>(json);
  }
}

mixin PhorgeProjectWireFieldsDtoMappable {
  String toJson() {
    return PhorgeProjectWireFieldsDtoMapper.ensureInitialized()
        .encodeJson<PhorgeProjectWireFieldsDto>(
          this as PhorgeProjectWireFieldsDto,
        );
  }

  Map<String, dynamic> toMap() {
    return PhorgeProjectWireFieldsDtoMapper.ensureInitialized()
        .encodeMap<PhorgeProjectWireFieldsDto>(
          this as PhorgeProjectWireFieldsDto,
        );
  }

  PhorgeProjectWireFieldsDtoCopyWith<
    PhorgeProjectWireFieldsDto,
    PhorgeProjectWireFieldsDto,
    PhorgeProjectWireFieldsDto
  >
  get copyWith =>
      _PhorgeProjectWireFieldsDtoCopyWithImpl<
        PhorgeProjectWireFieldsDto,
        PhorgeProjectWireFieldsDto
      >(this as PhorgeProjectWireFieldsDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeProjectWireFieldsDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeProjectWireFieldsDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeProjectWireFieldsDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeProjectWireFieldsDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeProjectWireFieldsDtoMapper.ensureInitialized().hashValue(
      this as PhorgeProjectWireFieldsDto,
    );
  }
}

extension PhorgeProjectWireFieldsDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeProjectWireFieldsDto, $Out> {
  PhorgeProjectWireFieldsDtoCopyWith<$R, PhorgeProjectWireFieldsDto, $Out>
  get $asPhorgeProjectWireFieldsDto => $base.as(
    (v, t, t2) => _PhorgeProjectWireFieldsDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeProjectWireFieldsDtoCopyWith<
  $R,
  $In extends PhorgeProjectWireFieldsDto,
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
  PhorgeProjectWireFieldsDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeProjectWireFieldsDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeProjectWireFieldsDto, $Out>
    implements
        PhorgeProjectWireFieldsDtoCopyWith<
          $R,
          PhorgeProjectWireFieldsDto,
          $Out
        > {
  _PhorgeProjectWireFieldsDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeProjectWireFieldsDto> $mapper =
      PhorgeProjectWireFieldsDtoMapper.ensureInitialized();
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
  PhorgeProjectWireFieldsDto $make(CopyWithData data) =>
      PhorgeProjectWireFieldsDto(
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
  PhorgeProjectWireFieldsDtoCopyWith<$R2, PhorgeProjectWireFieldsDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeProjectWireFieldsDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

