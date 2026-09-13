import 'package:dab_app/domain/entities/user/user_identity_status.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final UserIdentityStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLinked = status == UserIdentityStatus.linked;
    final isPending = status == UserIdentityStatus.pending;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            (isLinked ? Colors.green : (isPending ? Colors.orange : Colors.red))
                .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color:
              (isLinked
                      ? Colors.green
                      : (isPending ? Colors.orange : Colors.red))
                  .withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        switch (status) {
          UserIdentityStatus.linked => l10n.adminIdentityStatusLinked,
          UserIdentityStatus.pending => l10n.adminIdentityStatusPending,
          UserIdentityStatus.failed => l10n.adminIdentityStatusFailed,
        },
        style: TextStyle(
          color: isLinked
              ? Colors.green
              : (isPending ? Colors.orange : Colors.redAccent),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
