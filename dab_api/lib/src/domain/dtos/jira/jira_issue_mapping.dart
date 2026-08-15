/// [ARCH: DOMAIN]
/// ROLE: Maps nested Jira Cloud JSON fields used by poll and webhook ingest.
library;

/// Nested `{name: ...}` field (status, etc.).
String extractJiraEmbeddedName(Object? nested) {
  if (nested is! Map<String, dynamic>) return '';
  final n = nested['name']?.toString().trim();
  return n ?? '';
}

/// Atlassian account id from an embedded person object.
String? jiraPersonAccountId(Object? person) {
  if (person == null || person == false) return null;
  if (person is! Map<String, dynamic>) return null;
  final raw = person['accountId']?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  return raw;
}

/// Display name from an embedded person object.
String? pickJiraPersonDisplay(Object? person) {
  if (person is! Map<String, dynamic>) return null;
  final name = person['displayName']?.toString().trim();
  if (name == null || name.isEmpty) return null;
  return name;
}

/// Flattens an ADF comment body (or nested text nodes) to plain text.
String extractJiraCommentText(Object? bodyNode) {
  final lines = <String>[];
  _collectJiraText(bodyNode, lines);
  final joined = lines.join('\n').trim();
  return joined;
}

void _collectJiraText(Object? node, List<String> lines) {
  if (node == null) return;

  if (node is List) {
    for (final item in node) {
      _collectJiraText(item, lines);
    }
    return;
  }

  if (node is! Map<String, dynamic>) return;

  final type = node['type']?.toString() ?? '';
  if (type == 'text') {
    final t = node['text']?.toString() ?? '';
    if (t.isNotEmpty) {
      if (lines.isEmpty) {
        lines.add(t);
      } else {
        lines[lines.length - 1] = '${lines.last}$t';
      }
    }
    return;
  }

  if (type == 'hardBreak') {
    lines.add('');
    return;
  }

  final content = node['content'];
  if (type == 'paragraph') {
    final before = lines.length;
    _collectJiraText(content, lines);
    if (lines.length == before) {
      lines.add('');
    } else if (lines.last.isNotEmpty) {
      lines.add('');
    }
    return;
  }

  _collectJiraText(content, lines);
}
