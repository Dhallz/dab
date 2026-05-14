// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_data.dart';

class PhorgeTaskDataMapper extends ClassMapperBase<PhorgeTaskData> {
  PhorgeTaskDataMapper._();

  static PhorgeTaskDataMapper? _instance;
  static PhorgeTaskDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTaskDataMapper._());
      PhorgeTaskWireFieldsMapper.ensureInitialized();
      PhorgeTaskWireAttachmentsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskData';

  static int _$id(PhorgeTaskData v) => v.id;
  static const Field<PhorgeTaskData, int> _f$id = Field(
    'id',
    _$id,
    hook: PhorgeTaskWireIntHook(),
  );
  static String _$phid(PhorgeTaskData v) => v.phid;
  static const Field<PhorgeTaskData, String> _f$phid = Field(
    'phid',
    _$phid,
    hook: PhorgeTaskWireDefaultStringHook(''),
  );
  static PhorgeTaskWireFields _$fields(PhorgeTaskData v) => v.fields;
  static const Field<PhorgeTaskData, PhorgeTaskWireFields> _f$fields = Field(
    'fields',
    _$fields,
  );
  static PhorgeTaskWireAttachments? _$attachments(PhorgeTaskData v) =>
      v.attachments;
  static const Field<PhorgeTaskData, PhorgeTaskWireAttachments> _f$attachments =
      Field('attachments', _$attachments, opt: true);

  @override
  final MappableFields<PhorgeTaskData> fields = const {
    #id: _f$id,
    #phid: _f$phid,
    #fields: _f$fields,
    #attachments: _f$attachments,
  };

  static PhorgeTaskData _instantiate(DecodingData data) {
    return PhorgeTaskData(
      id: data.dec(_f$id),
      phid: data.dec(_f$phid),
      fields: data.dec(_f$fields),
      attachments: data.dec(_f$attachments),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskData>(map);
  }

  static PhorgeTaskData fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskData>(json);
  }
}

mixin PhorgeTaskDataMappable {
  String toJson() {
    return PhorgeTaskDataMapper.ensureInitialized().encodeJson<PhorgeTaskData>(
      this as PhorgeTaskData,
    );
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskDataMapper.ensureInitialized().encodeMap<PhorgeTaskData>(
      this as PhorgeTaskData,
    );
  }

  PhorgeTaskDataCopyWith<PhorgeTaskData, PhorgeTaskData, PhorgeTaskData>
  get copyWith => _PhorgeTaskDataCopyWithImpl<PhorgeTaskData, PhorgeTaskData>(
    this as PhorgeTaskData,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PhorgeTaskDataMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskData,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskDataMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskData,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskDataMapper.ensureInitialized().hashValue(
      this as PhorgeTaskData,
    );
  }
}

extension PhorgeTaskDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskData, $Out> {
  PhorgeTaskDataCopyWith<$R, PhorgeTaskData, $Out> get $asPhorgeTaskData =>
      $base.as((v, t, t2) => _PhorgeTaskDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhorgeTaskDataCopyWith<$R, $In extends PhorgeTaskData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeTaskWireFieldsCopyWith<$R, PhorgeTaskWireFields, PhorgeTaskWireFields>
  get fields;
  PhorgeTaskWireAttachmentsCopyWith<
    $R,
    PhorgeTaskWireAttachments,
    PhorgeTaskWireAttachments
  >?
  get attachments;
  $R call({
    int? id,
    String? phid,
    PhorgeTaskWireFields? fields,
    PhorgeTaskWireAttachments? attachments,
  });
  PhorgeTaskDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskData, $Out>
    implements PhorgeTaskDataCopyWith<$R, PhorgeTaskData, $Out> {
  _PhorgeTaskDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskData> $mapper =
      PhorgeTaskDataMapper.ensureInitialized();
  @override
  PhorgeTaskWireFieldsCopyWith<$R, PhorgeTaskWireFields, PhorgeTaskWireFields>
  get fields => $value.fields.copyWith.$chain((v) => call(fields: v));
  @override
  PhorgeTaskWireAttachmentsCopyWith<
    $R,
    PhorgeTaskWireAttachments,
    PhorgeTaskWireAttachments
  >?
  get attachments =>
      $value.attachments?.copyWith.$chain((v) => call(attachments: v));
  @override
  $R call({
    int? id,
    String? phid,
    PhorgeTaskWireFields? fields,
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
  PhorgeTaskData $make(CopyWithData data) => PhorgeTaskData(
    id: data.get(#id, or: $value.id),
    phid: data.get(#phid, or: $value.phid),
    fields: data.get(#fields, or: $value.fields),
    attachments: data.get(#attachments, or: $value.attachments),
  );

  @override
  PhorgeTaskDataCopyWith<$R2, PhorgeTaskData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeTaskDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

