// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sprint_context.dart';

class SprintContextMapper extends ClassMapperBase<SprintContext> {
  SprintContextMapper._();

  static SprintContextMapper? _instance;
  static SprintContextMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SprintContextMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SprintContext';

  static String _$tag(SprintContext v) => v.tag;
  static const Field<SprintContext, String> _f$tag = Field('tag', _$tag);
  static String? _$columnFrom(SprintContext v) => v.columnFrom;
  static const Field<SprintContext, String> _f$columnFrom = Field(
    'columnFrom',
    _$columnFrom,
    opt: true,
  );
  static String? _$columnTo(SprintContext v) => v.columnTo;
  static const Field<SprintContext, String> _f$columnTo = Field(
    'columnTo',
    _$columnTo,
    opt: true,
  );

  @override
  final MappableFields<SprintContext> fields = const {
    #tag: _f$tag,
    #columnFrom: _f$columnFrom,
    #columnTo: _f$columnTo,
  };

  static SprintContext _instantiate(DecodingData data) {
    return SprintContext(
      tag: data.dec(_f$tag),
      columnFrom: data.dec(_f$columnFrom),
      columnTo: data.dec(_f$columnTo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SprintContext fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SprintContext>(map);
  }

  static SprintContext fromJson(String json) {
    return ensureInitialized().decodeJson<SprintContext>(json);
  }
}

mixin SprintContextMappable {
  String toJson() {
    return SprintContextMapper.ensureInitialized().encodeJson<SprintContext>(
      this as SprintContext,
    );
  }

  Map<String, dynamic> toMap() {
    return SprintContextMapper.ensureInitialized().encodeMap<SprintContext>(
      this as SprintContext,
    );
  }

  SprintContextCopyWith<SprintContext, SprintContext, SprintContext>
  get copyWith => _SprintContextCopyWithImpl<SprintContext, SprintContext>(
    this as SprintContext,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SprintContextMapper.ensureInitialized().stringifyValue(
      this as SprintContext,
    );
  }

  @override
  bool operator ==(Object other) {
    return SprintContextMapper.ensureInitialized().equalsValue(
      this as SprintContext,
      other,
    );
  }

  @override
  int get hashCode {
    return SprintContextMapper.ensureInitialized().hashValue(
      this as SprintContext,
    );
  }
}

extension SprintContextValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SprintContext, $Out> {
  SprintContextCopyWith<$R, SprintContext, $Out> get $asSprintContext =>
      $base.as((v, t, t2) => _SprintContextCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SprintContextCopyWith<$R, $In extends SprintContext, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? tag, String? columnFrom, String? columnTo});
  SprintContextCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SprintContextCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SprintContext, $Out>
    implements SprintContextCopyWith<$R, SprintContext, $Out> {
  _SprintContextCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SprintContext> $mapper =
      SprintContextMapper.ensureInitialized();
  @override
  $R call({
    String? tag,
    Object? columnFrom = $none,
    Object? columnTo = $none,
  }) => $apply(
    FieldCopyWithData({
      if (tag != null) #tag: tag,
      if (columnFrom != $none) #columnFrom: columnFrom,
      if (columnTo != $none) #columnTo: columnTo,
    }),
  );
  @override
  SprintContext $make(CopyWithData data) => SprintContext(
    tag: data.get(#tag, or: $value.tag),
    columnFrom: data.get(#columnFrom, or: $value.columnFrom),
    columnTo: data.get(#columnTo, or: $value.columnTo),
  );

  @override
  SprintContextCopyWith<$R2, SprintContext, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SprintContextCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

