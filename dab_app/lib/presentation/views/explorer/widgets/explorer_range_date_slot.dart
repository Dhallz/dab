import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Fixed-size cell for one date control in Explorer range mode strip.
class ExplorerRangeDateSlot extends StatelessWidget {
  final Widget child;
  final bool compact;

  const ExplorerRangeDateSlot({
    super.key,
    required this.child,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 58 : 80,
      height: compact ? 48 : 72,
      child: Center(child: child),
    );
  }
}
