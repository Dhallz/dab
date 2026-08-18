import 'dart:async';

import '../../domain/core/org_calendar.dart' as org_calendar;
import '../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../domain/contracts/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Runs a daily purge at **org-timezone midnight**: removes archived live-feed
/// rows and anything older than the current org calendar day from Redis
/// (`activities:user:*`, `activities:global`).
/// CONTRACT: Schedules a one-shot [Timer] to fire at the next org midnight,
/// triggers live-feed purge, and reschedules itself.
/// Idempotent and safe to re-run (a missed run is picked up on next startup).
/// CONSTRAINTS: Owns its own [Timer] instance; [stop] must be called on
/// shutdown to release it.
class ActivityPurgeScheduler {
  final AbsILiveFeedStore _redis;
  final AbsISystemSettingsRepository _settings;
  final DateTime Function() _now;

  Timer? _timer;
  bool _running = false;

  ActivityPurgeScheduler(
    this._redis,
    this._settings, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// Starts the scheduler. Safe to call multiple times; extra calls are no-ops.
  void start() {
    if (_running) return;
    _running = true;
    _scheduleNext();
    print('[TRIAGE_PIPELINE] purge_scheduler_started');
  }

  /// Cancels the pending timer and schedules the next org midnight purge.
  void reschedule() {
    if (!_running) return;
    _timer?.cancel();
    _scheduleNext();
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

  Future<DateTime> _nextOrgMidnightUtc() async {
    final orgTimezoneId = await loadOrgTimezoneId(_settings);
    return org_calendar.nextOrgMidnightUtc(orgTimezoneId, _now().toUtc());
  }

  void _scheduleNext() {
    if (!_running) return;
    unawaited(_scheduleNextAsync());
  }

  Future<void> _scheduleNextAsync() async {
    if (!_running) return;
    final next = await _nextOrgMidnightUtc();
    final delay = next.difference(_now().toUtc());
    final safeDelay = delay.isNegative ? const Duration(minutes: 1) : delay;
    print('[TRIAGE_PIPELINE] purge_scheduler_next next=$next delay=$safeDelay');
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
