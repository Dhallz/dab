import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
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
        _AdminProfileCard(),
      ],
    );
  }
}

class _AdminProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.accentIndigo,
            child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Console',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'v1.0.0-beta',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariantLow,
                    fontSize: 11,
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
