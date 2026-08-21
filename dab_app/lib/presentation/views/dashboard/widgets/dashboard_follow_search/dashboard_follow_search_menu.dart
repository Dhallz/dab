import 'package:flutter/material.dart';

import '../../../../../domain/entities/user/follow_candidate.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/models/view_status.dart';
import '../../../../core/styles/app_layout.dart';
import '../../../../core/styles/app_spacing.dart';
import '../../../../core/styles/provider_icon_resolver.dart';
import '../../dashboard_state.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Overlay suggestion list for [DashboardFollowSearch].
class DashboardFollowSearchMenu extends StatelessWidget {
  final LayerLink link;
  final Object tapGroup;
  final double width;
  final DashboardState state;
  final void Function(FollowCandidate candidate) onFollow;

  const DashboardFollowSearchMenu({
    super.key,
    required this.link,
    required this.tapGroup,
    required this.width,
    required this.state,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final rows = state.followPickerVisible;
    final loading = state.followSearchStatus == ViewStatus.loading;
    final empty =
        rows.isEmpty &&
        !loading &&
        state.followSearchQuery.trim().isNotEmpty &&
        state.followSearchStatus == ViewStatus.success;

    return CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      targetAnchor: Alignment.bottomLeft,
      followerAnchor: Alignment.topLeft,
      offset: const Offset(0, 4),
      child: Align(
        alignment: Alignment.topLeft,
        widthFactor: 1,
        heightFactor: 1,
        child: TapRegion(
          groupId: tapGroup,
          child: Material(
            elevation: 3,
            shadowColor: scheme.shadow.withValues(alpha: 0.12),
            color: scheme.surfaceContainerLowest,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
              side: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (loading) const LinearProgressIndicator(minHeight: 2),
                  if (empty)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.s),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.dashboardFollowSearchEmpty,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else if (rows.isNotEmpty)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 240),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: rows.length,
                        itemBuilder: (context, index) {
                          final row = rows[index];
                          return Listener(
                            behavior: HitTestBehavior.opaque,
                            onPointerDown: (_) => onFollow(row),
                            child: ListTile(
                              dense: true,
                              mouseCursor: SystemMouseCursors.click,
                              leading: Icon(
                                ProviderIconResolver.resolveFallbackIcon(
                                  context,
                                  row.providerId,
                                ),
                                size: 16,
                                color: ProviderIconResolver.resolveBrandColor(
                                  context,
                                  row.providerId,
                                ),
                              ),
                              title: Text(
                                row.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
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
