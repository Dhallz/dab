import '../../core/models/view_status.dart';
import '../../core/navigation/app_route.dart';
import '../../features/auth/auth_state.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Decide GoRouter target from auth while splash waits out minimum hold time.
/// CONTRACT: Returns `null` until [AuthState.status] allows routing ([ViewStatus.success]
/// or terminal failure); splash combines this with a timer before calling `context.go`.
String? splashDestinationPath(AuthState auth) {
  switch (auth.status) {
    case ViewStatus.initial:
    case ViewStatus.loading:
      return null;
    case ViewStatus.failure:
      return AppRoute.auth.path;
    case ViewStatus.success:
      return auth.isAuthenticated
          ? AppRoute.homeDashboard.path
          : AppRoute.auth.path;
  }
}
