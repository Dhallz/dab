import 'package:dab_api/src/domain/dtos/gitlab/gitlab_commit_dto.dart';

/// [ARCH: DOMAIN]
/// ROLE: Maps GitLab REST / Push Hook commit JSON into [GitLabCommitDto].

/// Maps one GitLab commit JSON object (REST response row) into a
/// [GitLabCommitDto]. Returns null for malformed rows.
GitLabCommitDto? mapGitLabCommitJson(
  Map<String, dynamic> json, {
  required String project,
  String? branch,
  Map<String, String> emailToUser = const {},
}) {
  final sha = (json['id'] ?? '').toString().trim();
  if (sha.isEmpty) return null;

  final createdRaw =
      (json['committed_date'] ?? json['created_at'] ?? json['timestamp'])
          ?.toString();
  final committedAt = createdRaw != null
      ? DateTime.tryParse(createdRaw)?.toUtc()
      : null;
  if (committedAt == null) return null;

  final nestedAuthor = json['author'];
  final nestedEmail = nestedAuthor is Map<String, dynamic>
      ? nestedAuthor['email']
      : null;
  final nestedName = nestedAuthor is Map<String, dynamic>
      ? nestedAuthor['name']?.toString()
      : null;
  final authorEmail =
      (json['author_email'] ?? nestedEmail ?? '').toString().trim();

  return GitLabCommitDto(
    project: project,
    branch: branch,
    sha: sha,
    message: (json['message'] ?? json['title'] ?? '').toString().trim(),
    url: (json['web_url'] ?? json['url'] ?? '').toString().trim(),
    authorName: json['author_name']?.toString() ?? nestedName,
    authorEmail: authorEmail.isEmpty ? null : authorEmail,
    committedAt: committedAt,
    userId: authorEmail.isEmpty ? null : emailToUser[authorEmail.toLowerCase()],
  );
}
