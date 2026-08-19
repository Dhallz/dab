import 'package:flutter/material.dart';

import '../../../../domain/entities/user/follow_candidate.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/provider_icon_resolver.dart';
import '../dashboard_state.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Focused autocomplete at the top of Following for issues and git
/// branches that are not already in the live inbox. Suggestions appear in an
/// overlay only while the field is focused. The field and menu share a
/// [TapRegion] group so choosing a row Follows it before the overlay closes.
class DashboardFollowSearch extends StatefulWidget {
  final DashboardState state;
  final ValueChanged<String> onQueryChanged;
  final void Function(FollowCandidate candidate) onFollow;

  const DashboardFollowSearch({
    super.key,
    required this.state,
    required this.onQueryChanged,
    required this.onFollow,
  });

  @override
  State<DashboardFollowSearch> createState() => _DashboardFollowSearchState();
}

class _DashboardFollowSearchState extends State<DashboardFollowSearch> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final OverlayPortalController _overlay = OverlayPortalController();
  final LayerLink _link = LayerLink();
  final Object _tapGroup = Object();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (_focusNode.hasFocus) {
      widget.onQueryChanged(_controller.text);
    }
    _syncOverlay();
  }

  void _onText(String value) {
    widget.onQueryChanged(value);
    _syncOverlay();
  }

  bool get _hasMenu {
    if (!_focusNode.hasFocus) return false;
    if (widget.state.followPickerVisible.isNotEmpty) return true;
    if (widget.state.followSearchStatus == ViewStatus.loading) return true;
    return widget.state.followSearchQuery.trim().isNotEmpty &&
        widget.state.followSearchStatus == ViewStatus.success;
  }

  void _syncOverlay() {
    if (!mounted) return;
    if (_hasMenu) {
      if (!_overlay.isShowing) _overlay.show();
    } else if (_overlay.isShowing) {
      _overlay.hide();
    }
  }

  void _select(FollowCandidate candidate) {
    widget.onFollow(candidate);
    _controller.clear();
    widget.onQueryChanged('');
    _focusNode.unfocus();
    _syncOverlay();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncOverlay();
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return OverlayPortal.targetsRootOverlay(
          controller: _overlay,
          overlayChildBuilder: (context) => _FollowSearchMenu(
            link: _link,
            tapGroup: _tapGroup,
            width: width,
            state: widget.state,
            onFollow: _select,
          ),
          child: CompositedTransformTarget(
            link: _link,
            child: TapRegion(
              groupId: _tapGroup,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                groupId: _tapGroup,
                enabled: true,
                readOnly: false,
                onChanged: _onText,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: context.l10n.dashboardFollowSearchHint,
                  prefixIcon: Icon(AppIcons.search, size: AppLayout.iconSmall),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 32,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FollowSearchMenu extends StatelessWidget {
  final LayerLink link;
  final Object tapGroup;
  final double width;
  final DashboardState state;
  final void Function(FollowCandidate candidate) onFollow;

  const _FollowSearchMenu({
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
