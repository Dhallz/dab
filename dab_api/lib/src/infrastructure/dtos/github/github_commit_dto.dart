import 'package:dart_mappable/dart_mappable.dart';

part 'github_commit_dto.mapper.dart';

@MappableClass()
class GitHubCommitDto with GitHubCommitDtoMappable {
  final String repo;
  final String? branch;
  final String sha;
  final String message;
  final String url;
  final String? authorLogin;
  final String? authorName;
  final String? authorEmail;
  final String? authorAvatarUrl;
  final DateTime committedAt;
  final String? userId;

  const GitHubCommitDto({
    required this.repo,
    required this.sha,
    required this.message,
    required this.url,
    required this.committedAt,
    this.branch,
    this.authorLogin,
    this.authorName,
    this.authorEmail,
    this.authorAvatarUrl,
    this.userId,
  });
}
