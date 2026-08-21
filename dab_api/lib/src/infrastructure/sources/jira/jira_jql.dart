// [ARCH: INFRASTRUCTURE_HELPER]
// Stateless Jira Cloud JQL for REST `/rest/api/3/search` (`updated` UTC window).

library;

import 'dart:convert';

import 'package:dab_api/src/domain/core/jira_scope.dart';
import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';

/// REST API base + headers for Jira Cloud PAT or OAuth 3LO.
class JiraRequestAuth {
  const JiraRequestAuth({
    required this.apiBase,
    required this.browseHost,
    required this.headers,
  });

  /// Origin used for REST (`https://host` or `https://api.atlassian.com/ex/jira/{cloudId}`).
  final String apiBase;

  /// Hostname for browse URLs (`https://{browseHost}/browse/KEY`).
  final String browseHost;

  final Map<String, String> headers;
}

JiraRequestAuth? jiraRequestAuth(
  Map<String, dynamic> settings, {
  ProviderConfig? orgConfig,
}) {
  final token = settings.extractProviderToken('jira');
  if (token.isEmpty) return null;

  final browseHost = (settings['instanceUrl'] ?? orgConfig?.baseUrl ?? '').toString().normalizeJiraCloudHost();

  if (settings.isOauthCredential) {
    final cloudId = (settings['cloudId'] ?? '').toString().trim();
    if (cloudId.isEmpty) return null;
    return JiraRequestAuth(
      apiBase: 'https://api.atlassian.com/ex/jira/$cloudId',
      browseHost: browseHost.isEmpty ? 'atlassian.net' : browseHost,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  final email =
      (settings['email'] ?? settings['api.email'] ?? '').toString().trim();
  if (email.isEmpty || browseHost.isEmpty) return null;
  final encoded = base64Encode(utf8.encode('$email:$token'));
  return JiraRequestAuth(
    apiBase: 'https://$browseHost',
    browseHost: browseHost,
    headers: {
      'Authorization': 'Basic $encoded',
      'Accept': 'application/json',
    },
  );
}

/// [ARCH: INFRASTRUCTURE]
/// ROLE: JQL UTC datetime literal (`yyyy-MM-dd HH:mm`).
extension OnDateTime on DateTime {
  String jiraUtcDateTimeLiteral() {
    final u = toUtc();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${u.year}-${two(u.month)}-${two(u.day)} '
        '${two(u.hour)}:${two(u.minute)}';
  }
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
  final startLit = startInclusiveUtc.jiraUtcDateTimeLiteral();
  final endLit = endInclusiveUtc.jiraUtcDateTimeLiteral();

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
