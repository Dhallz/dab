import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/daily_report_date.dart';
import '../../../domain/core/demo_day_catalog.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/org_calendar.dart';
import '../../../domain/core/report_subject_key.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/entities/user/daily_report_line.dart';
import '../../../domain/entities/user/daily_report_line_role.dart';
import '../../../domain/contracts/ports/abs_i_demo_activity_store.dart';
import '../../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../../domain/contracts/ports/abs_i_presence_broadcaster.dart';
import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import '../../../domain/contracts/repositories/abs_i_activity_repository.dart';
import '../../../domain/contracts/repositories/abs_i_auth_repository.dart';
import '../../../domain/contracts/repositories/abs_i_daily_report_repository.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_system_settings_repository.dart';
import '../../services/activity_live_publisher.dart';
import 'seed_demo_day_result.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Seeds a screenshot-ready day for Dashboard, Following, Reports, Explorer.
/// CONTRACT: Typed provider activities, Redis live fan-out, demo search store,
/// Follow pins, and a daily report. Gated by [isEnabled].
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
  final bool Function() _isEnabled;
  final ActivityLivePublisher? _livePublisher;
  final DateTime Function() _now;
  static const _uuid = Uuid();

  Future<Either<Failure, SeedDemoDayResult>> execute({
    required String userId,
    required String date,
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
    final userResult = await _auth.findById(trimmedUserId);
    if (userResult.isLeft()) {
      return Left(userResult.getLeft().toNullable()!);
    }
    final user = userResult.getOrElse((_) => null);
    if (user == null) {
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

    final activities = buildDemoDayActivities(
      user: user,
      date: day,
      providerIds: providerIds,
      createdAt: createdAt,
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

    return Right(
      SeedDemoDayResult(
        date: day,
        userId: user.id,
        activityCount: activities.length,
        followCount: followCount,
        reportLineCount: reportLines.length,
        dashboardVisible: dashboardVisible,
        providers: seededProviders.toList()..sort(),
      ),
    );
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
