import 'package:dab_api/src/domain/dtos/phorge/phorge_task/map_phorge_task_transaction.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';

/// [ARCH: DOMAIN]
/// ROLE: Interprets Phorge transactions as [`Activity`] feed rows.
extension OnPhorgeTaskBundle on PhorgeTaskBundle {
  /// Iterates transactions and skips irrelevant noise (VCS/Edits).
  List<Activity> toActivities(List<User> users) {
    if (transactions.isEmpty) return [];

    final activities = <Activity>[];

    final userMap = {for (final u in users) u.phorgePhid: u};
    User? defaultUser;
    if (users.isNotEmpty) {
      defaultUser = users.first;
    }

    for (final tx in transactions) {
      if (tx.type == 'vcs' || tx.type == 'edit') continue;

      final activity = mapPhorgeTaskTransactionToActivity(
        tx,
        this,
        userMap,
        defaultUser,
      );
      if (activity != null) {
        activities.add(activity);
      }
    }

    return activities;
  }
}
