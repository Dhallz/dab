import 'package:dab_api/src/domain/dtos/bitbucket/bitbucket_commit_dto.dart';

/// [ARCH: DOMAIN]
/// ROLE: Maps Bitbucket REST 2.0 / `repo:push` commit JSON into [BitbucketCommitDto].

/// Maps one Bitbucket commit JSON object (REST 2.0 row or `repo:push`
/// webhook change commit) into a [BitbucketCommitDto].
///
/// Returns null for malformed rows. [branch] is only known on webhook
/// payloads (the commits API is branch-agnostic).
BitbucketCommitDto? mapBitbucketCommitJson(
  Map<String, dynamic> json, {
  required String repo,
  String? branch,
  Map<String, String> accountToUser = const {},
  Map<String, String> emailToUser = const {},
}) {
  final sha = (json['hash'] ?? '').toString().trim();
  if (sha.isEmpty) return null;

  final dateRaw = json['date']?.toString();
  final committedAt = dateRaw != null
      ? DateTime.tryParse(dateRaw)?.toUtc()
      : null;
  if (committedAt == null) return null;

  final author = json['author'];
  String? accountId;
  String? displayName;
  String? rawSignature;
  if (author is Map<String, dynamic>) {
    rawSignature = author['raw']?.toString();
    final platformUser = author['user'];
    if (platformUser is Map<String, dynamic>) {
      accountId = platformUser['account_id']?.toString().trim();
      displayName = platformUser['display_name']?.toString().trim();
    }
  }
  final email = bitbucketEmailFromRaw(rawSignature);

  String? userId;
  if (accountId != null && accountId.isNotEmpty) {
    userId = accountToUser[accountId];
  }
  if (userId == null && email != null) {
    userId = emailToUser[email.toLowerCase()];
  }

  final links = json['links'];
  final html = links is Map<String, dynamic> ? links['html'] : null;
  final url = html is Map<String, dynamic>
      ? (html['href'] ?? '').toString().trim()
      : '';

  return BitbucketCommitDto(
    repo: repo,
    branch: branch,
    sha: sha,
    message: (json['message'] ?? '').toString().trim(),
    url: url,
    authorName: displayName?.isNotEmpty == true
        ? displayName
        : bitbucketNameFromRaw(rawSignature),
    authorEmail: email,
    committedAt: committedAt,
    userId: userId,
  );
}
