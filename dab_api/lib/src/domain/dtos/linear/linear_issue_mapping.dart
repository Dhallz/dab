import 'package:dab_api/src/domain/dtos/linear/linear_issue_dto.dart';

/// [ARCH: DOMAIN]
/// ROLE: Maps Linear GraphQL / webhook issue and comment nodes into DTOs.

/// Maps one GraphQL/webhook issue node into a [LinearIssueDto].
///
/// Returns null when the node lacks an identifier or a parseable `updatedAt`.
/// [externalToUser] maps Linear user UUIDs to DAB user ids; assignee wins over
/// creator for attribution.
LinearIssueDto? mapLinearIssueNode(
  Map<String, dynamic> node,
  Map<String, String> externalToUser,
) {
  final identifier = (node['identifier'] ?? '').toString().trim();
  if (identifier.isEmpty) return null;

  final updatedRaw = node['updatedAt']?.toString();
  final updatedAt = updatedRaw != null
      ? DateTime.tryParse(updatedRaw)?.toUtc()
      : null;
  if (updatedAt == null) return null;

  final team = node['team'];
  var teamKey = team is Map<String, dynamic>
      ? (team['key'] ?? '').toString().trim()
      : '';
  if (teamKey.isEmpty && identifier.contains('-')) {
    teamKey = identifier.split('-').first;
  }

  final state = node['state'];
  final statusName = state is Map<String, dynamic>
      ? (state['name'] ?? '').toString().trim()
      : '';

  final assignee = node['assignee'];
  final creator = node['creator'];
  final assigneeId = linearPersonId(assignee);
  final creatorId = linearPersonId(creator);

  String? dabUserId;
  for (final externalId in [assigneeId, creatorId]) {
    if (externalId == null) continue;
    final mapped = externalToUser[externalId];
    if (mapped != null && mapped.isNotEmpty) {
      dabUserId = mapped;
      break;
    }
  }

  return LinearIssueDto(
    identifier: identifier,
    teamKey: teamKey.isEmpty ? 'UNKNOWN' : teamKey,
    title: (node['title'] ?? '').toString(),
    statusName: statusName,
    url: (node['url'] ?? '').toString().trim(),
    updatedAt: updatedAt,
    dabUserId: dabUserId,
    authorDisplayName:
        linearPersonDisplay(assignee) ?? linearPersonDisplay(creator),
  );
}

/// Maps one GraphQL/webhook comment node. Returns null without id or timestamp.
LinearIssueCommentDto? mapLinearCommentNode(
  Map<String, dynamic> node,
  Map<String, String> externalToUser,
) {
  final id = (node['id'] ?? '').toString().trim();
  if (id.isEmpty) return null;

  final createdRaw =
      node['createdAt']?.toString() ?? node['updatedAt']?.toString();
  final createdAt = createdRaw != null
      ? DateTime.tryParse(createdRaw)?.toUtc()
      : null;
  if (createdAt == null) return null;

  var user = node['user'];
  if (user is! Map<String, dynamic> && node['userId'] != null) {
    user = {'id': node['userId']};
  }
  final userId = linearPersonId(user);
  final mapped = userId == null ? null : externalToUser[userId];

  return LinearIssueCommentDto(
    id: id,
    body: (node['body'] ?? '').toString(),
    createdAt: createdAt,
    dabUserId: mapped,
    authorDisplayName: linearPersonDisplay(user),
  );
}

/// Extracts Linear user ids from `@[Name](uuid)` markdown and `mentionedUserIds`.
List<String> extractLinearMentionUserIds({
  Object? body,
  Object? mentionedUserIds,
}) {
  final ids = <String>{};
  if (mentionedUserIds is List) {
    for (final item in mentionedUserIds) {
      if (item is Map) {
        final id = (item['id'] ?? '').toString().trim();
        if (id.isNotEmpty) ids.add(id);
      } else {
        final id = item.toString().trim();
        if (id.isNotEmpty) ids.add(id);
      }
    }
  }
  final text = (body ?? '').toString();
  for (final match in _linearMentionPattern.allMatches(text)) {
    final id = match.group(1)?.trim();
    if (id != null && id.isNotEmpty) ids.add(id);
  }
  return ids.toList();
}

final _linearMentionPattern = RegExp(r'@\[[^\]]*\]\(([A-Za-z0-9-]+)\)');

/// Linear user id that became the assignee, or null when assignee did not change.
String? extractLinearAssigneeBecameId({
  required String action,
  required Map<String, dynamic> payload,
  required Map<String, dynamic> data,
}) {
  final current =
      linearPersonId(data['assignee']) ??
      (data['assigneeId'] ?? '').toString().trim();
  if (current.isEmpty) return null;
  if (action == 'create') return current;
  final updatedFrom = payload['updatedFrom'];
  if (updatedFrom is! Map) return null;
  if (!updatedFrom.containsKey('assigneeId') &&
      !updatedFrom.containsKey('assignee')) {
    return null;
  }
  return current;
}
String? linearPersonId(Object? person) {
  if (person is! Map<String, dynamic>) return null;
  final raw = person['id']?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  return raw;
}

/// Extracts a display label from an embedded person node.
String? linearPersonDisplay(Object? person) {
  if (person is! Map<String, dynamic>) return null;
  final display = (person['displayName'] ?? person['name'])?.toString().trim();
  if (display == null || display.isEmpty) return null;
  return display;
}
