import 'package:flutter/material.dart';

import '../../../core/widgets/app_sidebar.dart';

class ExplorerSidebar extends StatelessWidget {
  const ExplorerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSidebar(
      children: [
        _buildFilterSection(),
        const SizedBox(height: 32),
        _buildActivityTypeSection(),
        const Spacer(),
        _buildStorageStatus(),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HISTORICAL FILTERS',
          style: TextStyle(
            fontSize: 12, // text-xs
            fontWeight: FontWeight.bold,
            color: const Color(0xFF64748B), // slate-500
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _buildFilterButton(
          icon: Icons.dataset_rounded,
          label: 'All Past Activity',
          isSelected: true,
        ),
        const SizedBox(height: 8),
        _buildFilterButton(
          icon: Icons.terminal_rounded,
          label: 'Engineering Logs',
        ),
        const SizedBox(height: 8),
        _buildFilterButton(icon: Icons.draw_rounded, label: 'Design Reviews'),
        const SizedBox(height: 8),
        _buildFilterButton(
          icon: Icons.ads_click_rounded,
          label: 'Product Milestones',
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4245F0)
              : Colors.transparent, // primary
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4245F0).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF94A3B8), // slate-400
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF94A3B8), // slate-400
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIVITY TYPE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF64748B),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _buildCheckboxRow('Commits', true),
        const SizedBox(height: 8),
        _buildCheckboxRow('Pull Requests', true),
        const SizedBox(height: 8),
        _buildCheckboxRow('Figma Comments', false),
      ],
    );
  }

  Widget _buildCheckboxRow(String label, bool isChecked) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (v) {},
          activeColor: const Color(0xFF4245F0), // primary
          checkColor: Colors.white,
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFFCBD5E1), // slate-300
          ),
        ),
      ],
    );
  }

  Widget _buildStorageStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Storage Status',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B), // slate-500
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.65,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4245F0), // primary
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '12.4 GB of 20 GB Archive used',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF94A3B8), // slate-400
            ),
          ),
        ],
      ),
    );
  }
}
