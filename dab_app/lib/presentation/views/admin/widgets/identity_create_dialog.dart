import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum IdentityCreateFocusField { externalId, externalUsername }

class IdentityCreateDialog extends ConsumerStatefulWidget {
  final List<User> users;
  final List<String> providerIds;
  final String? initialUserId;
  final String? initialProviderId;
  final String? initialExternalId;
  final String? initialExternalUsername;
  final IdentityCreateFocusField? initialFocusField;
  final bool isUpdateMode;

  const IdentityCreateDialog({
    super.key,
    required this.users,
    required this.providerIds,
    this.initialUserId,
    this.initialProviderId,
    this.initialExternalId,
    this.initialExternalUsername,
    this.initialFocusField,
    this.isUpdateMode = false,
  });

  @override
  ConsumerState<IdentityCreateDialog> createState() =>
      _IdentityCreateDialogState();
}

class _IdentityCreateDialogState extends ConsumerState<IdentityCreateDialog> {
  final _externalIdController = TextEditingController();
  final _externalUsernameController = TextEditingController();
  final _externalIdFocusNode = FocusNode();
  final _externalUsernameFocusNode = FocusNode();
  String? _selectedUserId;
  String? _selectedProviderId;

  @override
  void initState() {
    super.initState();
    _selectedUserId = widget.initialUserId;
    _selectedProviderId = widget.initialProviderId;
    _externalIdController.text = widget.initialExternalId ?? '';
    _externalUsernameController.text = widget.initialExternalUsername ?? '';
    if (widget.users.isNotEmpty) {
      _selectedUserId ??= widget.users.first.id;
    }
    if (widget.providerIds.isNotEmpty) {
      _selectedProviderId ??= widget.providerIds.first;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      switch (widget.initialFocusField) {
        case IdentityCreateFocusField.externalId:
          _externalIdFocusNode.requestFocus();
          _externalIdController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _externalIdController.text.length,
          );
          break;
        case IdentityCreateFocusField.externalUsername:
          _externalUsernameFocusNode.requestFocus();
          _externalUsernameController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _externalUsernameController.text.length,
          );
          break;
        case null:
          break;
      }
    });
  }

  @override
  void dispose() {
    _externalIdController.dispose();
    _externalUsernameController.dispose();
    _externalIdFocusNode.dispose();
    _externalUsernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final canSubmit =
        _selectedUserId != null &&
        _selectedProviderId != null &&
        _externalIdController.text.trim().isNotEmpty;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        widget.isUpdateMode
            ? l10n.identityDialogUpdateTitle
            : l10n.identityDialogCreateTitle,
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
            l10n.identityDialogCreateSubtitle,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedUserId,
            items: widget.users
                .map(
                  (u) => DropdownMenuItem(
                    value: u.id,
                    child: Text('${u.name} (${u.id})'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedUserId = value),
            decoration: _fieldDecoration(context, l10n.identityFieldDabUser),
            dropdownColor: cs.surfaceContainerHigh,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedProviderId,
            items: widget.providerIds
                .map((id) => DropdownMenuItem(value: id, child: Text(id)))
                .toList(),
            onChanged: (value) => setState(() => _selectedProviderId = value),
            decoration: _fieldDecoration(context, l10n.identityFieldProvider),
            dropdownColor: cs.surfaceContainerHigh,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _externalIdController,
            focusNode: _externalIdFocusNode,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: cs.onSurface),
            decoration: _fieldDecoration(
              context,
              l10n.identityFieldExternalId,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _externalUsernameController,
            focusNode: _externalUsernameFocusNode,
            style: TextStyle(color: cs.onSurface),
            decoration: _fieldDecoration(
              context,
              l10n.identityFieldProviderUsernameOptional,
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
          onPressed: !canSubmit
              ? null
              : () {
                  ref
                      .read(adminNotifierProvider.notifier)
                      .linkIdentity(
                        userId: _selectedUserId!,
                        providerId: _selectedProviderId!,
                        externalId: _externalIdController.text.trim(),
                        externalUsername: _externalUsernameController.text
                            .trim(),
                      );
                  Navigator.pop(context);
                },
          child: Text(
            widget.isUpdateMode
                ? l10n.identityUpdateLink
                : l10n.identityCreateLink,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration(BuildContext context, String label) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      filled: true,
      fillColor: cs.surfaceContainerLow,
      labelText: label,
      labelStyle: TextStyle(color: cs.onSurfaceVariant),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
