import 'package:dab_app/domain/entities/user/user_identity_status.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final UserIdentityStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
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
        status.name.toUpperCase(),
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
