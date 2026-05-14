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
      PhorgeProjectWireFieldsDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeProjectDto';

  static int _$id(PhorgeProjectDto v) => v.id;
  static const Field<PhorgeProjectDto, int> _f$id = Field('id', _$id);
  static String _$phid(PhorgeProjectDto v) => v.phid;
  static const Field<PhorgeProjectDto, String> _f$phid = Field('phid', _$phid);
  static PhorgeProjectWireFieldsDto _$fields(PhorgeProjectDto v) => v.fields;
  static const Field<PhorgeProjectDto, PhorgeProjectWireFieldsDto> _f$fields =
      Field('fields', _$fields);
  static Map<String, dynamic>? _$attachments(PhorgeProjectDto v) =>
      v.attachments;
  static const Field<PhorgeProjectDto, Map<String, dynamic>> _f$attachments =
      Field('attachments', _$attachments, opt: true);

  @override
  final MappableFields<PhorgeProjectDto> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #fields: _f$fields,
    #attachments: _f$attachments,
  };

  static PhorgeProjectDto _instantiate(DecodingData data) {
    return PhorgeProjectDto(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      fields: data.dec(_f$fields),
      attachments: data.dec(_f$attachments),
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
  PhorgeProjectWireFieldsDtoCopyWith<
    $R,
    PhorgeProjectWireFieldsDto,
    PhorgeProjectWireFieldsDto
  >
  get fields;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get attachments;
  $R call({
    int? id,
    String? phid,
    PhorgeProjectWireFieldsDto? fields,
    Map<String, dynamic>? attachments,
  });
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
  PhorgeProjectWireFieldsDtoCopyWith<
    $R,
    PhorgeProjectWireFieldsDto,
    PhorgeProjectWireFieldsDto
  >
  get fields => $value.fields.copyWith.$chain((v) => call(fields: v));
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get attachments => $value.attachments != null
      ? MapCopyWith(
          $value.attachments!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(attachments: v),
        )
      : null;
  @override
  $R call({
    int? id,
    String? phid,
    PhorgeProjectWireFieldsDto? fields,
    Object? attachments = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (phid != null) #phid: phid,
      if (fields != null) #fields: fields,
      if (attachments != $none) #attachments: attachments,
    }),
  );
  @override
  PhorgeProjectDto $make(CopyWithData data) => PhorgeProjectDto(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    fields: data.get(#fields, or: $value.fields),
    attachments: data.get(#attachments, or: $value.attachments),
  );

  @override
  PhorgeProjectDtoCopyWith<$R2, PhorgeProjectDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeProjectDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

