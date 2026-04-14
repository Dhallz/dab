import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Fixed-size cell for one date control in Explorer range mode strip.
class ExplorerRangeDateSlot extends StatelessWidget {
  final Widget child;

  const ExplorerRangeDateSlot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 80, height: 72, child: Center(child: child));
  }
}
