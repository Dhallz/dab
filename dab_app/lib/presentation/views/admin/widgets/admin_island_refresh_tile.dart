import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Tappable refresh control in the admin island bar, matching stat tile chrome.
class AdminIslandRefreshTile extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const AdminIslandRefreshTile({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: 'Refresh admin data',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppLayout.borderMedium,
          child: Ink(
            decoration: BoxDecoration(
              color: cs.surfaceContainer.withValues(alpha: 0.55),
              borderRadius: AppLayout.borderMedium,
              border: Border.all(
                color: cs.outline.withValues(alpha: 0.45),
              ),
            ),
            child: Padding(
              // Match Explorer calendar button compact padding.
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.primary,
                      ),
                    )
                  else
                    Icon(
                      AppIcons.refresh,
                      size: 13,
                      color: cs.onSurfaceVariant,
                    ),
                  const SizedBox(height: 3),
                  Text(
                    'REFRESH',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
