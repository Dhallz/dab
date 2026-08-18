import '../../../../domain/entities/activity/activity.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Dashboard card copy helpers for git commits.
/// CONTRACT: Headline is the commit subject. A stored `[branch] subject`
/// prefix (legacy live rows) is stripped when it matches [provider.branch].

/// Branch name on a git commit provider, or null when absent.
String? gitBranchLabelFor(ActivityProvider provider) {
  final raw = switch (provider) {
    GitHubCommitProvider(:final branch) => branch,
    GitLabCommitProvider(:final branch) => branch,
    BitbucketCommitProvider(:final branch) => branch,
    _ => null,
  };
  final value = raw?.trim() ?? '';
  return value.isEmpty ? null : value;
}

/// Title shown on a Dashboard card. Strips a matching `[branch]` prefix.
String dashboardActivityHeadline(Activity activity) {
  final title = activity.title.trim();
  final branch = gitBranchLabelFor(activity.provider);
  if (branch == null) return title;
  final prefix = '[$branch]';
  if (!title.startsWith(prefix)) return title;
  return title.substring(prefix.length).trim();
}
