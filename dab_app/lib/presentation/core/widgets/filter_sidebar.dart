import 'package:flutter/material.dart';

import '../styles/app_spacing.dart';
import 'app_sidebar.dart';
import 'filter_sidebar_section.dart';
import 'filter_sidebar_section_spec.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Shared Explorer/Insights chrome — collapsible sections in [AppSidebar].
/// CONTRACT: At most one [FilterSidebarSectionSpec.fillsRemainingSpace] section
/// consumes leftover height. Expansion is owned here so views stay consistent.
class FilterSidebar extends StatefulWidget {
  final List<FilterSidebarSectionSpec> sections;

  const FilterSidebar({super.key, required this.sections});

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = List<bool>.filled(widget.sections.length, true);
  }

  @override
  void didUpdateWidget(covariant FilterSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sections.length == widget.sections.length) return;
    _expanded = [
      for (var i = 0; i < widget.sections.length; i++)
        i < _expanded.length ? _expanded[i] : true,
    ];
  }

  void _toggle(int index) {
    setState(() => _expanded[index] = !_expanded[index]);
  }

  @override
  Widget build(BuildContext context) {
    final sections = widget.sections;
    final primaryIndex = sections.indexWhere((s) => s.fillsRemainingSpace);

    return AppSidebar(
      children: [
        if (primaryIndex < 0)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < sections.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.l),
                    FilterSidebarSection(
                      title: sections[i].title,
                      isExpanded: _expanded[i],
                      onToggle: () => _toggle(i),
                      child: sections[i].child,
                    ),
                  ],
                ],
              ),
            ),
          )
        else
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_expanded[primaryIndex])
                  Expanded(
                    child: SingleChildScrollView(
                      child: FilterSidebarSection(
                        title: sections[primaryIndex].title,
                        isExpanded: true,
                        onToggle: () => _toggle(primaryIndex),
                        child: sections[primaryIndex].child,
                      ),
                    ),
                  )
                else ...[
                  FilterSidebarSection(
                    title: sections[primaryIndex].title,
                    isExpanded: false,
                    onToggle: () => _toggle(primaryIndex),
                    child: sections[primaryIndex].child,
                  ),
                  const Expanded(child: SizedBox.shrink()),
                ],
                const SizedBox(height: AppSpacing.l),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < sections.length; i++)
                      if (i != primaryIndex) ...[
                        if (_hasPriorCompact(i, primaryIndex))
                          const SizedBox(height: AppSpacing.l),
                        FilterSidebarSection(
                          title: sections[i].title,
                          isExpanded: _expanded[i],
                          onToggle: () => _toggle(i),
                          child: sections[i].child,
                        ),
                      ],
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _hasPriorCompact(int index, int primaryIndex) {
    for (var i = 0; i < index; i++) {
      if (i != primaryIndex) return true;
    }
    return false;
  }
}
