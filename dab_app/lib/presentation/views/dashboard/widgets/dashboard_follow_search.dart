import 'package:flutter/material.dart';

import '../../../../domain/entities/user/follow_candidate.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/provider_icon_resolver.dart';
import '../dashboard_state.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Focused autocomplete at the top of Following for issues and git
/// branches that are not already in the live inbox. Suggestions appear in the
/// menu only while the field is focused.
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
  int _menuEpoch = 0;

  static const _loadingSentinel = FollowCandidate(
    providerId: '_',
    objectKey: '_loading',
    title: '…',
  );
  static const _emptySentinel = FollowCandidate(
    providerId: '_',
    objectKey: '_empty',
    title: '…',
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onText);
    _focusNode.addListener(_onFocus);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onQueryChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onText);
    _focusNode.removeListener(_onFocus);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onText() {
    widget.onQueryChanged(_controller.text);
  }

  void _onFocus() {
    if (_focusNode.hasFocus) {
      widget.onQueryChanged(_controller.text);
    }
  }

  void _select(FollowCandidate? candidate) {
    if (candidate == null || candidate.providerId == '_') return;
    widget.onFollow(candidate);
    _controller.removeListener(_onText);
    _controller.clear();
    _controller.addListener(_onText);
    _focusNode.unfocus();
    setState(() => _menuEpoch++);
  }

  List<DropdownMenuEntry<FollowCandidate>> _entries(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final rows = widget.state.followPickerVisible;
    final loading = widget.state.followSearchStatus == ViewStatus.loading;
    if (rows.isNotEmpty) {
      return [
        for (final row in rows)
          DropdownMenuEntry<FollowCandidate>(
            value: row,
            label: row.title,
            labelWidget: Text(
              row.title,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            leadingIcon: Icon(
              ProviderIconResolver.resolveFallbackIcon(context, row.providerId),
              size: 16,
              color: ProviderIconResolver.resolveBrandColor(
                context,
                row.providerId,
              ),
            ),
          ),
      ];
    }
    if (loading) {
      return const [
        DropdownMenuEntry<FollowCandidate>(
          value: _loadingSentinel,
          label: '…',
          enabled: false,
        ),
      ];
    }
    if (widget.state.followSearchQuery.trim().isNotEmpty &&
        widget.state.followSearchStatus == ViewStatus.success) {
      return [
        DropdownMenuEntry<FollowCandidate>(
          value: _emptySentinel,
          label: l10n.dashboardFollowSearchEmpty,
          enabled: false,
        ),
      ];
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return DropdownMenu<FollowCandidate>(
          key: ValueKey(_menuEpoch),
          controller: _controller,
          focusNode: _focusNode,
          width: width,
          expandedInsets: EdgeInsets.zero,
          requestFocusOnTap: true,
          enableFilter: true,
          hintText: context.l10n.dashboardFollowSearchHint,
          leadingIcon: Icon(AppIcons.search, size: 18),
          inputDecorationTheme: const InputDecorationTheme(isDense: true),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(
              scheme.surfaceContainerLowest,
            ),
            elevation: const WidgetStatePropertyAll(3),
            shadowColor: WidgetStatePropertyAll(
              scheme.shadow.withValues(alpha: 0.12),
            ),
            minimumSize: WidgetStatePropertyAll(Size(width, 0)),
            maximumSize: WidgetStatePropertyAll(Size(width, 240)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
                side: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          dropdownMenuEntries: _entries(context),
          onSelected: _select,
        );
      },
    );
  }
}
