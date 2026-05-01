import 'dart:async';

import '../../infrastructure/database/redis/redis_service.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Runs a daily purge at **UTC midnight**: removes archived live-feed
/// rows and anything older than the current UTC calendar day from Redis
/// (`activities:user:*`, `activities:global`).
/// CONTRACT: Schedules a one-shot [Timer] to fire at the next **UTC** midnight,
/// triggers [RedisService.purgeStaleLiveFeedActivities], and reschedules itself.
/// Idempotent and safe to re-run (a missed run is picked up on next startup).
/// CONSTRAINTS: Owns its own [Timer] instance; [stop] must be called on
/// shutdown to release it.
class ActivityPurgeScheduler {
  final RedisService _redis;
  final DateTime Function() _now;

  Timer? _timer;
  bool _running = false;

  ActivityPurgeScheduler(
    this._redis, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// Starts the scheduler. Safe to call multiple times; extra calls are no-ops.
  void start() {
    if (_running) return;
    _running = true;
    _scheduleNext();
    print('[TRIAGE_PIPELINE] purge_scheduler_started next=${_nextMidnightUtc()}');
  }

  /// Cancels the next scheduled purge. Running purges already in-flight will
  /// complete before the scheduler unwinds.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }

  /// Exposed for tests and manual triggers (e.g. an admin-only endpoint).
  Future<Map<String, int>> runNow() async {
    return await _redis.purgeStaleLiveFeedActivities();
  }

  DateTime _nextMidnightUtc() {
    final now = _now().toUtc();
    return DateTime.utc(now.year, now.month, now.day).add(
      const Duration(days: 1),
    );
  }

  void _scheduleNext() {
    if (!_running) return;
    final delay = _nextMidnightUtc().difference(_now().toUtc());
    // Guard against zero/negative delays if we cross midnight exactly.
    final safeDelay = delay.isNegative ? const Duration(minutes: 1) : delay;
    _timer = Timer(safeDelay, _runAndReschedule);
  }

  Future<void> _runAndReschedule() async {
    try {
      final removed = await _redis.purgeStaleLiveFeedActivities();
      print(
        '[TRIAGE_PIPELINE] purge_cycle_complete removed_keys=${removed.length}',
      );
    } catch (error) {
      print('[TRIAGE_PIPELINE] purge_cycle_error error=$error');
    } finally {
      _scheduleNext();
    }
  }
}
