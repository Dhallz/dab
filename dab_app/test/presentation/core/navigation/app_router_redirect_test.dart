import 'package:dab_app/domain/entities/user/user_role.dart';
import 'package:dab_app/presentation/core/navigation/app_route.dart';
import 'package:dab_app/presentation/core/navigation/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('guests are sent to auth from protected routes', () {
    expect(
      resolveHomeRedirect(
        isLoggedIn: false,
        location: AppRoute.homeDashboard.path,
      ),
      AppRoute.auth.path,
    );
  });

  test('authenticated users leave the auth screen for dashboard', () {
    expect(
      resolveHomeRedirect(
        isLoggedIn: true,
        location: AppRoute.auth.path,
        role: UserRole.standard,
      ),
      AppRoute.homeDashboard.path,
    );
  });

  test('non-admins cannot stay on /home/admin', () {
    expect(
      resolveHomeRedirect(
        isLoggedIn: true,
        location: AppRoute.homeAdmin.path,
        role: UserRole.standard,
      ),
      AppRoute.homeDashboard.path,
    );
    expect(
      resolveHomeRedirect(
        isLoggedIn: true,
        location: AppRoute.homeAdmin.path,
        role: UserRole.manager,
      ),
      AppRoute.homeDashboard.path,
    );
  });

  test('admins may open /home/admin', () {
    expect(
      resolveHomeRedirect(
        isLoggedIn: true,
        location: AppRoute.homeAdmin.path,
        role: UserRole.admin,
      ),
      isNull,
    );
  });
}
