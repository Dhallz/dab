import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/activity/activity_search_query.dart';
import '../core/local/records/explorer_activity_record.dart';

class ActivitySearchQueryMapper {
  static Map<String, dynamic> toRemoteQueryParameters(
    ActivitySearchQuery query,
  ) {
    final queryParameters = <String, dynamic>{
      'authoredOnly': query.authoredOnly.toString(),
    };

    if (query.startDate != null) {
      queryParameters['startDate'] = query.startDate!.toIso8601String().split(
        'T',
      )[0];
    }
    if (query.endDate != null) {
      queryParameters['endDate'] = query.endDate!.toIso8601String().split(
        'T',
      )[0];
    }

    final users = query.normalizedUsers.toList()..sort();
    if (users.isNotEmpty) {
      queryParameters['users'] = users.join(',');
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
    if (providers.isNotEmpty && !providers.contains(record.providerKey)) {
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
        !providers.contains(activity.provider.name.toLowerCase())) {
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
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(
      end.year,
      end.month,
      end.day,
      23,
      59,
      59,
      999,
    );
    final created = createdAt.toLocal();

    return !created.isBefore(normalizedStart) &&
        !created.isAfter(normalizedEnd);
  }
}
