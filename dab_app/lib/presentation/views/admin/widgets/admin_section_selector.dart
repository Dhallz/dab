import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSectionSelector extends StatelessWidget {
  final AdminSection selectedSection;

  const AdminSectionSelector({super.key, required this.selectedSection});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AdminSection.values.map((section) {
        return ChoiceChip(
          label: Text(section.title),
          selected: section == selectedSection,
          onSelected: (_) =>
              context.read<AdminBloc>().add(AdminSectionChanged(section)),
          labelStyle: TextStyle(
            color: section == selectedSection
                ? AppColors.onPrimary
                : AppColors.onSurfaceVariantLow,
            fontWeight: FontWeight.w600,
          ),
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.surfaceContainer.withValues(alpha: 0.7),
          side: BorderSide(
            color: section == selectedSection
                ? AppColors.primary
                : AppColors.outline.withValues(alpha: 0.4),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        );
      }).toList(),
    );
  }
}
