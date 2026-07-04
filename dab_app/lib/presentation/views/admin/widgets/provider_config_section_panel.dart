import 'package:dab_app/domain/entities/provider/provider_connectivity_report.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:dab_app/presentation/views/admin/models/provider_connection_status.dart';
import 'package:flutter/material.dart';

import 'live_pulsing_icon.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Section header with status light for Admin provider config cards.
class ProviderConfigSectionPanel extends StatelessWidget {
  final String title;
  final ProviderSectionResult? sectionStatus;
  final List<Widget> children;

  const ProviderConfigSectionPanel({
    super.key,
    required this.title,
    required this.sectionStatus,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final status = sectionStatus == null
        ? null
        : ProviderConnectionStatus(
            status: sectionStatus!.status,
            message: sectionStatus!.message,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.labelSmall.copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (status != null)
              LivePulsingIcon(status: status, compact: true, enablePulse: false),
          ],
        ),
        if (sectionStatus?.message.isNotEmpty == true) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            sectionStatus!.message,
            style: AppTextStyles.labelSmall.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.s),
        ...children,
        const SizedBox(height: AppSpacing.m),
      ],
    );
  }
}

/// Polling rate field shared across hybrid providers.
Widget providerPollingRateField({
  required BuildContext context,
  required TextEditingController controller,
}) {
  final cs = Theme.of(context).colorScheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'POLLING RATE (SECONDS)',
        style: AppTextStyles.labelSmall.copyWith(
          color: cs.onSurfaceVariant,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: AppTextStyles.bodyMedium.copyWith(color: cs.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: cs.surfaceContainer.withValues(alpha: 0.65),
          hintText: 'e.g. 60',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.m,
          ),
          border: OutlineInputBorder(
            borderRadius: AppLayout.borderMedium,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppLayout.borderMedium,
            borderSide: BorderSide(color: cs.primary, width: 1.5),
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.m),
    ],
  );
}
