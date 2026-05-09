import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdentityLinkDialog extends ConsumerStatefulWidget {
  final UserIdentity identity;

  const IdentityLinkDialog({super.key, required this.identity});

  @override
  ConsumerState<IdentityLinkDialog> createState() => _IdentityLinkDialogState();
}

class _IdentityLinkDialogState extends ConsumerState<IdentityLinkDialog> {
  final controller = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.identity.userId;
    usernameController.text = widget.identity.externalUsername ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF0F172A)),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
      ),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Update Identity Link',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Associate ${widget.identity.externalId} with a DAB user account.',
              style: const TextStyle(
                color: AppColors.onSurfaceVariantLow,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white.withValues(alpha: 0.05),
                labelText: 'Target User ID',
                labelStyle: const TextStyle(
                  color: AppColors.onSurfaceVariantLow,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.onSurfaceVariantLow,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: usernameController,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white.withValues(alpha: 0.05),
                labelText: 'Provider Username (optional)',
                labelStyle: const TextStyle(
                  color: AppColors.onSurfaceVariantLow,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.alternate_email,
                  color: AppColors.onSurfaceVariantLow,
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.onSurfaceVariantLow),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentIndigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              ref
                  .read(adminNotifierProvider.notifier)
                  .linkIdentity(
                    userId: controller.text.trim().isEmpty
                        ? widget.identity.userId
                        : controller.text.trim(),
                    providerId: widget.identity.providerId,
                    externalId: widget.identity.externalId,
                    externalUsername: usernameController.text.trim(),
                  );
              Navigator.pop(context);
            },
            child: const Text(
              'Update Link',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
