import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_data.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_transaction/phorge_transaction_data.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Aggregated DTO for Phorge Task processing.
/// CONTRACT: Provides a complete snapshot of a Task and its events (Transactions).
///
/// Mapped to [Activity] via [OnPhorgeTaskBundle.toActivities].
class PhorgeTaskBundle {
  /// The core task metadata (PHID, name, status).
  final PhorgeTaskData task;

  /// The list of events/moves/comments associated with this task.
  final List<PhorgeTransactionData> transactions;

  /// the active sprint tag context for this fetching window.
  final String sprintTag;

  PhorgeTaskBundle({
    required this.task,
    required this.transactions,
    required this.sprintTag,
  });
}
