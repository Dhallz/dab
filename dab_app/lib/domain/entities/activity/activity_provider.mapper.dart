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
      JiraIssueProviderMapper.ensureInitialized();
      GitLabCommitProviderMapper.ensureInitialized();
      BitbucketCommitProviderMapper.ensureInitialized();
      LinearIssueProviderMapper.ensureInitialized();
      DiscordMessageProviderMapper.ensureInitialized();
      SlackMessageProviderMapper.ensureInitialized();
      FigmaFileProviderMapper.ensureInitialized();
      GenericProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ActivityProvider';

  static String _$name(ActivityProvider v) => v.name;
  static const Field<ActivityProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(ActivityProvider v) => v.category;
  static const Field<ActivityProvider, ActivityCategory> _f$category = Field(
    'category',
    _$category,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ActivityProvider> fields = const {
    #name: _f$name,
    #category: _f$category,
  };

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
  static String _$name(PhorgeTaskProvider v) => v.name;
  static const Field<PhorgeTaskProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(PhorgeTaskProvider v) => v.category;
  static const Field<PhorgeTaskProvider, ActivityCategory> _f$category = Field(
    'category',
    _$category,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<PhorgeTaskProvider> fields = const {
    #taskPhid: _f$taskPhid,
    #tags: _f$tags,
    #sprintContext: _f$sprintContext,
    #name: _f$name,
    #category: _f$category,
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
  static String _$name(PhorgeRevisionProvider v) => v.name;
  static const Field<PhorgeRevisionProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(PhorgeRevisionProvider v) => v.category;
  static const Field<PhorgeRevisionProvider, ActivityCategory> _f$category =
      Field('category', _$category, mode: FieldMode.member);

  @override
  final MappableFields<PhorgeRevisionProvider> fields = const {
    #revisionId: _f$revisionId,
    #name: _f$name,
    #category: _f$category,
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
  static String _$name(GitHubCommitProvider v) => v.name;
  static const Field<GitHubCommitProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(GitHubCommitProvider v) => v.category;
  static const Field<GitHubCommitProvider, ActivityCategory> _f$category =
      Field('category', _$category, mode: FieldMode.member);

  @override
  final MappableFields<GitHubCommitProvider> fields = const {
    #repo: _f$repo,
    #branch: _f$branch,
    #name: _f$name,
    #category: _f$category,
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

class JiraIssueProviderMapper extends ClassMapperBase<JiraIssueProvider> {
  JiraIssueProviderMapper._();

  static JiraIssueProviderMapper? _instance;
  static JiraIssueProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JiraIssueProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'JiraIssueProvider';

  static String? _$issueKey(JiraIssueProvider v) => v.issueKey;
  static const Field<JiraIssueProvider, String> _f$issueKey = Field(
    'issueKey',
    _$issueKey,
    opt: true,
  );
  static String? _$projectKey(JiraIssueProvider v) => v.projectKey;
  static const Field<JiraIssueProvider, String> _f$projectKey = Field(
    'projectKey',
    _$projectKey,
    opt: true,
  );
  static String? _$statusName(JiraIssueProvider v) => v.statusName;
  static const Field<JiraIssueProvider, String> _f$statusName = Field(
    'statusName',
    _$statusName,
    opt: true,
  );
  static String _$name(JiraIssueProvider v) => v.name;
  static const Field<JiraIssueProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(JiraIssueProvider v) => v.category;
  static const Field<JiraIssueProvider, ActivityCategory> _f$category = Field(
    'category',
    _$category,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<JiraIssueProvider> fields = const {
    #issueKey: _f$issueKey,
    #projectKey: _f$projectKey,
    #statusName: _f$statusName,
    #name: _f$name,
    #category: _f$category,
  };

  static JiraIssueProvider _instantiate(DecodingData data) {
    return JiraIssueProvider(
      issueKey: data.dec(_f$issueKey),
      projectKey: data.dec(_f$projectKey),
      statusName: data.dec(_f$statusName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JiraIssueProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JiraIssueProvider>(map);
  }

  static JiraIssueProvider fromJson(String json) {
    return ensureInitialized().decodeJson<JiraIssueProvider>(json);
  }
}

mixin JiraIssueProviderMappable {
  String toJson() {
    return JiraIssueProviderMapper.ensureInitialized()
        .encodeJson<JiraIssueProvider>(this as JiraIssueProvider);
  }

  Map<String, dynamic> toMap() {
    return JiraIssueProviderMapper.ensureInitialized()
        .encodeMap<JiraIssueProvider>(this as JiraIssueProvider);
  }

  JiraIssueProviderCopyWith<
    JiraIssueProvider,
    JiraIssueProvider,
    JiraIssueProvider
  >
  get copyWith =>
      _JiraIssueProviderCopyWithImpl<JiraIssueProvider, JiraIssueProvider>(
        this as JiraIssueProvider,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return JiraIssueProviderMapper.ensureInitialized().stringifyValue(
      this as JiraIssueProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return JiraIssueProviderMapper.ensureInitialized().equalsValue(
      this as JiraIssueProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return JiraIssueProviderMapper.ensureInitialized().hashValue(
      this as JiraIssueProvider,
    );
  }
}

extension JiraIssueProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JiraIssueProvider, $Out> {
  JiraIssueProviderCopyWith<$R, JiraIssueProvider, $Out>
  get $asJiraIssueProvider => $base.as(
    (v, t, t2) => _JiraIssueProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class JiraIssueProviderCopyWith<
  $R,
  $In extends JiraIssueProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({String? issueKey, String? projectKey, String? statusName});
  JiraIssueProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _JiraIssueProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JiraIssueProvider, $Out>
    implements JiraIssueProviderCopyWith<$R, JiraIssueProvider, $Out> {
  _JiraIssueProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JiraIssueProvider> $mapper =
      JiraIssueProviderMapper.ensureInitialized();
  @override
  $R call({
    Object? issueKey = $none,
    Object? projectKey = $none,
    Object? statusName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (issueKey != $none) #issueKey: issueKey,
      if (projectKey != $none) #projectKey: projectKey,
      if (statusName != $none) #statusName: statusName,
    }),
  );
  @override
  JiraIssueProvider $make(CopyWithData data) => JiraIssueProvider(
    issueKey: data.get(#issueKey, or: $value.issueKey),
    projectKey: data.get(#projectKey, or: $value.projectKey),
    statusName: data.get(#statusName, or: $value.statusName),
  );

  @override
  JiraIssueProviderCopyWith<$R2, JiraIssueProvider, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _JiraIssueProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class GitLabCommitProviderMapper extends ClassMapperBase<GitLabCommitProvider> {
  GitLabCommitProviderMapper._();

  static GitLabCommitProviderMapper? _instance;
  static GitLabCommitProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GitLabCommitProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GitLabCommitProvider';

  static String? _$project(GitLabCommitProvider v) => v.project;
  static const Field<GitLabCommitProvider, String> _f$project = Field(
    'project',
    _$project,
    opt: true,
  );
  static String? _$branch(GitLabCommitProvider v) => v.branch;
  static const Field<GitLabCommitProvider, String> _f$branch = Field(
    'branch',
    _$branch,
    opt: true,
  );
  static String _$name(GitLabCommitProvider v) => v.name;
  static const Field<GitLabCommitProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(GitLabCommitProvider v) => v.category;
  static const Field<GitLabCommitProvider, ActivityCategory> _f$category =
      Field('category', _$category, mode: FieldMode.member);

  @override
  final MappableFields<GitLabCommitProvider> fields = const {
    #project: _f$project,
    #branch: _f$branch,
    #name: _f$name,
    #category: _f$category,
  };

  static GitLabCommitProvider _instantiate(DecodingData data) {
    return GitLabCommitProvider(
      project: data.dec(_f$project),
      branch: data.dec(_f$branch),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GitLabCommitProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GitLabCommitProvider>(map);
  }

  static GitLabCommitProvider fromJson(String json) {
    return ensureInitialized().decodeJson<GitLabCommitProvider>(json);
  }
}

mixin GitLabCommitProviderMappable {
  String toJson() {
    return GitLabCommitProviderMapper.ensureInitialized()
        .encodeJson<GitLabCommitProvider>(this as GitLabCommitProvider);
  }

  Map<String, dynamic> toMap() {
    return GitLabCommitProviderMapper.ensureInitialized()
        .encodeMap<GitLabCommitProvider>(this as GitLabCommitProvider);
  }

  GitLabCommitProviderCopyWith<
    GitLabCommitProvider,
    GitLabCommitProvider,
    GitLabCommitProvider
  >
  get copyWith =>
      _GitLabCommitProviderCopyWithImpl<
        GitLabCommitProvider,
        GitLabCommitProvider
      >(this as GitLabCommitProvider, $identity, $identity);
  @override
  String toString() {
    return GitLabCommitProviderMapper.ensureInitialized().stringifyValue(
      this as GitLabCommitProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return GitLabCommitProviderMapper.ensureInitialized().equalsValue(
      this as GitLabCommitProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return GitLabCommitProviderMapper.ensureInitialized().hashValue(
      this as GitLabCommitProvider,
    );
  }
}

extension GitLabCommitProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GitLabCommitProvider, $Out> {
  GitLabCommitProviderCopyWith<$R, GitLabCommitProvider, $Out>
  get $asGitLabCommitProvider => $base.as(
    (v, t, t2) => _GitLabCommitProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class GitLabCommitProviderCopyWith<
  $R,
  $In extends GitLabCommitProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({String? project, String? branch});
  GitLabCommitProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GitLabCommitProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GitLabCommitProvider, $Out>
    implements GitLabCommitProviderCopyWith<$R, GitLabCommitProvider, $Out> {
  _GitLabCommitProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GitLabCommitProvider> $mapper =
      GitLabCommitProviderMapper.ensureInitialized();
  @override
  $R call({Object? project = $none, Object? branch = $none}) => $apply(
    FieldCopyWithData({
      if (project != $none) #project: project,
      if (branch != $none) #branch: branch,
    }),
  );
  @override
  GitLabCommitProvider $make(CopyWithData data) => GitLabCommitProvider(
    project: data.get(#project, or: $value.project),
    branch: data.get(#branch, or: $value.branch),
  );

  @override
  GitLabCommitProviderCopyWith<$R2, GitLabCommitProvider, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GitLabCommitProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BitbucketCommitProviderMapper
    extends ClassMapperBase<BitbucketCommitProvider> {
  BitbucketCommitProviderMapper._();

  static BitbucketCommitProviderMapper? _instance;
  static BitbucketCommitProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = BitbucketCommitProviderMapper._(),
      );
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BitbucketCommitProvider';

  static String? _$repo(BitbucketCommitProvider v) => v.repo;
  static const Field<BitbucketCommitProvider, String> _f$repo = Field(
    'repo',
    _$repo,
    opt: true,
  );
  static String? _$branch(BitbucketCommitProvider v) => v.branch;
  static const Field<BitbucketCommitProvider, String> _f$branch = Field(
    'branch',
    _$branch,
    opt: true,
  );
  static String _$name(BitbucketCommitProvider v) => v.name;
  static const Field<BitbucketCommitProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(BitbucketCommitProvider v) => v.category;
  static const Field<BitbucketCommitProvider, ActivityCategory> _f$category =
      Field('category', _$category, mode: FieldMode.member);

  @override
  final MappableFields<BitbucketCommitProvider> fields = const {
    #repo: _f$repo,
    #branch: _f$branch,
    #name: _f$name,
    #category: _f$category,
  };

  static BitbucketCommitProvider _instantiate(DecodingData data) {
    return BitbucketCommitProvider(
      repo: data.dec(_f$repo),
      branch: data.dec(_f$branch),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BitbucketCommitProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BitbucketCommitProvider>(map);
  }

  static BitbucketCommitProvider fromJson(String json) {
    return ensureInitialized().decodeJson<BitbucketCommitProvider>(json);
  }
}

mixin BitbucketCommitProviderMappable {
  String toJson() {
    return BitbucketCommitProviderMapper.ensureInitialized()
        .encodeJson<BitbucketCommitProvider>(this as BitbucketCommitProvider);
  }

  Map<String, dynamic> toMap() {
    return BitbucketCommitProviderMapper.ensureInitialized()
        .encodeMap<BitbucketCommitProvider>(this as BitbucketCommitProvider);
  }

  BitbucketCommitProviderCopyWith<
    BitbucketCommitProvider,
    BitbucketCommitProvider,
    BitbucketCommitProvider
  >
  get copyWith =>
      _BitbucketCommitProviderCopyWithImpl<
        BitbucketCommitProvider,
        BitbucketCommitProvider
      >(this as BitbucketCommitProvider, $identity, $identity);
  @override
  String toString() {
    return BitbucketCommitProviderMapper.ensureInitialized().stringifyValue(
      this as BitbucketCommitProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return BitbucketCommitProviderMapper.ensureInitialized().equalsValue(
      this as BitbucketCommitProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return BitbucketCommitProviderMapper.ensureInitialized().hashValue(
      this as BitbucketCommitProvider,
    );
  }
}

extension BitbucketCommitProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BitbucketCommitProvider, $Out> {
  BitbucketCommitProviderCopyWith<$R, BitbucketCommitProvider, $Out>
  get $asBitbucketCommitProvider => $base.as(
    (v, t, t2) => _BitbucketCommitProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class BitbucketCommitProviderCopyWith<
  $R,
  $In extends BitbucketCommitProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({String? repo, String? branch});
  BitbucketCommitProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BitbucketCommitProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BitbucketCommitProvider, $Out>
    implements
        BitbucketCommitProviderCopyWith<$R, BitbucketCommitProvider, $Out> {
  _BitbucketCommitProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BitbucketCommitProvider> $mapper =
      BitbucketCommitProviderMapper.ensureInitialized();
  @override
  $R call({Object? repo = $none, Object? branch = $none}) => $apply(
    FieldCopyWithData({
      if (repo != $none) #repo: repo,
      if (branch != $none) #branch: branch,
    }),
  );
  @override
  BitbucketCommitProvider $make(CopyWithData data) => BitbucketCommitProvider(
    repo: data.get(#repo, or: $value.repo),
    branch: data.get(#branch, or: $value.branch),
  );

  @override
  BitbucketCommitProviderCopyWith<$R2, BitbucketCommitProvider, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BitbucketCommitProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LinearIssueProviderMapper extends ClassMapperBase<LinearIssueProvider> {
  LinearIssueProviderMapper._();

  static LinearIssueProviderMapper? _instance;
  static LinearIssueProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LinearIssueProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LinearIssueProvider';

  static String? _$identifier(LinearIssueProvider v) => v.identifier;
  static const Field<LinearIssueProvider, String> _f$identifier = Field(
    'identifier',
    _$identifier,
    opt: true,
  );
  static String? _$teamKey(LinearIssueProvider v) => v.teamKey;
  static const Field<LinearIssueProvider, String> _f$teamKey = Field(
    'teamKey',
    _$teamKey,
    opt: true,
  );
  static String? _$statusName(LinearIssueProvider v) => v.statusName;
  static const Field<LinearIssueProvider, String> _f$statusName = Field(
    'statusName',
    _$statusName,
    opt: true,
  );
  static String _$name(LinearIssueProvider v) => v.name;
  static const Field<LinearIssueProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(LinearIssueProvider v) => v.category;
  static const Field<LinearIssueProvider, ActivityCategory> _f$category = Field(
    'category',
    _$category,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<LinearIssueProvider> fields = const {
    #identifier: _f$identifier,
    #teamKey: _f$teamKey,
    #statusName: _f$statusName,
    #name: _f$name,
    #category: _f$category,
  };

  static LinearIssueProvider _instantiate(DecodingData data) {
    return LinearIssueProvider(
      identifier: data.dec(_f$identifier),
      teamKey: data.dec(_f$teamKey),
      statusName: data.dec(_f$statusName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LinearIssueProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LinearIssueProvider>(map);
  }

  static LinearIssueProvider fromJson(String json) {
    return ensureInitialized().decodeJson<LinearIssueProvider>(json);
  }
}

mixin LinearIssueProviderMappable {
  String toJson() {
    return LinearIssueProviderMapper.ensureInitialized()
        .encodeJson<LinearIssueProvider>(this as LinearIssueProvider);
  }

  Map<String, dynamic> toMap() {
    return LinearIssueProviderMapper.ensureInitialized()
        .encodeMap<LinearIssueProvider>(this as LinearIssueProvider);
  }

  LinearIssueProviderCopyWith<
    LinearIssueProvider,
    LinearIssueProvider,
    LinearIssueProvider
  >
  get copyWith =>
      _LinearIssueProviderCopyWithImpl<
        LinearIssueProvider,
        LinearIssueProvider
      >(this as LinearIssueProvider, $identity, $identity);
  @override
  String toString() {
    return LinearIssueProviderMapper.ensureInitialized().stringifyValue(
      this as LinearIssueProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return LinearIssueProviderMapper.ensureInitialized().equalsValue(
      this as LinearIssueProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return LinearIssueProviderMapper.ensureInitialized().hashValue(
      this as LinearIssueProvider,
    );
  }
}

extension LinearIssueProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LinearIssueProvider, $Out> {
  LinearIssueProviderCopyWith<$R, LinearIssueProvider, $Out>
  get $asLinearIssueProvider => $base.as(
    (v, t, t2) => _LinearIssueProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LinearIssueProviderCopyWith<
  $R,
  $In extends LinearIssueProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({String? identifier, String? teamKey, String? statusName});
  LinearIssueProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LinearIssueProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LinearIssueProvider, $Out>
    implements LinearIssueProviderCopyWith<$R, LinearIssueProvider, $Out> {
  _LinearIssueProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LinearIssueProvider> $mapper =
      LinearIssueProviderMapper.ensureInitialized();
  @override
  $R call({
    Object? identifier = $none,
    Object? teamKey = $none,
    Object? statusName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (identifier != $none) #identifier: identifier,
      if (teamKey != $none) #teamKey: teamKey,
      if (statusName != $none) #statusName: statusName,
    }),
  );
  @override
  LinearIssueProvider $make(CopyWithData data) => LinearIssueProvider(
    identifier: data.get(#identifier, or: $value.identifier),
    teamKey: data.get(#teamKey, or: $value.teamKey),
    statusName: data.get(#statusName, or: $value.statusName),
  );

  @override
  LinearIssueProviderCopyWith<$R2, LinearIssueProvider, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LinearIssueProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DiscordMessageProviderMapper
    extends ClassMapperBase<DiscordMessageProvider> {
  DiscordMessageProviderMapper._();

  static DiscordMessageProviderMapper? _instance;
  static DiscordMessageProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DiscordMessageProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DiscordMessageProvider';

  static String? _$guildId(DiscordMessageProvider v) => v.guildId;
  static const Field<DiscordMessageProvider, String> _f$guildId = Field(
    'guildId',
    _$guildId,
    opt: true,
  );
  static String? _$channelId(DiscordMessageProvider v) => v.channelId;
  static const Field<DiscordMessageProvider, String> _f$channelId = Field(
    'channelId',
    _$channelId,
    opt: true,
  );
  static String? _$messageId(DiscordMessageProvider v) => v.messageId;
  static const Field<DiscordMessageProvider, String> _f$messageId = Field(
    'messageId',
    _$messageId,
    opt: true,
  );
  static String? _$replyToId(DiscordMessageProvider v) => v.replyToId;
  static const Field<DiscordMessageProvider, String> _f$replyToId = Field(
    'replyToId',
    _$replyToId,
    opt: true,
  );
  static String _$name(DiscordMessageProvider v) => v.name;
  static const Field<DiscordMessageProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(DiscordMessageProvider v) => v.category;
  static const Field<DiscordMessageProvider, ActivityCategory> _f$category =
      Field('category', _$category, mode: FieldMode.member);

  @override
  final MappableFields<DiscordMessageProvider> fields = const {
    #guildId: _f$guildId,
    #channelId: _f$channelId,
    #messageId: _f$messageId,
    #replyToId: _f$replyToId,
    #name: _f$name,
    #category: _f$category,
  };

  static DiscordMessageProvider _instantiate(DecodingData data) {
    return DiscordMessageProvider(
      guildId: data.dec(_f$guildId),
      channelId: data.dec(_f$channelId),
      messageId: data.dec(_f$messageId),
      replyToId: data.dec(_f$replyToId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DiscordMessageProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DiscordMessageProvider>(map);
  }

  static DiscordMessageProvider fromJson(String json) {
    return ensureInitialized().decodeJson<DiscordMessageProvider>(json);
  }
}

mixin DiscordMessageProviderMappable {
  String toJson() {
    return DiscordMessageProviderMapper.ensureInitialized()
        .encodeJson<DiscordMessageProvider>(this as DiscordMessageProvider);
  }

  Map<String, dynamic> toMap() {
    return DiscordMessageProviderMapper.ensureInitialized()
        .encodeMap<DiscordMessageProvider>(this as DiscordMessageProvider);
  }

  DiscordMessageProviderCopyWith<
    DiscordMessageProvider,
    DiscordMessageProvider,
    DiscordMessageProvider
  >
  get copyWith =>
      _DiscordMessageProviderCopyWithImpl<
        DiscordMessageProvider,
        DiscordMessageProvider
      >(this as DiscordMessageProvider, $identity, $identity);
  @override
  String toString() {
    return DiscordMessageProviderMapper.ensureInitialized().stringifyValue(
      this as DiscordMessageProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return DiscordMessageProviderMapper.ensureInitialized().equalsValue(
      this as DiscordMessageProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return DiscordMessageProviderMapper.ensureInitialized().hashValue(
      this as DiscordMessageProvider,
    );
  }
}

extension DiscordMessageProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DiscordMessageProvider, $Out> {
  DiscordMessageProviderCopyWith<$R, DiscordMessageProvider, $Out>
  get $asDiscordMessageProvider => $base.as(
    (v, t, t2) => _DiscordMessageProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DiscordMessageProviderCopyWith<
  $R,
  $In extends DiscordMessageProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? guildId,
    String? channelId,
    String? messageId,
    String? replyToId,
  });
  DiscordMessageProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DiscordMessageProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DiscordMessageProvider, $Out>
    implements
        DiscordMessageProviderCopyWith<$R, DiscordMessageProvider, $Out> {
  _DiscordMessageProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DiscordMessageProvider> $mapper =
      DiscordMessageProviderMapper.ensureInitialized();
  @override
  $R call({
    Object? guildId = $none,
    Object? channelId = $none,
    Object? messageId = $none,
    Object? replyToId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (guildId != $none) #guildId: guildId,
      if (channelId != $none) #channelId: channelId,
      if (messageId != $none) #messageId: messageId,
      if (replyToId != $none) #replyToId: replyToId,
    }),
  );
  @override
  DiscordMessageProvider $make(CopyWithData data) => DiscordMessageProvider(
    guildId: data.get(#guildId, or: $value.guildId),
    channelId: data.get(#channelId, or: $value.channelId),
    messageId: data.get(#messageId, or: $value.messageId),
    replyToId: data.get(#replyToId, or: $value.replyToId),
  );

  @override
  DiscordMessageProviderCopyWith<$R2, DiscordMessageProvider, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DiscordMessageProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SlackMessageProviderMapper extends ClassMapperBase<SlackMessageProvider> {
  SlackMessageProviderMapper._();

  static SlackMessageProviderMapper? _instance;
  static SlackMessageProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SlackMessageProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SlackMessageProvider';

  static String? _$workspaceId(SlackMessageProvider v) => v.workspaceId;
  static const Field<SlackMessageProvider, String> _f$workspaceId = Field(
    'workspaceId',
    _$workspaceId,
    opt: true,
  );
  static String? _$channelId(SlackMessageProvider v) => v.channelId;
  static const Field<SlackMessageProvider, String> _f$channelId = Field(
    'channelId',
    _$channelId,
    opt: true,
  );
  static String? _$threadTs(SlackMessageProvider v) => v.threadTs;
  static const Field<SlackMessageProvider, String> _f$threadTs = Field(
    'threadTs',
    _$threadTs,
    opt: true,
  );
  static String? _$messageTs(SlackMessageProvider v) => v.messageTs;
  static const Field<SlackMessageProvider, String> _f$messageTs = Field(
    'messageTs',
    _$messageTs,
    opt: true,
  );
  static String _$name(SlackMessageProvider v) => v.name;
  static const Field<SlackMessageProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(SlackMessageProvider v) => v.category;
  static const Field<SlackMessageProvider, ActivityCategory> _f$category =
      Field('category', _$category, mode: FieldMode.member);

  @override
  final MappableFields<SlackMessageProvider> fields = const {
    #workspaceId: _f$workspaceId,
    #channelId: _f$channelId,
    #threadTs: _f$threadTs,
    #messageTs: _f$messageTs,
    #name: _f$name,
    #category: _f$category,
  };

  static SlackMessageProvider _instantiate(DecodingData data) {
    return SlackMessageProvider(
      workspaceId: data.dec(_f$workspaceId),
      channelId: data.dec(_f$channelId),
      threadTs: data.dec(_f$threadTs),
      messageTs: data.dec(_f$messageTs),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SlackMessageProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SlackMessageProvider>(map);
  }

  static SlackMessageProvider fromJson(String json) {
    return ensureInitialized().decodeJson<SlackMessageProvider>(json);
  }
}

mixin SlackMessageProviderMappable {
  String toJson() {
    return SlackMessageProviderMapper.ensureInitialized()
        .encodeJson<SlackMessageProvider>(this as SlackMessageProvider);
  }

  Map<String, dynamic> toMap() {
    return SlackMessageProviderMapper.ensureInitialized()
        .encodeMap<SlackMessageProvider>(this as SlackMessageProvider);
  }

  SlackMessageProviderCopyWith<
    SlackMessageProvider,
    SlackMessageProvider,
    SlackMessageProvider
  >
  get copyWith =>
      _SlackMessageProviderCopyWithImpl<
        SlackMessageProvider,
        SlackMessageProvider
      >(this as SlackMessageProvider, $identity, $identity);
  @override
  String toString() {
    return SlackMessageProviderMapper.ensureInitialized().stringifyValue(
      this as SlackMessageProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return SlackMessageProviderMapper.ensureInitialized().equalsValue(
      this as SlackMessageProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return SlackMessageProviderMapper.ensureInitialized().hashValue(
      this as SlackMessageProvider,
    );
  }
}

extension SlackMessageProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SlackMessageProvider, $Out> {
  SlackMessageProviderCopyWith<$R, SlackMessageProvider, $Out>
  get $asSlackMessageProvider => $base.as(
    (v, t, t2) => _SlackMessageProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SlackMessageProviderCopyWith<
  $R,
  $In extends SlackMessageProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? workspaceId,
    String? channelId,
    String? threadTs,
    String? messageTs,
  });
  SlackMessageProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SlackMessageProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SlackMessageProvider, $Out>
    implements SlackMessageProviderCopyWith<$R, SlackMessageProvider, $Out> {
  _SlackMessageProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SlackMessageProvider> $mapper =
      SlackMessageProviderMapper.ensureInitialized();
  @override
  $R call({
    Object? workspaceId = $none,
    Object? channelId = $none,
    Object? threadTs = $none,
    Object? messageTs = $none,
  }) => $apply(
    FieldCopyWithData({
      if (workspaceId != $none) #workspaceId: workspaceId,
      if (channelId != $none) #channelId: channelId,
      if (threadTs != $none) #threadTs: threadTs,
      if (messageTs != $none) #messageTs: messageTs,
    }),
  );
  @override
  SlackMessageProvider $make(CopyWithData data) => SlackMessageProvider(
    workspaceId: data.get(#workspaceId, or: $value.workspaceId),
    channelId: data.get(#channelId, or: $value.channelId),
    threadTs: data.get(#threadTs, or: $value.threadTs),
    messageTs: data.get(#messageTs, or: $value.messageTs),
  );

  @override
  SlackMessageProviderCopyWith<$R2, SlackMessageProvider, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SlackMessageProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FigmaFileProviderMapper extends ClassMapperBase<FigmaFileProvider> {
  FigmaFileProviderMapper._();

  static FigmaFileProviderMapper? _instance;
  static FigmaFileProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FigmaFileProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FigmaFileProvider';

  static String? _$fileKey(FigmaFileProvider v) => v.fileKey;
  static const Field<FigmaFileProvider, String> _f$fileKey = Field(
    'fileKey',
    _$fileKey,
    opt: true,
  );
  static String? _$commentId(FigmaFileProvider v) => v.commentId;
  static const Field<FigmaFileProvider, String> _f$commentId = Field(
    'commentId',
    _$commentId,
    opt: true,
  );
  static String? _$lastTouchedBy(FigmaFileProvider v) => v.lastTouchedBy;
  static const Field<FigmaFileProvider, String> _f$lastTouchedBy = Field(
    'lastTouchedBy',
    _$lastTouchedBy,
    opt: true,
  );
  static String _$name(FigmaFileProvider v) => v.name;
  static const Field<FigmaFileProvider, String> _f$name = Field(
    'name',
    _$name,
    mode: FieldMode.member,
  );
  static ActivityCategory _$category(FigmaFileProvider v) => v.category;
  static const Field<FigmaFileProvider, ActivityCategory> _f$category = Field(
    'category',
    _$category,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<FigmaFileProvider> fields = const {
    #fileKey: _f$fileKey,
    #commentId: _f$commentId,
    #lastTouchedBy: _f$lastTouchedBy,
    #name: _f$name,
    #category: _f$category,
  };

  static FigmaFileProvider _instantiate(DecodingData data) {
    return FigmaFileProvider(
      fileKey: data.dec(_f$fileKey),
      commentId: data.dec(_f$commentId),
      lastTouchedBy: data.dec(_f$lastTouchedBy),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FigmaFileProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FigmaFileProvider>(map);
  }

  static FigmaFileProvider fromJson(String json) {
    return ensureInitialized().decodeJson<FigmaFileProvider>(json);
  }
}

mixin FigmaFileProviderMappable {
  String toJson() {
    return FigmaFileProviderMapper.ensureInitialized()
        .encodeJson<FigmaFileProvider>(this as FigmaFileProvider);
  }

  Map<String, dynamic> toMap() {
    return FigmaFileProviderMapper.ensureInitialized()
        .encodeMap<FigmaFileProvider>(this as FigmaFileProvider);
  }

  FigmaFileProviderCopyWith<
    FigmaFileProvider,
    FigmaFileProvider,
    FigmaFileProvider
  >
  get copyWith =>
      _FigmaFileProviderCopyWithImpl<FigmaFileProvider, FigmaFileProvider>(
        this as FigmaFileProvider,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FigmaFileProviderMapper.ensureInitialized().stringifyValue(
      this as FigmaFileProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return FigmaFileProviderMapper.ensureInitialized().equalsValue(
      this as FigmaFileProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return FigmaFileProviderMapper.ensureInitialized().hashValue(
      this as FigmaFileProvider,
    );
  }
}

extension FigmaFileProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FigmaFileProvider, $Out> {
  FigmaFileProviderCopyWith<$R, FigmaFileProvider, $Out>
  get $asFigmaFileProvider => $base.as(
    (v, t, t2) => _FigmaFileProviderCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FigmaFileProviderCopyWith<
  $R,
  $In extends FigmaFileProvider,
  $Out
>
    implements ActivityProviderCopyWith<$R, $In, $Out> {
  @override
  $R call({String? fileKey, String? commentId, String? lastTouchedBy});
  FigmaFileProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FigmaFileProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FigmaFileProvider, $Out>
    implements FigmaFileProviderCopyWith<$R, FigmaFileProvider, $Out> {
  _FigmaFileProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FigmaFileProvider> $mapper =
      FigmaFileProviderMapper.ensureInitialized();
  @override
  $R call({
    Object? fileKey = $none,
    Object? commentId = $none,
    Object? lastTouchedBy = $none,
  }) => $apply(
    FieldCopyWithData({
      if (fileKey != $none) #fileKey: fileKey,
      if (commentId != $none) #commentId: commentId,
      if (lastTouchedBy != $none) #lastTouchedBy: lastTouchedBy,
    }),
  );
  @override
  FigmaFileProvider $make(CopyWithData data) => FigmaFileProvider(
    fileKey: data.get(#fileKey, or: $value.fileKey),
    commentId: data.get(#commentId, or: $value.commentId),
    lastTouchedBy: data.get(#lastTouchedBy, or: $value.lastTouchedBy),
  );

  @override
  FigmaFileProviderCopyWith<$R2, FigmaFileProvider, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FigmaFileProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class GenericProviderMapper extends ClassMapperBase<GenericProvider> {
  GenericProviderMapper._();

  static GenericProviderMapper? _instance;
  static GenericProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GenericProviderMapper._());
      ActivityProviderMapper.ensureInitialized();
      ActivityCategoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GenericProvider';

  static String _$name(GenericProvider v) => v.name;
  static const Field<GenericProvider, String> _f$name = Field('name', _$name);
  static ActivityCategory _$category(GenericProvider v) => v.category;
  static const Field<GenericProvider, ActivityCategory> _f$category = Field(
    'category',
    _$category,
    opt: true,
    def: ActivityCategory.generic,
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
  $R call({String? name, ActivityCategory? category});
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
  $R call({String? name, ActivityCategory? category}) => $apply(
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

