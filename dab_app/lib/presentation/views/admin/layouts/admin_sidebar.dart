import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_profile_card.dart';
import 'package:dab_app/presentation/views/explorer/widgets/explorer_sidebar/selection_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../admin_bloc.dart';

class AdminSidebar extends StatelessWidget {
  final AdminSection selectedSection;

  const AdminSidebar({super.key, required this.selectedSection});

  @override
  Widget build(BuildContext context) {
    return AppSidebar(
      children: [
        const Text(
          'MANAGEMENT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceVariantLow,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        SelectionTile(
          label: 'Providers',
          isSelected: selectedSection == AdminSection.providers,
          iconData: Icons.vibration_outlined,
          onTap: () => context.read<AdminBloc>().add(
            const AdminSectionChanged(AdminSection.providers),
          ),
        ),
        const SizedBox(height: 8),
        SelectionTile(
          label: 'Identities',
          isSelected: selectedSection == AdminSection.identities,
          iconData: Icons.fingerprint_outlined,
          onTap: () => context.read<AdminBloc>().add(
            const AdminSectionChanged(AdminSection.identities),
          ),
        ),
        const SizedBox(height: 8),
        SelectionTile(
          label: 'Security',
          isSelected: selectedSection == AdminSection.security,
          iconData: Icons.shield_outlined,
          onTap: () => context.read<AdminBloc>().add(
            const AdminSectionChanged(AdminSection.security),
          ),
        ),
        const Spacer(),
        const AdminProfileCard(),
      ],
    );
  }
}
