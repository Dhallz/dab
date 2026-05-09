import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:flutter/material.dart';

import 'identity_create_dialog.dart';
import 'status_chip.dart';

class IdentitiesTab extends StatelessWidget {
  final List<UserIdentity> identities;
  final List<User> users;
  final List<String> providerIds;
  final String searchQuery;
  final IdentitySortField sortField;
  final bool sortAscending;
  final AdminNotifier notifier;

  const IdentitiesTab({
    super.key,
    required this.identities,
    required this.users,
    required this.providerIds,
    required this.searchQuery,
    required this.sortField,
    required this.sortAscending,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXTERNAL IDENTITIES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: cs.onSurfaceVariant,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          onChanged: (value) => notifier.setIdentitySearchQuery(value),
          initialValue: searchQuery,
          style: TextStyle(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: 'Search identities...',
            hintStyle: TextStyle(color: cs.onSurfaceVariant),
            prefixIcon: Icon(
              Icons.search,
              color: cs.onSurfaceVariant,
            ),
            filled: true,
            fillColor: cs.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) =>
                  IdentityCreateDialog(users: users, providerIds: providerIds),
            ),
            icon: const Icon(Icons.add_link, size: 18),
            label: const Text('Create Link'),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: identities.isEmpty
              ? Center(
                  child: Text(
                    'No identities found',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                )
              : _buildGrid(context),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    final fullNameByUserId = {for (final user in users) user.id: user.name};

    return LayoutBuilder(
      builder: (context, constraints) {
        final cs = Theme.of(context).colorScheme;
        final minTableWidth = constraints.maxWidth > 980
            ? constraints.maxWidth
            : 980.0;
        final headerStyle = TextStyle(color: cs.onSurfaceVariant);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minTableWidth),
            child: SingleChildScrollView(
              child: DataTable(
                sortColumnIndex: _sortColumnIndex(sortField),
                sortAscending: sortAscending,
                headingRowColor: WidgetStatePropertyAll(
                  cs.surfaceContainerHigh.withValues(alpha: 0.55),
                ),
                dataRowColor: WidgetStatePropertyAll(
                  cs.surfaceContainerLow.withValues(alpha: 0.35),
                ),
                columns: [
                  DataColumn(
                    label: Text('Full Name', style: headerStyle),
                    onSort: (columnIndex, ascending) =>
                        _onSort(IdentitySortField.fullName, ascending),
                  ),
                  DataColumn(
                    label: Text('Provider', style: headerStyle),
                    onSort: (columnIndex, ascending) =>
                        _onSort(IdentitySortField.provider, ascending),
                  ),
                  DataColumn(
                    label: Text('External ID', style: headerStyle),
                    onSort: (columnIndex, ascending) =>
                        _onSort(IdentitySortField.externalId, ascending),
                  ),
                  DataColumn(
                    label: Text('Provider Username', style: headerStyle),
                    onSort: (columnIndex, ascending) =>
                        _onSort(IdentitySortField.providerUsername, ascending),
                  ),
                  DataColumn(
                    label: Text('Status', style: headerStyle),
                    onSort: (columnIndex, ascending) =>
                        _onSort(IdentitySortField.status, ascending),
                  ),
                  DataColumn(
                    label: Text('Actions', style: headerStyle),
                  ),
                ],
                rows: identities.map((identity) {
                  final fullName =
                      fullNameByUserId[identity.userId] ?? identity.userId;
                  final providerUsername =
                      identity.externalUsername?.trim() ?? '';
                  final missingProviderUsername = providerUsername.isEmpty;
                  return DataRow(
                    cells: [
                      DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName,
                              style: TextStyle(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              identity.userId,
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          identity.providerId,
                          style: TextStyle(color: cs.onSurface),
                        ),
                      ),
                      DataCell(
                        Text(
                          identity.externalId,
                          style: TextStyle(color: cs.onSurface),
                        ),
                      ),
                      DataCell(
                        missingProviderUsername
                            ? Tooltip(
                                message: 'Add provider username',
                                child: IconButton(
                                  onPressed: () =>
                                      _openQuickLink(context, identity),
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: cs.primary,
                                    size: 18,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                            : Text(
                                '@$providerUsername',
                                style: TextStyle(color: cs.onSurface),
                              ),
                      ),
                      DataCell(StatusChip(status: identity.status)),
                      DataCell(
                        IconButton(
                          icon: Icon(
                            Icons.link,
                            size: 20,
                            color: cs.primary,
                          ),
                          onPressed: () => _openLinkDialog(context, identity),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSort(IdentitySortField field, bool ascending) {
    notifier.setIdentitySort(field, ascending);
  }

  int? _sortColumnIndex(IdentitySortField field) {
    return switch (field) {
      IdentitySortField.fullName => 0,
      IdentitySortField.provider => 1,
      IdentitySortField.externalId => 2,
      IdentitySortField.providerUsername => 3,
      IdentitySortField.status => 4,
    };
  }

  void _openLinkDialog(BuildContext context, UserIdentity identity) {
    showDialog(
      context: context,
      builder: (_) => IdentityCreateDialog(
        users: users,
        providerIds: providerIds,
        initialUserId: identity.userId,
        initialProviderId: identity.providerId,
        initialExternalId: identity.externalId,
        initialExternalUsername: identity.externalUsername,
        initialFocusField: IdentityCreateFocusField.externalId,
        isUpdateMode: true,
      ),
    );
  }

  void _openQuickLink(BuildContext context, UserIdentity identity) {
    showDialog(
      context: context,
      builder: (_) => IdentityCreateDialog(
        users: users,
        providerIds: providerIds,
        initialUserId: identity.userId,
        initialProviderId: identity.providerId,
        initialExternalId: identity.externalId,
        initialExternalUsername: identity.externalUsername,
        initialFocusField: IdentityCreateFocusField.externalUsername,
        isUpdateMode: true,
      ),
    );
  }
}
