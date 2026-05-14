// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phorge_task_bundle_dto.dart';

class PhorgeTaskBundleDtoMapper extends ClassMapperBase<PhorgeTaskBundleDto> {
  PhorgeTaskBundleDtoMapper._();

  static PhorgeTaskBundleDtoMapper? _instance;
  static PhorgeTaskBundleDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTaskBundleDtoMapper._());
      PhorgeTaskDtoMapper.ensureInitialized();
      PhorgeTransactionDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskBundleDto';

  static PhorgeTaskDto _$task(PhorgeTaskBundleDto v) => v.task;
  static const Field<PhorgeTaskBundleDto, PhorgeTaskDto> _f$task = Field(
    'task',
    _$task,
  );
  static List<PhorgeTransactionDto> _$transactions(PhorgeTaskBundleDto v) =>
      v.transactions;
  static const Field<PhorgeTaskBundleDto, List<PhorgeTransactionDto>>
  _f$transactions = Field('transactions', _$transactions);
  static String _$sprintTag(PhorgeTaskBundleDto v) => v.sprintTag;
  static const Field<PhorgeTaskBundleDto, String> _f$sprintTag = Field(
    'sprintTag',
    _$sprintTag,
  );

  @override
  final MappableFields<PhorgeTaskBundleDto> fields = const {
    #task: _f$task,
    #transactions: _f$transactions,
    #sprintTag: _f$sprintTag,
  };

  static PhorgeTaskBundleDto _instantiate(DecodingData data) {
    return PhorgeTaskBundleDto(
      task: data.dec(_f$task),
      transactions: data.dec(_f$transactions),
      sprintTag: data.dec(_f$sprintTag),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskBundleDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskBundleDto>(map);
  }

  static PhorgeTaskBundleDto fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskBundleDto>(json);
  }
}

mixin PhorgeTaskBundleDtoMappable {
  String toJson() {
    return PhorgeTaskBundleDtoMapper.ensureInitialized()
        .encodeJson<PhorgeTaskBundleDto>(this as PhorgeTaskBundleDto);
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskBundleDtoMapper.ensureInitialized()
        .encodeMap<PhorgeTaskBundleDto>(this as PhorgeTaskBundleDto);
  }

  PhorgeTaskBundleDtoCopyWith<
    PhorgeTaskBundleDto,
    PhorgeTaskBundleDto,
    PhorgeTaskBundleDto
  >
  get copyWith =>
      _PhorgeTaskBundleDtoCopyWithImpl<
        PhorgeTaskBundleDto,
        PhorgeTaskBundleDto
      >(this as PhorgeTaskBundleDto, $identity, $identity);
  @override
  String toString() {
    return PhorgeTaskBundleDtoMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskBundleDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskBundleDtoMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskBundleDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskBundleDtoMapper.ensureInitialized().hashValue(
      this as PhorgeTaskBundleDto,
    );
  }
}

extension PhorgeTaskBundleDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskBundleDto, $Out> {
  PhorgeTaskBundleDtoCopyWith<$R, PhorgeTaskBundleDto, $Out>
  get $asPhorgeTaskBundleDto => $base.as(
    (v, t, t2) => _PhorgeTaskBundleDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskBundleDtoCopyWith<
  $R,
  $In extends PhorgeTaskBundleDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PhorgeTaskDtoCopyWith<$R, PhorgeTaskDto, PhorgeTaskDto> get task;
  ListCopyWith<
    $R,
    PhorgeTransactionDto,
    PhorgeTransactionDtoCopyWith<$R, PhorgeTransactionDto, PhorgeTransactionDto>
  >
  get transactions;
  $R call({
    PhorgeTaskDto? task,
    List<PhorgeTransactionDto>? transactions,
    String? sprintTag,
  });
  PhorgeTaskBundleDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskBundleDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskBundleDto, $Out>
    implements PhorgeTaskBundleDtoCopyWith<$R, PhorgeTaskBundleDto, $Out> {
  _PhorgeTaskBundleDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskBundleDto> $mapper =
      PhorgeTaskBundleDtoMapper.ensureInitialized();
  @override
  PhorgeTaskDtoCopyWith<$R, PhorgeTaskDto, PhorgeTaskDto> get task =>
      $value.task.copyWith.$chain((v) => call(task: v));
  @override
  ListCopyWith<
    $R,
    PhorgeTransactionDto,
    PhorgeTransactionDtoCopyWith<$R, PhorgeTransactionDto, PhorgeTransactionDto>
  >
  get transactions => ListCopyWith(
    $value.transactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(transactions: v),
  );
  @override
  $R call({
    PhorgeTaskDto? task,
    List<PhorgeTransactionDto>? transactions,
    String? sprintTag,
  }) => $apply(
    FieldCopyWithData({
      if (task != null) #task: task,
      if (transactions != null) #transactions: transactions,
      if (sprintTag != null) #sprintTag: sprintTag,
    }),
  );
  @override
  PhorgeTaskBundleDto $make(CopyWithData data) => PhorgeTaskBundleDto(
    task: data.get(#task, or: $value.task),
    transactions: data.get(#transactions, or: $value.transactions),
    sprintTag: data.get(#sprintTag, or: $value.sprintTag),
  );

  @override
  PhorgeTaskBundleDtoCopyWith<$R2, PhorgeTaskBundleDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeTaskBundleDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

