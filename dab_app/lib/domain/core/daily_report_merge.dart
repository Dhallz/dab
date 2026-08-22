import '../entities/activity/activity.dart';
import '../entities/user/daily_report.dart';
import '../entities/user/daily_report_line.dart';
import '../entities/user/daily_report_line_role.dart';
import 'org_calendar.dart';
import 'report_subject_key.dart';

/// [ARCH: DOMAIN]
/// ROLE: Unions live Directed (optional Following) with authored search.
/// CONTRACT: Same subject key → [DailyReportLineRole.both]. Saved include/note
/// values overlay the pool; leftover saved lines stay so a restart restores them.
List<DailyReportLine> mergeDailyReportPool({
  required List<Activity> live,
  required List<Activity> authored,
  required DailyReport saved,
  required String orgTimezoneId,
  required DateTime reportDay,
  bool includeFollowing = false,
}) {
  final byKey = <String, DailyReportLine>{};

  void add(Activity activity, DailyReportLineRole role) {
    if (activity.archived) return;
    if (!isInstantInOrgCalendarDay(
      orgTimezoneId,
      activity.createdAt,
      reportDay,
    )) {
      return;
    }
    if (role == DailyReportLineRole.directed &&
        activity.isFollowLane &&
        !includeFollowing) {
      return;
    }
    final key = activity.reportSubjectKey;
    final snapshot = DailyReportLine(
      subjectKey: key,
      included: true,
      role: role,
      title: activity.title,
      url: activity.url,
      occurredAt: activity.createdAt.toUtc(),
      providerId: activity.reportProviderId,
    );
    final existing = byKey[key];
    if (existing == null) {
      byKey[key] = snapshot;
      return;
    }
    byKey[key] = existing.copyWith(
      role: existing.role.union(role),
      title: _prefer(existing.title, snapshot.title),
      url: _prefer(existing.url, snapshot.url),
      occurredAt: _later(existing.occurredAt, snapshot.occurredAt),
      providerId: _prefer(existing.providerId, snapshot.providerId),
    );
  }

  for (final activity in live) {
    add(activity, DailyReportLineRole.directed);
  }
  for (final activity in authored) {
    add(activity, DailyReportLineRole.authored);
  }

  final savedByKey = {
    for (final line in saved.lines)
      if (line.subjectKey.trim().isNotEmpty) line.subjectKey: line,
  };
  for (final key in List<String>.from(byKey.keys)) {
    final savedLine = savedByKey[key];
    if (savedLine == null) continue;
    byKey[key] = byKey[key]!.copyWith(
      included: savedLine.included,
      note: savedLine.note,
    );
  }
  for (final savedLine in saved.lines) {
    final key = savedLine.subjectKey.trim();
    if (key.isEmpty) continue;
    byKey.putIfAbsent(key, () => savedLine);
  }

  final lines = byKey.values.toList()
    ..sort((a, b) {
      final aAt = a.occurredAt;
      final bAt = b.occurredAt;
      if (aAt == null && bAt == null) return 0;
      if (aAt == null) return 1;
      if (bAt == null) return -1;
      return bAt.compareTo(aAt);
    });
  return lines;
}

String? _prefer(String? current, String? incoming) {
  final existing = (current ?? '').trim();
  if (existing.isNotEmpty) return current;
  final next = (incoming ?? '').trim();
  return next.isEmpty ? current : incoming;
}

DateTime? _later(DateTime? current, DateTime? incoming) {
  if (current == null) return incoming;
  if (incoming == null) return current;
  return incoming.isAfter(current) ? incoming : current;
}
