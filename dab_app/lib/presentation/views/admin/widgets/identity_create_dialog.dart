import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:flutter/material.dart';

class IdentityCreateDialog extends StatefulWidget {
  final AdminBloc bloc;
  final List<User> users;
  final List<String> providerIds;

  const IdentityCreateDialog({
    super.key,
    required this.bloc,
    required this.users,
    required this.providerIds,
  });

  @override
  State<IdentityCreateDialog> createState() => _IdentityCreateDialogState();
}

class _IdentityCreateDialogState extends State<IdentityCreateDialog> {
  final _externalIdController = TextEditingController();
  final _externalUsernameController = TextEditingController();
  String? _selectedUserId;
  String? _selectedProviderId;

  @override
  void initState() {
    super.initState();
    if (widget.users.isNotEmpty) {
      _selectedUserId = widget.users.first.id;
    }
    if (widget.providerIds.isNotEmpty) {
      _selectedProviderId = widget.providerIds.first;
    }
  }

  @override
  void dispose() {
    _externalIdController.dispose();
    _externalUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        _selectedUserId != null &&
        _selectedProviderId != null &&
        _externalIdController.text.trim().isNotEmpty;

    return Theme(
      data: Theme.of(context).copyWith(
        dialogBackgroundColor: const Color(0xFF0F172A),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
      ),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Create Identity Link',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link a provider external identity to a DAB user.',
              style: TextStyle(
                color: AppColors.onSurfaceVariantLow,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedUserId,
              items: widget.users
                  .map(
                    (u) => DropdownMenuItem(
                      value: u.id,
                      child: Text('${u.name} (${u.id})'),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedUserId = value),
              decoration: _fieldDecoration('DAB User'),
              dropdownColor: const Color(0xFF0F172A),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedProviderId,
              items: widget.providerIds
                  .map(
                    (id) => DropdownMenuItem(
                      value: id,
                      child: Text(id),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedProviderId = value),
              decoration: _fieldDecoration('Provider'),
              dropdownColor: const Color(0xFF0F172A),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _externalIdController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: AppColors.white),
              decoration: _fieldDecoration(
                'External ID (e.g. github login, phorge PHID)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _externalUsernameController,
              style: const TextStyle(color: AppColors.white),
              decoration: _fieldDecoration(
                'Provider Username (optional, e.g. dlimier)',
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            onPressed: !canSubmit
                ? null
                : () {
                    widget.bloc.add(
                      AdminIdentityLinked(
                        userId: _selectedUserId!,
                        providerId: _selectedProviderId!,
                        externalId: _externalIdController.text.trim(),
                        externalUsername: _externalUsernameController.text.trim(),
                      ),
                    );
                    Navigator.pop(context);
                  },
            child: const Text(
              'Create Link',
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

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.white.withValues(alpha: 0.05),
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.onSurfaceVariantLow),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
