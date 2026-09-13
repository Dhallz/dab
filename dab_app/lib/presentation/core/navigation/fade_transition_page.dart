import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Fade transition for full-screen routes after splash (auth, home shell).
/// CONTRACT: Incoming route fades in; duration matches reverse for predictable pops.
const Duration _kFadeTransitionDuration = Duration(milliseconds: 380);

/// Builds a [CustomTransitionPage] that fades [child] in (and out on pop).
CustomTransitionPage<void> fadeTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: _kFadeTransitionDuration,
    reverseTransitionDuration: _kFadeTransitionDuration,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: child,
  );
}
