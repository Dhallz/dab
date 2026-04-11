// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'activity_provider.dart';

class ActivityProviderMapper extends ClassMapperBase<ActivityProvider> {
  ActivityProviderMapper._();

  static ActivityProviderMapper? _instance;
  static ActivityProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ActivityProviderMapper._());
      PhorgeTaskProviderMapper.ensureInitialized();
      PhorgeRevisionProviderMapper.ensureInitialized();
      GitHubCommitProviderMapper.ensureInitialized();
      GenericProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ActivityProvider';

  @override
  final MappableFields<ActivityProvider> fields = const {};

  static ActivityProvider _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('ActivityProvider');
  }

  @override
  final Function instantiate = _instantiate;

  static ActivityProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ActivityProvider>(map);
  }

  static ActivityProvider fromJson(String json) {
    return ensureInitialized().decodeJson<ActivityProvider>(json);
  }
}

mixin ActivityProviderMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ActivityProviderCopyWith<ActivityProvider, ActivityProvider, ActivityProvider>
  get copyWith;
}

abstract class ActivityProviderCopyWith<$R, $In extends ActivityProvider, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ActivityProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class PhorgeTaskProviderMapper extends ClassMapperBase<PhorgeTaskProvider> {
  PhorgeTaskProviderMapper._();

  static PhorgeTaskProviderMapper? _instance;
  static PhorgeTaskProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeTaskProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
      SprintContextMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeTaskProvider';

  static String? _$taskPhid(PhorgeTaskProvider v) => v.taskPhid;
  static const Field<PhorgeTaskProvider, String> _f$taskPhid = Field(
    'taskPhid',
    _$taskPhid,
    opt: true,
  );
  static String? _$tags(PhorgeTaskProvider v) => v.tags;
  static const Field<PhorgeTaskProvider, String> _f$tags = Field(
    'tags',
    _$tags,
    opt: true,
  );
  static SprintContext? _$sprintContext(PhorgeTaskProvider v) =>
      v.sprintContext;
  static const Field<PhorgeTaskProvider, SprintContext> _f$sprintContext =
      Field('sprintContext', _$sprintContext, opt: true);

  @override
  final MappableFields<PhorgeTaskProvider> fields = const {
    #taskPhid: _f$taskPhid,
    #tags: _f$tags,
    #sprintContext: _f$sprintContext,
  };

  static PhorgeTaskProvider _instantiate(DecodingData data) {
    return PhorgeTaskProvider(
      taskPhid: data.dec(_f$taskPhid),
      tags: data.dec(_f$tags),
      sprintContext: data.dec(_f$sprintContext),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeTaskProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeTaskProvider>(map);
  }

  static PhorgeTaskProvider fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeTaskProvider>(json);
  }
}

mixin PhorgeTaskProviderMappable {
  String toJson() {
    return PhorgeTaskProviderMapper.ensureInitialized()
        .encodeJson<PhorgeTaskProvider>(this as PhorgeTaskProvider);
  }

  Map<String, dynamic> toMap() {
    return PhorgeTaskProviderMapper.ensureInitialized()
        .encodeMap<PhorgeTaskProvider>(this as PhorgeTaskProvider);
  }

  PhorgeTaskProviderCopyWith<
    PhorgeTaskProvider,
    PhorgeTaskProvider,
    PhorgeTaskProvider
  >
  get copyWith =>
      _PhorgeTaskProviderCopyWithImpl<PhorgeTaskProvider, PhorgeTaskProvider>(
        this as PhorgeTaskProvider,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhorgeTaskProviderMapper.ensureInitialized().stringifyValue(
      this as PhorgeTaskProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeTaskProviderMapper.ensureInitialized().equalsValue(
      this as PhorgeTaskProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeTaskProviderMapper.ensureInitialized().hashValue(
      this as PhorgeTaskProvider,
    );
  }
}

extension PhorgeTaskProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeTaskProvider, $Out> {
  PhorgeTaskProviderCopyWith<$R, PhorgeTaskProvider, $Out>
  get $asPhorgeTaskProvider => $base.as(
    (v, t, t2) => _PhorgeTaskProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeTaskProviderCopyWith<
  $R,
  $In extends PhorgeTaskProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  SprintContextCopyWith<$R, SprintContext, SprintContext>? get sprintContext;
  @override
  $R call({String? taskPhid, String? tags, SprintContext? sprintContext});
  PhorgeTaskProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeTaskProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeTaskProvider, $Out>
    implements PhorgeTaskProviderCopyWith<$R, PhorgeTaskProvider, $Out> {
  _PhorgeTaskProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeTaskProvider> $mapper =
      PhorgeTaskProviderMapper.ensureInitialized();
  @override
  SprintContextCopyWith<$R, SprintContext, SprintContext>? get sprintContext =>
      $value.sprintContext?.copyWith.$chain((v) => call(sprintContext: v));
  @override
  $R call({
    Object? taskPhid = $none,
    Object? tags = $none,
    Object? sprintContext = $none,
  }) => $apply(
    FieldCopyWithData({
      if (taskPhid != $none) #taskPhid: taskPhid,
      if (tags != $none) #tags: tags,
      if (sprintContext != $none) #sprintContext: sprintContext,
    }),
  );
  @override
  PhorgeTaskProvider $make(CopyWithData data) => PhorgeTaskProvider(
    taskPhid: data.get(#taskPhid, or: $value.taskPhid),
    tags: data.get(#tags, or: $value.tags),
    sprintContext: data.get(#sprintContext, or: $value.sprintContext),
  );

  @override
  PhorgeTaskProviderCopyWith<$R2, PhorgeTaskProvider, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhorgeTaskProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PhorgeRevisionProviderMapper
    extends ClassMapperBase<PhorgeRevisionProvider> {
  PhorgeRevisionProviderMapper._();

  static PhorgeRevisionProviderMapper? _instance;
  static PhorgeRevisionProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhorgeRevisionProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhorgeRevisionProvider';

  static String? _$revisionId(PhorgeRevisionProvider v) => v.revisionId;
  static const Field<PhorgeRevisionProvider, String> _f$revisionId = Field(
    'revisionId',
    _$revisionId,
    opt: true,
  );

  @override
  final MappableFields<PhorgeRevisionProvider> fields = const {
    #revisionId: _f$revisionId,
  };

  static PhorgeRevisionProvider _instantiate(DecodingData data) {
    return PhorgeRevisionProvider(revisionId: data.dec(_f$revisionId));
  }

  @override
  final Function instantiate = _instantiate;

  static PhorgeRevisionProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhorgeRevisionProvider>(map);
  }

  static PhorgeRevisionProvider fromJson(String json) {
    return ensureInitialized().decodeJson<PhorgeRevisionProvider>(json);
  }
}

mixin PhorgeRevisionProviderMappable {
  String toJson() {
    return PhorgeRevisionProviderMapper.ensureInitialized()
        .encodeJson<PhorgeRevisionProvider>(this as PhorgeRevisionProvider);
  }

  Map<String, dynamic> toMap() {
    return PhorgeRevisionProviderMapper.ensureInitialized()
        .encodeMap<PhorgeRevisionProvider>(this as PhorgeRevisionProvider);
  }

  PhorgeRevisionProviderCopyWith<
    PhorgeRevisionProvider,
    PhorgeRevisionProvider,
    PhorgeRevisionProvider
  >
  get copyWith =>
      _PhorgeRevisionProviderCopyWithImpl<
        PhorgeRevisionProvider,
        PhorgeRevisionProvider
      >(this as PhorgeRevisionProvider, $identity, $identity);
  @override
  String toString() {
    return PhorgeRevisionProviderMapper.ensureInitialized().stringifyValue(
      this as PhorgeRevisionProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhorgeRevisionProviderMapper.ensureInitialized().equalsValue(
      this as PhorgeRevisionProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return PhorgeRevisionProviderMapper.ensureInitialized().hashValue(
      this as PhorgeRevisionProvider,
    );
  }
}

extension PhorgeRevisionProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhorgeRevisionProvider, $Out> {
  PhorgeRevisionProviderCopyWith<$R, PhorgeRevisionProvider, $Out>
  get $asPhorgeRevisionProvider => $base.as(
    (v, t, t2) => _PhorgeRevisionProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhorgeRevisionProviderCopyWith<
  $R,
  $In extends PhorgeRevisionProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({String? revisionId});
  PhorgeRevisionProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhorgeRevisionProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhorgeRevisionProvider, $Out>
    implements
        PhorgeRevisionProviderCopyWith<$R, PhorgeRevisionProvider, $Out> {
  _PhorgeRevisionProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhorgeRevisionProvider> $mapper =
      PhorgeRevisionProviderMapper.ensureInitialized();
  @override
  $R call({Object? revisionId = $none}) => $apply(
    FieldCopyWithData({if (revisionId != $none) #revisionId: revisionId}),
  );
  @override
  PhorgeRevisionProvider $make(CopyWithData data) => PhorgeRevisionProvider(
    revisionId: data.get(#revisionId, or: $value.revisionId),
  );

  @override
  PhorgeRevisionProviderCopyWith<$R2, PhorgeRevisionProvider, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PhorgeRevisionProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class GitHubCommitProviderMapper extends ClassMapperBase<GitHubCommitProvider> {
  GitHubCommitProviderMapper._();

  static GitHubCommitProviderMapper? _instance;
  static GitHubCommitProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GitHubCommitProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GitHubCommitProvider';

  static String? _$repo(GitHubCommitProvider v) => v.repo;
  static const Field<GitHubCommitProvider, String> _f$repo = Field(
    'repo',
    _$repo,
    opt: true,
  );
  static String? _$branch(GitHubCommitProvider v) => v.branch;
  static const Field<GitHubCommitProvider, String> _f$branch = Field(
    'branch',
    _$branch,
    opt: true,
  );

  @override
  final MappableFields<GitHubCommitProvider> fields = const {
    #repo: _f$repo,
    #branch: _f$branch,
  };

  static GitHubCommitProvider _instantiate(DecodingData data) {
    return GitHubCommitProvider(
      repo: data.dec(_f$repo),
      branch: data.dec(_f$branch),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GitHubCommitProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GitHubCommitProvider>(map);
  }

  static GitHubCommitProvider fromJson(String json) {
    return ensureInitialized().decodeJson<GitHubCommitProvider>(json);
  }
}

mixin GitHubCommitProviderMappable {
  String toJson() {
    return GitHubCommitProviderMapper.ensureInitialized()
        .encodeJson<GitHubCommitProvider>(this as GitHubCommitProvider);
  }

  Map<String, dynamic> toMap() {
    return GitHubCommitProviderMapper.ensureInitialized()
        .encodeMap<GitHubCommitProvider>(this as GitHubCommitProvider);
  }

  GitHubCommitProviderCopyWith<
    GitHubCommitProvider,
    GitHubCommitProvider,
    GitHubCommitProvider
  >
  get copyWith =>
      _GitHubCommitProviderCopyWithImpl<
        GitHubCommitProvider,
        GitHubCommitProvider
      >(this as GitHubCommitProvider, $identity, $identity);
  @override
  String toString() {
    return GitHubCommitProviderMapper.ensureInitialized().stringifyValue(
      this as GitHubCommitProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return GitHubCommitProviderMapper.ensureInitialized().equalsValue(
      this as GitHubCommitProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return GitHubCommitProviderMapper.ensureInitialized().hashValue(
      this as GitHubCommitProvider,
    );
  }
}

extension GitHubCommitProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GitHubCommitProvider, $Out> {
  GitHubCommitProviderCopyWith<$R, GitHubCommitProvider, $Out>
  get $asGitHubCommitProvider => $base.as(
    (v, t, t2) => _GitHubCommitProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class GitHubCommitProviderCopyWith<
  $R,
  $In extends GitHubCommitProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({String? repo, String? branch});
  GitHubCommitProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GitHubCommitProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GitHubCommitProvider, $Out>
    implements GitHubCommitProviderCopyWith<$R, GitHubCommitProvider, $Out> {
  _GitHubCommitProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GitHubCommitProvider> $mapper =
      GitHubCommitProviderMapper.ensureInitialized();
  @override
  $R call({Object? repo = $none, Object? branch = $none}) => $apply(
    FieldCopyWithData({
      if (repo != $none) #repo: repo,
      if (branch != $none) #branch: branch,
    }),
  );
  @override
  GitHubCommitProvider $make(CopyWithData data) => GitHubCommitProvider(
    repo: data.get(#repo, or: $value.repo),
    branch: data.get(#branch, or: $value.branch),
  );

  @override
  GitHubCommitProviderCopyWith<$R2, GitHubCommitProvider, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GitHubCommitProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class GenericProviderMapper extends ClassMapperBase<GenericProvider> {
  GenericProviderMapper._();

  static GenericProviderMapper? _instance;
  static GenericProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GenericProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GenericProvider';

  static String _$name(GenericProvider v) => v.name;
  static const Field<GenericProvider, String> _f$name = Field('name', _$name);
  static String _$category(GenericProvider v) => v.category;
  static const Field<GenericProvider, String> _f$category = Field(
    'category',
    _$category,
    opt: true,
    def: 'generic',
  );

  @override
  final MappableFields<GenericProvider> fields = const {
    #name: _f$name,
    #category: _f$category,
  };

  static GenericProvider _instantiate(DecodingData data) {
    return GenericProvider(
      name: data.dec(_f$name),
      category: data.dec(_f$category),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GenericProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GenericProvider>(map);
  }

  static GenericProvider fromJson(String json) {
    return ensureInitialized().decodeJson<GenericProvider>(json);
  }
}

mixin GenericProviderMappable {
  String toJson() {
    return GenericProviderMapper.ensureInitialized()
        .encodeJson<GenericProvider>(this as GenericProvider);
  }

  Map<String, dynamic> toMap() {
    return GenericProviderMapper.ensureInitialized().encodeMap<GenericProvider>(
      this as GenericProvider,
    );
  }

  GenericProviderCopyWith<GenericProvider, GenericProvider, GenericProvider>
  get copyWith =>
      _GenericProviderCopyWithImpl<GenericProvider, GenericProvider>(
        this as GenericProvider,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return GenericProviderMapper.ensureInitialized().stringifyValue(
      this as GenericProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return GenericProviderMapper.ensureInitialized().equalsValue(
      this as GenericProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return GenericProviderMapper.ensureInitialized().hashValue(
      this as GenericProvider,
    );
  }
}

extension GenericProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GenericProvider, $Out> {
  GenericProviderCopyWith<$R, GenericProvider, $Out> get $asGenericProvider =>
      $base.as((v, t, t2) => _GenericProviderCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GenericProviderCopyWith<$R, $In extends GenericProvider, $Out>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({String? name, String? category});
  GenericProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GenericProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GenericProvider, $Out>
    implements GenericProviderCopyWith<$R, GenericProvider, $Out> {
  _GenericProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GenericProvider> $mapper =
      GenericProviderMapper.ensureInitialized();
  @override
  $R call({String? name, String? category}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (category != null) #category: category,
    }),
  );
  @override
  GenericProvider $make(CopyWithData data) => GenericProvider(
    name: data.get(#name, or: $value.name),
    category: data.get(#category, or: $value.category),
  );

  @override
  GenericProviderCopyWith<$R2, GenericProvider, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _GenericProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

