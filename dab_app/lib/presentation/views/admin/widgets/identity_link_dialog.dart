import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
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
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        l10n.identityDialogUpdateTitle,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: cs.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.identityLinkAssociateUser(widget.identity.externalId),
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            style: TextStyle(color: cs.onSurface),
            decoration: InputDecoration(
              filled: true,
              fillColor: cs.surfaceContainerLow,
              labelText: l10n.identityTargetUserId,
              labelStyle: TextStyle(
                color: cs.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: usernameController,
            style: TextStyle(color: cs.onSurface),
            decoration: InputDecoration(
              filled: true,
              fillColor: cs.surfaceContainerLow,
              labelText: l10n.identityProviderUsernameOptionalLabel,
              labelStyle: TextStyle(
                color: cs.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                Icons.alternate_email,
                color: cs.onSurfaceVariant,
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
          child: Text(
            l10n.commonCancel,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
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
          child: Text(
            l10n.identityUpdateLink,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
