import 'dart:async';

import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/repositories/abs_i_activity_repository.dart';
import '../../domain/repositories/abs_i_user_repository.dart';
import '../../infrastructure/database/redis/redis_service.dart';
import 'activity_live_publisher.dart';
import 'unified_activity_fetcher.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Background poller that fills the live bus when webhooks are absent.
/// CONTRACT: Skips a provider when Redis live ingest is fresh (webhook winning).
/// CONSTRAINTS: Same persist path as webhooks; dedup via createActivity.
class ActivityLivePollScheduler {
  ActivityLivePollScheduler(
    this._fetcher,
    this._users,
    this._activities,
    this._redis,
    this._publisher, {
    Duration interval = const Duration(seconds: 45),
    Duration lookback = const Duration(minutes: 20),
    Duration webhookFreshness = const Duration(minutes: 2),
    DateTime Function()? now,
    bool tickImmediately = true,
  }) : _interval = interval,
       _lookback = lookback,
       _webhookFreshness = webhookFreshness,
       _now = now ?? DateTime.now,
       _tickImmediately = tickImmediately;

  final UnifiedActivityFetcher _fetcher;
  final IUserRepository _users;
  final AbsIActivityRepository _activities;
  final RedisService _redis;
  final ActivityLivePublisher _publisher;
  final Duration _interval;
  final Duration _lookback;
  final Duration _webhookFreshness;
  final DateTime Function() _now;
  final bool _tickImmediately;

  Timer? _timer;
  bool _running = false;
  bool _tickInFlight = false;

  static const _patProviders = {
    'github',
    'gitlab',
    'bitbucket',
    'jira',
    'linear',
    'phorge',
  };

  void start() {
    if (_running) return;
    _running = true;
    if (_tickImmediately) unawaited(_tick());
    _timer = Timer.periodic(_interval, (_) => unawaited(_tick()));
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }

  Future<void> runNow() => _tick();

  Future<void> _tick() async {
    if (!_running || _tickInFlight) return;
    _tickInFlight = true;
    try {
      final stale = <String>{};
      for (final providerId in _patProviders) {
        final last = await _redis.getLiveIngestLastSuccess(providerId);
        if (last == null ||
            _now().toUtc().difference(last) > _webhookFreshness) {
          stale.add(providerId);
        }
      }
      if (stale.isEmpty) return;

      final usersResult = await _users.getUsers();
      final users = usersResult.getOrElse((_) => const <User>[]);
      if (users.isEmpty) return;

      final end = _now().toUtc();
      final start = end.subtract(_lookback);
      final fetched = await _fetcher.fetchAll(
        users: users,
        start: start,
        end: end,
        authoredOnly: true,
        providerIds: stale,
      );

      final ingestedProviders = <String>{};
      for (final activity in fetched) {
        final created = await _activities.createActivity(activity);
        if (created.isLeft()) {
          final message =
              created.getLeft().toNullable()?.message.toLowerCase() ?? '';
          if (message.contains('duplicate') || message.contains('unique')) {
            continue;
          }
          continue;
        }
        await _publisher.publish(activity);
        ingestedProviders.add(_providerIdOf(activity));
      }
      for (final providerId in ingestedProviders) {
        if (providerId.isEmpty) continue;
        await _redis.recordLiveIngestSuccess(providerId);
      }
    } catch (e) {
      print('[LIVE_POLLER] tick_failed error=$e');
    } finally {
      _tickInFlight = false;
    }
  }

  String _providerIdOf(Activity activity) {
    return activity.provider.name.trim().toLowerCase();
  }
}
