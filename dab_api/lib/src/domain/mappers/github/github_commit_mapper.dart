import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/mappers/i_activity_mapper.dart';
import 'package:dab_api/src/infrastructure/dtos/github/github_commit_dto.dart';
import 'package:uuid/uuid.dart';

/// [ARCH: DOMAIN_MAPPER]
/// ROLE: Maps GitHub commits into unified DAB activities.
/// CONTRACT: Produces commit-category [Activity] values for linked users only.
/// CONSTRAINTS: Pure transformation logic, no I/O.
class GitHubCommitMapper implements IActivityMapper<GitHubCommitDto> {
  final _uuid = const Uuid();

  @override
  String get providerName => 'github';

  @override
  List<Activity> mapToActivities(GitHubCommitDto data, List<User> users) {
    final userId = data.userId;
    if (userId == null || userId.isEmpty) {
      return const [];
    }

    final user = users.where((u) => u.id == userId).firstOrNull;
    if (user == null) {
      return const [];
    }

    final subjectAndBody = _splitCommitSubjectAndBody(data.message);
    final subject = subjectAndBody.$1;
    final body = subjectAndBody.$2;

    final branchTag = data.branch?.trim();
    final title =
        branchTag != null && branchTag.isNotEmpty
            ? '[$branchTag] $subject'
            : subject;

    final githubLogin = data.authorLogin?.trim();
    final authorLine =
        githubLogin != null && githubLogin.isNotEmpty
            ? '${user.name} (@$githubLogin)'
            : user.name;

    return [
      Activity(
        id: _uuid.v5(Namespace.url.value, 'github-${data.repo}-${data.sha}'),
        userId: user.id,
        provider: GitHubCommitProvider(repo: data.repo, branch: data.branch),
        title: title,
        content: body,
        url: data.url,
        authorName: authorLine,
        authorAvatarUrl: data.authorAvatarUrl ?? user.avatarUrl,
        commentCount: 0,
        createdAt: data.committedAt,
      ),
    ];
  }

  /// First line vs remainder (after first `\n`). Normalizes CRLF.
  (String subject, String body) _splitCommitSubjectAndBody(String message) {
    final normalized = message.replaceAll('\r\n', '\n').trim();
    if (normalized.isEmpty) {
      return ('(empty commit message)', '');
    }
    final i = normalized.indexOf('\n');
    if (i < 0) {
      return (normalized, '');
    }
    final sub = normalized.substring(0, i).trim();
    final rest = normalized.substring(i + 1).trim();
    return (
      sub.isEmpty ? '(empty commit message)' : sub,
      rest,
    );
  }
}
