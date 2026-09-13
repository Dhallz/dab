import 'package:dab_app/domain/entities/user/user_role.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Admin dialog to create a new user account (name, email, password,
/// role). The only account creation path after bootstrap.
class UserCreateDialog extends ConsumerStatefulWidget {
  const UserCreateDialog({super.key});

  @override
  ConsumerState<UserCreateDialog> createState() => _UserCreateDialogState();
}

class _UserCreateDialogState extends ConsumerState<UserCreateDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.standard;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      !_isSubmitting &&
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().contains('@') &&
      _passwordController.text.isNotEmpty;

  Future<void> _submit() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isSubmitting = true);
    final success = await ref
        .read(adminNotifierProvider.notifier)
        .createUser(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.userCreatedSnack)));
    } else {
      final error = ref.read(adminNotifierProvider).errorMessage;
      messenger.showSnackBar(
        SnackBar(content: Text(error ?? l10n.authErrorFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        l10n.userDialogCreateTitle,
        style: TextStyle(fontWeight: FontWeight.w900, color: cs.onSurface),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.userDialogCreateSubtitle,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: cs.onSurface),
            decoration: _fieldDecoration(context, l10n.userFieldName),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: cs.onSurface),
            decoration: _fieldDecoration(context, l10n.userFieldEmail),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            onChanged: (_) => setState(() {}),
            obscureText: true,
            style: TextStyle(color: cs.onSurface),
            decoration: _fieldDecoration(context, l10n.userFieldPassword),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<UserRole>(
            initialValue: _selectedRole,
            items: UserRole.values
                .map(
                  (role) => DropdownMenuItem(
                    value: role,
                    child: Text(role.name),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(
              () => _selectedRole = value ?? UserRole.standard,
            ),
            decoration: _fieldDecoration(context, l10n.userFieldRole),
            dropdownColor: cs.surfaceContainerHigh,
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
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
          onPressed: _canSubmit ? _submit : null,
          child: _isSubmitting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  l10n.userDialogCreateSubmit,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
