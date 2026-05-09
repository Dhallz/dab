import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
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
    final cs = Theme.of(context).colorScheme;
    return AppSidebar(
      children: [
        Text(
          'MANAGEMENT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: cs.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        SelectionTile(
          label: 'Providers',
          isSelected: selectedSection == AdminSection.providers,
          iconData: Icons.vibration_outlined,
          onTap: () => notifier.setSection(AdminSection.providers),
        ),
        const SizedBox(height: 8),
        SelectionTile(
          label: 'Identities',
          isSelected: selectedSection == AdminSection.identities,
          iconData: Icons.fingerprint_outlined,
          onTap: () => notifier.setSection(AdminSection.identities),
        ),
        const SizedBox(height: 8),
        SelectionTile(
          label: 'Security',
          isSelected: selectedSection == AdminSection.security,
          iconData: Icons.shield_outlined,
          onTap: () => notifier.setSection(AdminSection.security),
        ),
        const Spacer(),
        const AdminProfileCard(),
      ],
    );
  }
}
