import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSectionSelector extends ConsumerWidget {
  final AdminSection selectedSection;

  const AdminSectionSelector({super.key, required this.selectedSection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminNotifierProvider.notifier);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AdminSection.values.map((section) {
        return ChoiceChip(
          label: Text(section.title),
          selected: section == selectedSection,
          onSelected: (_) => notifier.setSection(section),
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
