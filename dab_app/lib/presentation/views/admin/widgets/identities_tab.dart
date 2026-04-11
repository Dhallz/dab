import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:flutter/material.dart';

import 'identity_link_dialog.dart';
import 'status_chip.dart';

class IdentitiesTab extends StatelessWidget {
  final List<UserIdentity> identities;
  final AdminBloc bloc;

  const IdentitiesTab({super.key, required this.identities, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EXTERNAL IDENTITIES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceVariantLow,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child:
              identities.isEmpty
                  ? const Center(
                    child: Text(
                      'No identities found',
                      style: TextStyle(color: AppColors.onSurfaceVariantLow),
                    ),
                  )
                  : ListView.builder(
                    itemCount: identities.length,
                    itemBuilder: (context, index) {
                      final identity = identities[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.fingerprint,
                                color: AppColors.onSurfaceVariantLow,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    identity.externalId,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    identity.providerId,
                                    style: const TextStyle(
                                      color: AppColors.onSurfaceVariantLow,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusChip(status: identity.status),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(
                                Icons.link,
                                size: 20,
                                color: AppColors.accentIndigo,
                              ),
                              onPressed:
                                  () => showDialog(
                                    context: context,
                                    builder:
                                        (_) => IdentityLinkDialog(
                                          identity: identity,
                                          bloc: bloc,
                                        ),
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
