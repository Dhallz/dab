import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_profile_card.dart';
import 'package:dab_app/presentation/views/explorer/widgets/explorer_sidebar/selection_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSidebar extends ConsumerWidget {
  final AdminSection selectedSection;

  const AdminSidebar({super.key, required this.selectedSection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminNotifierProvider.notifier);
    final isPersonal = ref.watch(
      appNotifierProvider.select((s) => s.isPersonalDeployment),
    );
    final cs = Theme.of(context).colorScheme;
    final sections = adminSectionsFor(isPersonal: isPersonal);
    return AppSidebar(
      children: [
        Text(
          context.l10n.adminNavManagement,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: cs.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          SelectionTile(
            label: sections[i].localizedTitle(context.l10n),
            isSelected: selectedSection == sections[i],
            iconData: _iconFor(sections[i]),
            onTap: () => notifier.setSection(sections[i]),
          ),
        ],
        const Spacer(),
        const AdminProfileCard(),
      ],
    );
  }

  IconData _iconFor(AdminSection section) => switch (section) {
    AdminSection.providers => AppIcons.providers,
    AdminSection.identities => AppIcons.users,
    AdminSection.security => AppIcons.admin,
  };
}
