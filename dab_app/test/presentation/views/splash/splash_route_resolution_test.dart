import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/navigation/app_route.dart';
import 'package:dab_app/presentation/features/auth/auth_state.dart';
import 'package:dab_app/presentation/views/splash/splash_route_resolution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('splashDestinationPath', () {
    test('returns null while initial or loading', () {
      expect(
        splashDestinationPath(const AuthState(status: ViewStatus.initial)),
        isNull,
      );
      expect(
        splashDestinationPath(const AuthState(status: ViewStatus.loading)),
        isNull,
      );
    });

    test('success with user routes to home dashboard', () {
      expect(
        splashDestinationPath(
          AuthState(
            status: ViewStatus.success,
            user: User(id: '1', name: 'T', email: 't@test.dev'),
          ),
        ),
        AppRoute.homeDashboard.path,
      );
    });

    test('success without user routes to auth', () {
      expect(
        splashDestinationPath(
          const AuthState(status: ViewStatus.success, user: null),
        ),
        AppRoute.auth.path,
      );
    });

    test('failure routes to auth', () {
      expect(
        splashDestinationPath(
          const AuthState(status: ViewStatus.failure, errorMessage: 'x'),
        ),
        AppRoute.auth.path,
      );
    });
  });
}
