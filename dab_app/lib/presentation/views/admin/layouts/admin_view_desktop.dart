import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/widgets/island_bar.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/auth/auth_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/layouts/admin_sidebar.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_bar_content.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_section_body.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _identityListSignature(List<UserIdentity> list) =>
    list.map((e) => e.id).join('|');

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Desktop layout for the Admin Console.
class AdminViewDesktop extends ConsumerWidget {
  const AdminViewDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(adminNotifierProvider, (previous, current) {
      final prev = previous;
      final curr = current;
      var fire = false;
      if (curr.errorMessage != prev?.errorMessage &&
          curr.errorMessage != null) {
        fire = true;
      } else if (curr.status == ViewStatus.success &&
          prev?.status == ViewStatus.loading &&
          curr.errorMessage == null) {
        fire = true;
      } else if (curr.status == ViewStatus.success &&
          curr.errorMessage == null &&
          prev != null &&
          _identityListSignature(prev.identities) !=
              _identityListSignature(curr.identities)) {
        fire = true;
      }
      if (!fire) return;

      if (curr.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(curr.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (curr.status == ViewStatus.success && curr.errorMessage == null) {
        ref
            .read(appNotifierProvider.notifier)
            .refreshIdentityResolutionBadge(ref.read(authNotifierProvider));
      }
    });

    ref.watch(
      adminNotifierProvider.select(
        (s) => (
          selectedSection: s.selectedSection,
          status: s.status,
          configs: s.configs,
          identities: s.identities,
          users: s.users,
          identitySearchQuery: s.identitySearchQuery,
          identitySortField: s.identitySortField,
          identitySortAscending: s.identitySortAscending,
          connectionStatuses: s.connectionStatuses,
          systemSettings: s.systemSettings,
          errorMessage: s.errorMessage,
        ),
      ),
    );
    final state = ref.read(adminNotifierProvider);
    final notifier = ref.read(adminNotifierProvider.notifier);
    final section = state.selectedSection;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSidebar(selectedSection: section),
          Expanded(
            child: Column(
              children: [
                const IslandBar(content: AdminIslandBarContent()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdminSectionHeader(
                          title: section.localizedTitle(context.l10n),
                          subtitle: section.localizedSubtitle(context.l10n),
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: AdminSectionBody(
                            state: state,
                            notifier: notifier,
                            section: section,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
