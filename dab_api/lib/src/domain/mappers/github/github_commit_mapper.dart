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

    final shortSha = data.sha.length > 7 ? data.sha.substring(0, 7) : data.sha;
    return [
      Activity(
        id: _uuid.v5(Namespace.url.value, 'github-${data.repo}-${data.sha}'),
        userId: user.id,
        provider: GitHubCommitProvider(repo: data.repo, branch: data.branch),
        title: '[${data.repo}] $shortSha',
        content: data.message,
        url: data.url,
        authorName: data.authorName ?? user.name,
        authorAvatarUrl: data.authorAvatarUrl ?? user.avatarUrl,
        commentCount: 0,
        createdAt: data.committedAt,
      ),
    ];
  }
}
