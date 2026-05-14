import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_activity_uuid.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_board_column.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_transaction/phorge_transaction_data.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/sprint_context.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';

/// [ARCH: DOMAIN]
/// ROLE: Map one Phorge task transaction onto a unified-feed [`Activity`], if the event kind is surfaced.
Activity? mapPhorgeTaskTransactionToActivity(
  PhorgeTransactionData tx,
  PhorgeTaskBundle bundle,
  Map<String?, User> authorMap,
  User? defaultUser,
) {
  String content = 'Updated task';
  SprintContext? sprintContext;

  if (tx.type == 'comment') {
    content = tx.commentText?.trim() ?? 'Commented on task';
  } else if (tx.type == 'status') {
    content = 'Changed status from ${tx.oldValue} to ${tx.newValue}';
    sprintContext = SprintContext(
      tag: bundle.sprintTag,
      columnFrom: tx.oldValue?.toString(),
      columnTo: tx.newValue?.toString(),
    );
  } else if (tx.type == 'columns' || tx.type == 'core:columns') {
    content = 'Moved task on the sprint board';
    sprintContext = SprintContext(
      tag: bundle.sprintTag,
      columnFrom: phorgeTaskBoardColumnFromWire(tx.oldValue) ?? 'board',
      columnTo: phorgeTaskBoardColumnFromWire(tx.newValue) ?? 'board',
    );
  } else if (tx.type == 'projects') {
    content = 'Updated project tags';
  } else {
    return null;
  }

  final author = authorMap[tx.authorPHID] ?? defaultUser;
  if (author == null) return null;

  return Activity(
    id: phorgeTaskBundleActivityUuid('phorge-tx-${tx.id}'),
    userId: author.id,
    authorName: (author.phorgeUsername ?? '').trim().isNotEmpty
        ? author.phorgeUsername!.trim()
        : author.name,
    commentCount: tx.type == 'comment' ? 1 : 0,
    provider: PhorgeTaskProvider(
      taskPhid: bundle.task.phid,
      sprintContext: sprintContext,
      tags: bundle.task.projectPHIDs.join(','),
    ),
    title: '[T${bundle.task.id}] ${bundle.task.name}',
    content: content,
    url: '/T${bundle.task.id}',
    createdAt: tx.dateCreated,
  );
}
