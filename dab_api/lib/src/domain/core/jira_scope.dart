/// [ARCH: DOMAIN]
/// ROLE: Normalizes Jira Cloud site hosts from instance URLs.
/// CONTRACT: Returns a lowercase hostname or empty string. Project-key
/// parsing lives next to [JiraProjectWatchList] as [parseJiraProjectKeys].
library;

/// Hostname from a Jira Cloud site URL (`your-site.atlassian.net`).
String normalizeJiraCloudHost(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return '';
  var u = t;
  if (!u.startsWith('http')) u = 'https://$u';
  final parsed = Uri.tryParse(u);
  if (parsed == null || parsed.host.isEmpty) return '';
  return parsed.host.toLowerCase();
}
