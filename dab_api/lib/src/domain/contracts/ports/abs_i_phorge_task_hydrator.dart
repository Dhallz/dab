import '../../dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Hydrates a Phorge Herald webhook into a task bundle for ingest.
/// CONTRACT: Herald payloads carry object/transaction PHIDs only; the
/// implementation re-fetches via Conduit using the same calls as polling.
abstract interface class AbsIPhorgeTaskHydrator {
  /// Fetches the task plus the notified transactions, or null when missing.
  Future<PhorgeTaskBundleDto?> fetchBundleForWebhook({
    required String taskPhid,
    required List<String> transactionPhids,
  });
}
