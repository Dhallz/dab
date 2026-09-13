import 'package:flutter/material.dart';

import '../../../../../domain/entities/activity/activity.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/models/view_status.dart';
import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_layout.dart';
import '../../reports_state.dart';
import 'reports_activity_search_menu.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Focused autocomplete to pick extra activities onto today's report.
/// CONTRACT: Overlay is visible only while the field is focused. The field and
/// menu share a [TapRegion] group so choosing a row adds it before dismiss.
class ReportsActivitySearch extends StatefulWidget {
  final ReportsState state;
  final ValueChanged<String> onQueryChanged;
  final void Function(Activity activity) onAdd;

  const ReportsActivitySearch({
    super.key,
    required this.state,
    required this.onQueryChanged,
    required this.onAdd,
  });

  @override
  State<ReportsActivitySearch> createState() => _ReportsActivitySearchState();
}

class _ReportsActivitySearchState extends State<ReportsActivitySearch> {
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
    if (widget.state.searchPickerVisible.isNotEmpty) return true;
    if (widget.state.searchStatus == ViewStatus.loading) return true;
    return widget.state.searchQuery.trim().isNotEmpty &&
        widget.state.searchStatus == ViewStatus.success;
  }

  void _syncOverlay() {
    if (!mounted) return;
    if (_hasMenu) {
      if (!_overlay.isShowing) _overlay.show();
    } else if (_overlay.isShowing) {
      _overlay.hide();
    }
  }

  void _select(Activity activity) {
    widget.onAdd(activity);
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
          overlayChildBuilder: (context) => ReportsActivitySearchMenu(
            link: _link,
            tapGroup: _tapGroup,
            width: width,
            state: widget.state,
            onAdd: _select,
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
                  hintText: context.l10n.reportsSearchHint,
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
