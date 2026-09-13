import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Short banner shown after a dashboard live reconnect.
class DashboardReconnectNoticeBanner extends StatelessWidget {
  final DateTime at;
  final AppLocalizations l10n;

  const DashboardReconnectNoticeBanner({
    super.key,
    required this.at,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hh = at.hour.toString().padLeft(2, '0');
    final mm = at.minute.toString().padLeft(2, '0');
    final ss = at.second.toString().padLeft(2, '0');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: Text(
        l10n.dashboardReconnectNotice('$hh:$mm:$ss'),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
