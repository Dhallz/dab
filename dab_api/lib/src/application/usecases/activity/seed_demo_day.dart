import 'package:fpdart/fpdart.dart' hide Group;
import 'package:uuid/uuid.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/daily_report_date.dart';
import '../../../domain/core/demo_day_catalog.dart';
import '../../../domain/core/demo_group_spec.dart';
import '../../../domain/core/demo_teammate_spec.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/org_calendar.dart';
import '../../../domain/core/report_subject_key.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/group/group.dart';
import '../../../domain/entities/group/group_type.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/entities/user/daily_report_line.dart';
import '../../../domain/entities/user/daily_report_line_role.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/contracts/ports/abs_i_demo_activity_store.dart';
import '../../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../../domain/contracts/ports/abs_i_presence_broadcaster.dart';
import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import '../../../domain/contracts/repositories/abs_i_activity_repository.dart';
import '../../../domain/contracts/repositories/abs_i_auth_repository.dart';
import '../../../domain/contracts/repositories/abs_i_daily_report_repository.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_system_settings_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';
import '../../services/activity_live_publisher.dart';
import 'seed_demo_day_result.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Seeds a screenshot-ready day for Dashboard, Following, Reports, Explorer.
/// CONTRACT: Typed provider activities, Redis live fan-out, demo search store,
/// Follow pins, and a daily report. Gated by [isEnabled].
/// Team mode creates/reuses [kDemoTeamRoster] accounts and varies each person.
/// Roster inbound authors stay on that roster; the caller is still seeded.
class SeedDemoDay {
  SeedDemoDay({
    required AbsIAuthRepository auth,
    required AbsIProviderConfigRepository configs,
    required AbsISystemSettingsRepository settings,
    required AbsIActivityRepository activities,
    required AbsILiveFeedStore liveFeed,
    required AbsIPresenceBroadcaster presence,
    required AbsIDemoActivityStore demoStore,
    required AbsIActivityFollowRepository follows,
    required AbsIDailyReportRepository reports,
    required IUserRepository directory,
    required bool Function() isEnabled,
    ActivityLivePublisher? livePublisher,
    DateTime Function()? now,
  }) : _auth = auth,
       _configs = configs,
       _settings = settings,
       _activities = activities,
       _liveFeed = liveFeed,
       _presence = presence,
       _demoStore = demoStore,
       _follows = follows,
       _reports = reports,
       _directory = directory,
       _isEnabled = isEnabled,
       _livePublisher = livePublisher,
       _now = now ?? DateTime.now;

  final AbsIAuthRepository _auth;
  final AbsIProviderConfigRepository _configs;
  final AbsISystemSettingsRepository _settings;
  final AbsIActivityRepository _activities;
  final AbsILiveFeedStore _liveFeed;
  final AbsIPresenceBroadcaster _presence;
  final AbsIDemoActivityStore _demoStore;
  final AbsIActivityFollowRepository _follows;
  final AbsIDailyReportRepository _reports;
  final IUserRepository _directory;
  final bool Function() _isEnabled;
  final ActivityLivePublisher? _livePublisher;
  final DateTime Function() _now;
  static const _uuid = Uuid();

  /// [userId] is the caller (always included in team mode). [userIds] seeds
  /// those existing accounts instead of the roster. [team] creates/reuses
  /// [teamSize] named demo people (default 20, clamp 2–40).
  Future<Either<Failure, SeedDemoDayResult>> execute({
    required String userId,
    required String date,
    bool team = false,
    int teamSize = 20,
    List<String> userIds = const [],
  }) async {
    if (!_isEnabled()) {
      return const Left(
        AuthFailure(
          'Demo seed is disabled (set DAB_ENABLE_MOCK=true or APP_ENV=development)',
        ),
      );
    }
    final trimmedUserId = userId.trim();
    if (trimmedUserId.isEmpty) {
      return const Left(ValidationFailure('userId is required'));
    }
    final callerResult = await _auth.findById(trimmedUserId);
    if (callerResult.isLeft()) {
      return Left(callerResult.getLeft().toNullable()!);
    }
    final caller = callerResult.getOrElse((_) => null);
    if (caller == null) {
      return const Left(NotFoundFailure('User not found'));
    }

    final timezoneId = await loadOrgTimezoneId(_settings);
    final now = _now().toUtc();
    final todayKey = orgDayKeyFromUtc(timezoneId, now);
    final trimmedDate = date.trim();
    final day = trimmedDate.isEmpty
        ? todayKey
        : parseDailyReportDate(trimmedDate);
    if (day == null) {
      return const Left(ValidationFailure('Date must be YYYY-MM-DD'));
    }
    final dashboardVisible = day == todayKey;
    final createdAt = dashboardVisible
        ? now
        : _noonUtc(day, timezoneId) ?? now;

    final configsResult = await _configs.getConfigs();
    if (configsResult.isLeft()) {
      return Left(configsResult.getLeft().toNullable()!);
    }
    final active = configsResult
        .getOrElse((_) => const [])
        .where((config) => config.isActive)
        .map((config) => config.id.trim().toLowerCase())
        .where((id) => id.isNotEmpty)
        .toSet();
    final providerIds = active.isEmpty ? const <String>{} : active;

    final explicitIds = [
      for (final id in userIds)
        if (id.trim().isNotEmpty) id.trim(),
    ];
    final useTeam = team || explicitIds.isNotEmpty;
    var createdUserCount = 0;
    final targets = <User>[];

    if (explicitIds.isNotEmpty) {
      final seen = <String>{};
      for (final id in explicitIds) {
        if (!seen.add(id)) continue;
        final found = await _auth.findById(id);
        if (found.isLeft()) {
          return Left(found.getLeft().toNullable()!);
        }
        final user = found.getOrElse((_) => null);
        if (user == null) {
          return Left(NotFoundFailure('User not found: $id'));
        }
        targets.add(user);
      }
      if (!seen.contains(caller.id)) {
        targets.insert(0, caller);
      }
    } else if (useTeam) {
      final size = teamSize < 2 ? 20 : (teamSize > 40 ? 40 : teamSize);
      targets.add(caller);
      final domain = await _emailDomain();
      for (final spec in kDemoTeamRoster) {
        if (targets.length >= size) break;
        final ensured = await _ensureTeammate(spec, domain, now);
        if (ensured.isLeft()) {
          return Left(ensured.getLeft().toNullable()!);
        }
        final pair = ensured.getOrElse((_) => throw StateError('left'));
        if (pair.user.id == caller.id) continue;
        if (targets.any((user) => user.id == pair.user.id)) continue;
        targets.add(pair.user);
        if (pair.created) createdUserCount++;
      }
    } else {
      targets.add(caller);
    }

    var activityCount = 0;
    var followCount = 0;
    var reportLineCount = 0;
    final seededProviders = <String>{};

    for (var i = 0; i < targets.length; i++) {
      final user = targets[i];
      final persisted = await _persistUserDay(
        user: user,
        teammates: _catalogTeammates(user, caller, targets),
        variant: i,
        dense: user.id == caller.id,
        day: day,
        createdAt: createdAt,
        now: now,
        providerIds: providerIds,
      );
      if (persisted.isLeft()) {
        return Left(persisted.getLeft().toNullable()!);
      }
      final counts = persisted.getOrElse((_) => throw StateError('left'));
      activityCount += counts.activityCount;
      followCount += counts.followCount;
      reportLineCount += counts.reportLineCount;
      seededProviders.addAll(counts.providers);
    }

    var groupCount = 0;
    if (targets.length >= 2) {
      final domain = await _emailDomain();
      final groups = await _seedDirectoryGroups(targets, domain);
      if (groups.isLeft()) {
        return Left(groups.getLeft().toNullable()!);
      }
      groupCount = groups.getOrElse((_) => 0);
    }

    return Right(
      SeedDemoDayResult(
        date: day,
        userId: caller.id,
        activityCount: activityCount,
        followCount: followCount,
        reportLineCount: reportLineCount,
        dashboardVisible: dashboardVisible,
        providers: seededProviders.toList()..sort(),
        userCount: targets.length,
        createdUserCount: createdUserCount,
        userIds: [for (final user in targets) user.id],
        groupCount: groupCount,
      ),
    );
  }

  /// Roster cards peer with other demo people, not the authenticated operator.
  /// The operator still gets a seeded day; inbound rows use the roster.
  List<User> _catalogTeammates(User user, User caller, List<User> targets) {
    final roster = [
      for (final mate in targets)
        if (mate.id != caller.id) mate,
    ];
    if (roster.length < 2) return targets;
    if (user.id == caller.id) return [user, ...roster];
    return roster;
  }

  Future<Either<Failure, int>> _seedDirectoryGroups(
    List<User> targets,
    String domain,
  ) async {
    final byHandle = <String, User>{};
    for (final user in targets) {
      final handle = user.phorgeUsername?.trim().toLowerCase();
      if (handle != null && handle.isNotEmpty) {
        byHandle.putIfAbsent(handle, () => user);
      }
    }
    var count = 0;
    for (final spec in kDemoTeamGroups) {
      final members = [
        for (final handle in spec.memberHandles)
          if (byHandle[handle] != null) byHandle[handle]!,
      ];
      if (members.length < 2) continue;
      final group = Group(
        id: _uuid.v5(Namespace.url.value, 'demo-group|${spec.handle}|$domain'),
        name: spec.name,
        type: GroupType.custom,
        members: members,
      );
      final saved = await _directory.saveGroup(group);
      if (saved.isLeft()) {
        return Left(saved.getLeft().toNullable()!);
      }
      count++;
    }
    return Right(count);
  }

  Future<String> _emailDomain() async {
    final stored = await _settings.getAllowedDomain();
    final value = stored.getOrElse((_) => null)?.trim().toLowerCase();
    if (value != null && value.isNotEmpty) return value;
    return 'demo.dab.local';
  }

  Future<Either<Failure, ({User user, bool created})>> _ensureTeammate(
    DemoTeammateSpec spec,
    String domain,
    DateTime now,
  ) async {
    final email = '${spec.handle}@$domain';
    final existing = await _auth.findByEmail(email);
    if (existing.isLeft()) {
      return Left(existing.getLeft().toNullable()!);
    }
    final found = existing.getOrElse((_) => null);
    if (found != null) {
      return Right((user: found, created: false));
    }
    final user = User(
      id: _uuid.v5(Namespace.url.value, 'demo-user|${spec.handle}|$domain'),
      name: spec.name,
      email: email,
      passwordHash: '',
      role: spec.role,
      phorgeUsername: spec.handle,
      createdAt: now,
    );
    final created = await _auth.createUser(user);
    if (created.isLeft()) {
      return Left(created.getLeft().toNullable()!);
    }
    return Right((user: user, created: true));
  }

  Future<Either<Failure, ({
    int activityCount,
    int followCount,
    int reportLineCount,
    Set<String> providers,
  })>>
  _persistUserDay({
    required User user,
    required List<User> teammates,
    required int variant,
    required bool dense,
    required String day,
    required DateTime createdAt,
    required DateTime now,
    required Set<String> providerIds,
  }) async {
    final activities = buildDemoDayActivities(
      user: user,
      date: day,
      providerIds: providerIds,
      createdAt: createdAt,
      teammates: teammates,
      variant: variant,
      dense: dense,
    );

    for (final activity in activities) {
      final created = await _activities.createActivity(activity);
      if (created.isLeft()) {
        final message = created.getLeft().toNullable()!.message.toLowerCase();
        final duplicate =
            message.contains('duplicate') ||
            message.contains('unique constraint') ||
            message.contains('already exists');
        if (!duplicate) {
          return Left(created.getLeft().toNullable()!);
        }
      }
      await ActivityLivePublisher.emit(
        redis: _liveFeed,
        presence: _presence,
        activity: activity,
        publisher: _livePublisher,
        replaceExisting: true,
      );
    }

    final seededProviders = <String>{
      for (final activity in activities)
        if (activity.reportProviderId.trim().isNotEmpty)
          activity.reportProviderId,
    };
    for (final providerId in seededProviders) {
      await _liveFeed.recordLiveIngestSuccess(providerId);
    }

    await _demoStore.replaceDay(
      userId: user.id,
      date: day,
      activities: activities,
    );

    var followCount = 0;
    final pinned = <String>{};
    for (final activity in activities) {
      final providerId = activity.provider.followProviderId;
      final objectKey = activity.provider.followObjectKey;
      if (providerId == null || objectKey == null) continue;
      final pinKey = '$providerId|$objectKey';
      if (!pinned.add(pinKey)) continue;
      final follow = ActivityFollow(
        id: _uuid.v5(
          Namespace.url.value,
          'follow|${user.id}|$providerId|$objectKey',
        ),
        userId: user.id,
        providerId: providerId,
        objectKey: objectKey,
        title: activity.title,
        url: activity.url,
        createdAt: now,
      );
      final saved = await _follows.upsert(follow);
      if (saved.isRight()) followCount++;
    }

    final reportLines = [
      for (final activity in activities)
        if (!activity.isFollowLane)
          DailyReportLine(
            subjectKey: activity.reportSubjectKey,
            included: true,
            note: activity.senderUserId == user.id
                ? 'Shipped on the demo day'
                : 'Inbound — worth a mention',
            role: activity.senderUserId == user.id
                ? DailyReportLineRole.authored
                : DailyReportLineRole.directed,
            title: activity.title,
            url: activity.url,
            occurredAt: activity.createdAt.toUtc(),
            providerId: activity.reportProviderId,
          ),
    ];
    final report = DailyReport(
      id: _uuid.v5(Namespace.url.value, 'day-report|${user.id}|$day'),
      userId: user.id,
      date: day,
      lines: reportLines,
    );
    final savedReport = await _reports.save(report);
    if (savedReport.isLeft()) {
      return Left(savedReport.getLeft().toNullable()!);
    }

    return Right((
      activityCount: activities.length,
      followCount: followCount,
      reportLineCount: reportLines.length,
      providers: seededProviders,
    ));
  }

  DateTime? _noonUtc(String day, String timezoneId) {
    final parts = day.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final dayNum = int.tryParse(parts[2]);
    if (year == null || month == null || dayNum == null) return null;
    return orgLocalWallTimeUtc(
      orgTimezoneId: timezoneId,
      year: year,
      month: month,
      day: dayNum,
      hour: 12,
    );
  }
}
