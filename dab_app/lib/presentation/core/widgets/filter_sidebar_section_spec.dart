import 'package:flutter/widgets.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: One collapsible block in [FilterSidebar].
class FilterSidebarSectionSpec {
  final String title;
  final Widget child;

  /// When true, this section fills leftover height and scrolls (Directory).
  final bool fillsRemainingSpace;

  const FilterSidebarSectionSpec({
    required this.title,
    required this.child,
    this.fillsRemainingSpace = false,
  });
}
