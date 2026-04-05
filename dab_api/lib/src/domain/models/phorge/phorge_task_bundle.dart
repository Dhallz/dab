import 'package:dab_api/src/domain/models/phorge/phorge_task_data.dart';
import 'package:dab_api/src/domain/models/phorge/phorge_transaction_data.dart';

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Aggregated DTO for Phorge Task processing.
/// CONTRACT: Provides a complete snapshot of a Task and its events (Transactions).
/// CONSTRAINTS: Used exclusively by [PhorgeTaskMapper].
///
/// This bundle is a convenience model that allows the Mapper to have all 
/// context (Task metadata + Transaction logs + Sprint info) in a single pass.
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
