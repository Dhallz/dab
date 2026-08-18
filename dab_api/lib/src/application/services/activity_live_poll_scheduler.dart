import 'dart:async';

import '../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../domain/contracts/repositories/abs_i_activity_repository.dart';
import '../../domain/contracts/repositories/abs_i_user_repository.dart';
import 'activity_live_publisher.dart';
import 'unified_activity_fetcher.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Background timer retained so DI and start/stop stay stable.
/// CONTRACT: Does **not** publish authored-only poll rows into the live inbox.
/// Explorer search still uses [UnifiedActivityFetcher] on demand.
/// CONSTRAINTS: Authored poll refill would put the viewer's own work on
/// Dashboard. Inbound rows come from webhooks / Gateway only.
class ActivityLivePollScheduler {
  ActivityLivePollScheduler(
    UnifiedActivityFetcher fetcher,
    IUserRepository users,
    AbsIActivityRepository activities,
    AbsILiveFeedStore redis,
    ActivityLivePublisher publisher, {
    Duration interval = const Duration(seconds: 45),
    Duration lookback = const Duration(minutes: 20),
    Duration webhookFreshness = const Duration(minutes: 2),
    DateTime Function()? now,
    bool tickImmediately = true,
  }) : _interval = interval,
       _tickImmediately = tickImmediately {
    // Positional deps stay in the constructor so service_locator wiring is
    // unchanged. Authored live refill is intentionally disabled.
    Object.hash(
      fetcher,
      users,
      activities,
      redis,
      publisher,
      lookback,
      webhookFreshness,
      now,
    );
  }

  final Duration _interval;
  final bool _tickImmediately;

  Timer? _timer;
  bool _running = false;
  bool _tickInFlight = false;

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
      return;
    } finally {
      _tickInFlight = false;
    }
  }
}
