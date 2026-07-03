import 'activity_category.dart';
import '../../core/org_calendar.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Canonical search contract for activity retrieval across local and remote sources.
/// CONTRACT: Immutable query object shared by use cases, repositories, and datasources.
/// CONSTRAINTS: Must preserve identical filtering semantics across API/local implementations.
class ActivitySearchQuery {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> users;
  final Set<String> providers;
  final Set<String> coverageProviders;
  final Set<ActivityCategory> categories;
  final String? text;
  final bool authoredOnly;
  final bool sortDescending;
  final int? limit;
  final String? cursor;
  final String orgTimezoneId;

  const ActivitySearchQuery({
    this.startDate,
    this.endDate,
    this.users = const [],
    this.providers = const {},
    this.coverageProviders = const {},
    this.categories = const {},
    this.text,
    this.authoredOnly = true,
    this.sortDescending = true,
    this.limit,
    this.cursor,
    this.orgTimezoneId = kDefaultOrgTimezoneId,
  });

  Set<String> get normalizedUsers => users
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet();

  Set<String> get normalizedProviders => providers
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .toSet();

  Set<String> get normalizedCoverageProviders => coverageProviders
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .toSet();

  String? get normalizedText {
    final value = text?.trim().toLowerCase();
    if (value == null || value.isEmpty) return null;
    return value;
  }
}
