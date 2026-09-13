import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/activity/activity_search_query.dart';
import '../../domain/core/org_calendar.dart';
import '../core/local/records/explorer_activity_record.dart';

class ActivitySearchQueryMapper {
  /// Lowercase identifier aligned with [ProviderConfig.id] for filter/cache keys.
  static String providerFilterKey(ActivityProvider provider) {
    return switch (provider) {
      PhorgeTaskProvider() || PhorgeRevisionProvider() => 'phorge',
      GitHubCommitProvider() => 'github',
      GitLabCommitProvider() => 'gitlab',
      BitbucketCommitProvider() => 'bitbucket',
      JiraIssueProvider() => 'jira',
      LinearIssueProvider() => 'linear',
      FigmaFileProvider() => 'figma',
      SlackMessageProvider() => 'slack',
      DiscordMessageProvider() => 'discord',
      GenericProvider(name: final n) => n.toLowerCase().trim(),
    };
  }

  static Map<String, dynamic> toRemoteQueryParameters(
    ActivitySearchQuery query,
  ) {
    final queryParameters = <String, dynamic>{
      'authoredOnly': query.authoredOnly.toString(),
    };

    if (query.startDate != null) {
      queryParameters['startDate'] = orgCalendarDayString(
        query.orgTimezoneId,
        query.startDate!,
      );
    }
    if (query.endDate != null) {
      queryParameters['endDate'] = orgCalendarDayString(
        query.orgTimezoneId,
        query.endDate!,
      );
    }

    final users = query.normalizedUsers.toList()..sort();
    if (users.isNotEmpty) {
      queryParameters['users'] = users.join(',');
    }

    final providers = query.normalizedProviders.toList()..sort();
    if (providers.isNotEmpty) {
      queryParameters['providers'] = providers.join(',');
    }

    return queryParameters;
  }

  static bool matchesLocalRecord(
    ExplorerActivityRecord record,
    ActivitySearchQuery query,
  ) {
    final users = query.normalizedUsers;
    final providers = query.normalizedProviders;
    final categories = query.categories;
    final text = query.normalizedText;

    if (users.isNotEmpty && !users.contains(record.userId)) return false;
    if (providers.isNotEmpty &&
        !providers.contains(record.providerKey.toLowerCase())) {
      return false;
    }
    if (categories.isNotEmpty &&
        !categories.any((c) => c.name == record.categoryKey)) {
      return false;
    }
    if (text != null && !record.searchText.contains(text)) return false;

    return true;
  }

  static bool matchesActivity(Activity activity, ActivitySearchQuery query) {
    if (!_matchesDateRange(activity.createdAt, query)) return false;

    final users = query.normalizedUsers;
    final providers = query.normalizedProviders;
    final categories = query.categories;
    final text = query.normalizedText;

    if (users.isNotEmpty && !users.contains(activity.userId)) return false;
    if (providers.isNotEmpty &&
        !providers.contains(providerFilterKey(activity.provider))) {
      return false;
    }
    if (categories.isNotEmpty &&
        !categories.contains(activity.provider.category)) {
      return false;
    }

    if (text != null) {
      final blob = [
        activity.title,
        activity.content,
        activity.authorName,
        activity.provider.name,
        activity.provider.category.name,
      ].join(' ').toLowerCase();
      if (!blob.contains(text)) return false;
    }

    return true;
  }

  static bool _matchesDateRange(DateTime createdAt, ActivitySearchQuery query) {
    if (query.startDate == null && query.endDate == null) return true;

    final start = query.startDate ?? query.endDate!;
    final end = query.endDate ?? query.startDate!;
    return isInstantInOrgDateWindow(query.orgTimezoneId, createdAt, start, end);
  }
}
