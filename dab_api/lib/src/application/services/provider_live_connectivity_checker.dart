import '../../domain/entities/provider/provider_connectivity_report.dart';
import '../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../infrastructure/sources/discord/discord_gateway_client.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Evaluates Live-section connectivity using strict external signals.
/// CONTRACT: Green only when a recent ingestion was recorded in Redis (7-day TTL).
/// Discord additionally requires an active Gateway WebSocket session.
class ProviderLiveConnectivityChecker {
  ProviderLiveConnectivityChecker(this._redis, this._discordGateway);

  final AbsILiveFeedStore _redis;
  final DiscordGatewayClient _discordGateway;

  static const _noEventMessage =
      'No live event received in the last 7 days. Configure Live secrets and click Try to run a webhook test delivery.';

  Future<ProviderSectionResult> check(String providerId) async {
    final normalized = _normalizeProviderId(providerId);

    if (normalized == 'discord') {
      return _checkDiscord();
    }

    final last = await _redis.getLiveIngestLastSuccess(normalized);
    if (last == null) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: _noEventMessage,
      );
    }
    return ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message:
          'Last live event ${_formatAgo(DateTime.now().toUtc().difference(last))}',
    );
  }

  Future<ProviderSectionResult> _checkDiscord() async {
    if (!_discordGateway.isRunning || !_discordGateway.isConnected) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Discord Gateway is not connected. Verify bot token, guild ID, and channel access.',
      );
    }
    final last = await _redis.getLiveIngestLastSuccess('discord');
    if (last == null) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: _noEventMessage,
      );
    }
    return ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message:
          'Gateway connected; last message ${_formatAgo(DateTime.now().toUtc().difference(last))}',
    );
  }

  static String _normalizeProviderId(String providerId) {
    final id = providerId.trim().toLowerCase();
    return id == 'phabricator' ? 'phorge' : id;
  }

  static String _formatAgo(Duration ago) {
    if (ago.inMinutes < 1) return 'just now';
    if (ago.inHours < 1) return '${ago.inMinutes}m ago';
    if (ago.inDays < 1) return '${ago.inHours}h ago';
    return '${ago.inDays}d ago';
  }
}

/// Short-circuits live and polling when core authentication fails.
ProviderSectionResult coreFailurePropagation(String message) {
  return ProviderSectionResult(
    status: ConnectivitySectionStatus.failure,
    message: message,
  );
}

ProviderConnectivityReport buildReport({
  required ProviderSectionResult core,
  required ProviderSectionResult live,
  required ProviderSectionResult polling,
}) {
  final aggregate = ProviderConnectivityReport.computeAggregate(
    live: live,
    polling: polling,
  );
  return ProviderConnectivityReport(
    aggregate: aggregate,
    summaryMessage: ProviderConnectivityReport.summarize(
      aggregate: aggregate,
      live: live,
      polling: polling,
    ),
    core: core,
    live: live,
    polling: polling,
  );
}
