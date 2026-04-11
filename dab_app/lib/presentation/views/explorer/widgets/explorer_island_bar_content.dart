import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/widgets/island_bar.dart';
import '../explorer_bloc.dart';
import '../explorer_event.dart';
import '../explorer_state.dart';
import 'explorer_calendar_header.dart';
import 'explorer_date_selector.dart';
import 'explorer_jump_to_date_button.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Explorer top chrome — [IslandBar] holds only the date strip (full island height); title row sits below like the pre–Island Bar layout.
class ExplorerIslandBarContent extends StatefulWidget {
  const ExplorerIslandBarContent({super.key});

  @override
  State<ExplorerIslandBarContent> createState() =>
      _ExplorerIslandBarContentState();
}

class _ExplorerIslandBarContentState extends State<ExplorerIslandBarContent> {
  late PageController _pageController;
  static const int _initialPage = 10000;
  DateTime? _anchorDate;
  DateTime? _previewDate;
  bool _isInternalUpdating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1 / 7);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _syncPageToDate(DateTime selectedDate) {
    _anchorDate ??= selectedDate;
    _previewDate = selectedDate;

    final diff = selectedDate.difference(_anchorDate!).inDays;
    final targetPage = _initialPage + diff;

    if (_pageController.hasClients &&
        _pageController.page?.round() != targetPage) {
      _isInternalUpdating = true;
      _pageController
          .animateToPage(
            targetPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          )
          .then((_) {
            if (mounted) {
              setState(() {
                _isInternalUpdating = false;
              });
            }
          });
    }
  }

  void _onPageChanged(int page, ExplorerBloc bloc, DateTime currentDate) {
    if (_isInternalUpdating) return;

    final diff = page - _initialPage;
    final targetDate = _anchorDate!.add(Duration(days: diff));

    setState(() {
      _previewDate = targetDate;
    });

    if (!DateUtils.isSameDay(targetDate, currentDate)) {
      bloc.add(ExplorerDateChanged(targetDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<ExplorerBloc, ExplorerState>(
      listener: (context, state, bloc) {
        if (!_isInternalUpdating) {
          _syncPageToDate(state.selectedDate);
        }
      },
      builder: (context, state, bloc) {
        if (_anchorDate == null) {
          _anchorDate = state.selectedDate;
          _previewDate = state.selectedDate;
          _pageController = PageController(
            initialPage: _initialPage,
            viewportFraction: 1 / 7,
          );
        }

        final displayDate = _previewDate ?? state.selectedDate;
        final headerHorizontalPadding = MediaQuery.sizeOf(context).width > 800
            ? 32.0
            : 16.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IslandBar(
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ExplorerDateSelector(
                      state: state,
                      bloc: bloc,
                      pageController: _pageController,
                      anchorDate: _anchorDate!,
                      displayDate: displayDate,
                      initialPage: _initialPage,
                      onPageChanged: (page) =>
                          _onPageChanged(page, bloc, state.selectedDate),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ExplorerJumpToDateButton(
                      selectedDate: displayDate,
                      bloc: bloc,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: headerHorizontalPadding,
              ),
              child: ExplorerCalendarHeader(
                displayDate: displayDate,
                state: state,
              ),
            ),
          ],
        );
      },
    );
  }
}
