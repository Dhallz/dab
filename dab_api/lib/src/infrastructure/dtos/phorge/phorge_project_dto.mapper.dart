// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_project_dto.dart';

class PhorgeProjectDtoMapper extends ClassMapperBase<PhorgeProjectDto> {
  PhorgeProjectDtoMapper._();

  static PhorgeProjectDtoMapper? _instance;
  static PhorgeProjectDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeProjectDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeProjectDto';

  static int _$id(PhorgeProjectDto v) => v.id;
  static const Field<PhorgeProjectDto, int> _f$id = Field('id', _$id);
  static String _$phid(PhorgeProjectDto v) => v.phid;
  static const Field<PhorgeProjectDto, String> _f$phid = Field('phid', _$phid);
  static String _$name(PhorgeProjectDto v) => v.name;
  static const Field<PhorgeProjectDto, String> _f$name = Field('name', _$name);
  static String? _$color(PhorgeProjectDto v) => v.color;
  static const Field<PhorgeProjectDto, String> _f$color = Field(
    'color',
    _$color,
    opt: true,
  );
  static String? _$icon(PhorgeProjectDto v) => v.icon;
  static const Field<PhorgeProjectDto, String> _f$icon = Field(
    'icon',
    _$icon,
    opt: true,
  );

  @override
  final MappableFields<PhorgeProjectDto> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #name: _f$name,
    #color: _f$color,
    #icon: _f$icon,
  };

  static PhorgeProjectDto _instantiate(DecodingData data) {
    return PhorgeProjectDto(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      name: data.dec(_f$name),
      color: data.dec(_f$color),
      icon: data.dec(_f$icon),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeProjectDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeProjectDto>(map);
  }

  static PhorgeProjectDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeProjectDto>(json);
  }
}

mixin PhorgeProjectDtoMappable {
  String toJson() {
    return PhorgeProjectDtoMapper.ensureInitialized()
        .encodeJson<PhorgeProjectDto>(this as PhorgeProjectDto);
  }

  Map<String, dynamic> toMap() {
    return PhorgeProjectDtoMapper.ensureInitialized()
        .encodeMap<PhorgeProjectDto>(this as PhorgeProjectDto);
  }

  PhorgeProjectDtoCopyWith<PhorgeProjectDto, PhorgeProjectDto, PhorgeProjectDto>
  get copyWith =>
      _PhorgeProjectDtoCopyWithImpl<PhorgeProjectDto, PhorgeProjectDto>(
        this as PhorgeProjectDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhorgeProjectDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeProjectDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeProjectDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeProjectDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeProjectDtoMapper.ensureInitialized().hashValue(
      this as PhorgeProjectDto,
    );
  }
}

extension PhorgeProjectDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeProjectDto, $Out> {
  PhorgeProjectDtoCopyWith<$R, PhorgeProjectDto, $Out>
  get $asPhorgeProjectDto =>
      $base.as((v, t, t2) => _PhorgeProjectDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhorgeProjectDtoCopyWith<$R, $In extends PhorgeProjectDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? phid, String? name, String? color, String? icon});
  PhorgeProjectDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeProjectDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeProjectDto, $Out>
    implements PhorgeProjectDtoCopyWith<$R, PhorgeProjectDto, $Out> {
  _PhorgeProjectDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeProjectDto> $mapper =
      PhorgeProjectDtoMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? phid,
    String? name,
    Object? color = $none,
    Object? icon = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (name != null) #name: name,
      if (color != $none) #color: color,
      if (icon != $none) #icon: icon,
    }),
  );
  @override
  PhorgeProjectDto $make(CopyWithData data) => PhorgeProjectDto(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    name: data.get(#name, or: $value.name),
    color: data.get(#color, or: $value.color),
    icon: data.get(#icon, or: $value.icon),
  );

  @override
  PhorgeProjectDtoCopyWith<$R2, PhorgeProjectDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeProjectDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

