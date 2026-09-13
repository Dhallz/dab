/// [ARCH: DOMAIN]
/// ROLE: Normalizes Jira Cloud site hosts from instance URLs.
/// CONTRACT: Returns a lowercase hostname or empty string. Project-key
/// parsing lives next to [JiraProjectWatchList] as [OnObjectNullable.parseJiraProjectKeys].
library;

/// [ARCH: DOMAIN]
/// ROLE: Hostname from a Jira Cloud site URL (`your-site.atlassian.net`).
extension OnString on String {
  /// Hostname from a Jira Cloud site URL (`your-site.atlassian.net`).
  String normalizeJiraCloudHost() {
    final t = trim();
    if (t.isEmpty) return '';
    var u = t;
    if (!u.startsWith('http')) u = 'https://$u';
    final parsed = Uri.tryParse(u);
    if (parsed == null || parsed.host.isEmpty) return '';
    return parsed.host.toLowerCase();
  }
}
