import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../datasources/activity_search_query_mapper.dart';

@Entity()
class ExplorerActivityRecord {
  @Id()
  int id = 0;

  @Unique(onConflict: ConflictStrategy.replace)
  final String activityRemoteId;

  @Index()
  final String dayKey;

  @Index()
  final int createdAtEpochMs;

  @Index()
  final String userId;

  @Index()
  final String providerKey;

  @Index()
  final String providerDisplayNameLower;

  @Index()
  final String categoryKey;

  @Index()
  final String activityKindKey;

  final String searchText;
  final String payloadJson;

  ExplorerActivityRecord({
    required this.activityRemoteId,
    required this.dayKey,
    required this.createdAtEpochMs,
    required this.userId,
    required this.providerKey,
    required this.providerDisplayNameLower,
    required this.categoryKey,
    required this.activityKindKey,
    required this.searchText,
    required this.payloadJson,
  });
}

extension OnExplorerActivityRecord on ExplorerActivityRecord {
  Activity get toDomain =>
      ActivityMapper.fromMap(jsonDecode(payloadJson) as Map<String, dynamic>);
}

extension OnActivityForExplorerRecord on Activity {
  ExplorerActivityRecord toExplorerRecord(String orgTimezoneId) {
    final lowerProvider = provider.name.toLowerCase();
    final filterKey = ActivitySearchQueryMapper.providerFilterKey(provider);
    final dayKey = orgDayKeyFromUtc(orgTimezoneId, createdAt);
    final searchable = [
      title,
      content,
      authorName,
      provider.name,
      provider.category.name,
    ].join(' ').toLowerCase();

    return ExplorerActivityRecord(
      activityRemoteId: id,
      dayKey: dayKey,
      createdAtEpochMs: createdAt.toUtc().millisecondsSinceEpoch,
      userId: userId,
      providerKey: filterKey,
      providerDisplayNameLower: lowerProvider,
      categoryKey: provider.category.name,
      activityKindKey: provider.runtimeType.toString().toLowerCase(),
      searchText: searchable,
      payloadJson: jsonEncode(toMap()),
    );
  }
}
