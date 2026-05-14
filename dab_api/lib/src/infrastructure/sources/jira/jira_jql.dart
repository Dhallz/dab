// [ARCH: INFRASTRUCTURE_HELPER]
// Stateless Jira Cloud JQL for REST `/rest/api/3/search` (`updated` UTC window).

library;

String normalizeJiraCloudHost(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return '';
  var u = t;
  if (!u.startsWith('http')) u = 'https://$u';
  final parsed = Uri.tryParse(u);
  if (parsed == null || parsed.host.isEmpty) return '';
  return parsed.host.toLowerCase();
}

String jiraUtcDateTimeLiteral(DateTime utc) {
  final u = utc.toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${u.year}-${two(u.month)}-${two(u.day)} '
      '${two(u.hour)}:${two(u.minute)}';
}

/// Builds a JQL clause for issue search within [startInclusiveUtc, endInclusiveUtc]
/// filtered by **`updated`**.
///
/// Returns `null` when the query would be meaningless (missing scope windows,
/// or `authoredOnly` with empty [accountIds]).
String? buildIssuesSearchJql({
  required DateTime startInclusiveUtc,
  required DateTime endInclusiveUtc,
  required List<String> projectKeysRaw,
  String extraJql = '',
  required bool authoredOnly,
  Iterable<String>? accountIds,
}) {
  final startLit = jiraUtcDateTimeLiteral(startInclusiveUtc);
  final endLit = jiraUtcDateTimeLiteral(endInclusiveUtc);

  final projectKeys = <String>[];
  for (final p in projectKeysRaw) {
    final trimmed = p.trim();
    if (trimmed.isEmpty) continue;
    if (!RegExp(r'^[A-Za-z][A-Za-z0-9_]{0,99}$').hasMatch(trimmed)) {
      continue;
    }
    projectKeys.add(trimmed);
  }

  final extra = extraJql.trim();

  final hasProjectClause = projectKeys.isNotEmpty;
  final hasExtra = extra.isNotEmpty;

  if (!hasProjectClause && !hasExtra) return null;

  final parts = <String>[
    'updated >= "$startLit"',
    'updated <= "$endLit"',
  ];

  if (hasProjectClause) {
    parts.add('project in (${projectKeys.join(', ')})');
  }
  if (hasExtra) {
    parts.add('($extra)');
  }

  var jql = parts.join(' AND ');

  if (authoredOnly) {
    final ids = accountIds?.map((s) => s.trim()).where((s) => s.isNotEmpty) ?? [];
    final idList = ids.toSet().toList();
    if (idList.isEmpty) return null;

    final quoted = idList.map((id) => '"$id"').join(', ');
    final peopleClause =
        '(reporter in ($quoted) OR assignee in ($quoted) OR creator in ($quoted))';
    jql = '$jql AND $peopleClause';
  }

  return jql;
}
