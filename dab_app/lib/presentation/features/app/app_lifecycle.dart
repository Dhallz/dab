import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Last [AppLifecycleState] observed by the app shell.
///
/// Default [AppLifecycleState.resumed] so unit tests skip banners unless
/// they override this provider.
final appLifecycleProvider = StateProvider<AppLifecycleState>(
  (ref) => AppLifecycleState.resumed,
);
