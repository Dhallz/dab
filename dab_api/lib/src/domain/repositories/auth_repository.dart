import '../entities/session.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> findByEmail(String email);
  Future<void> createUser(User user);
  Future<void> createSession(Session session);
  Future<Session?> findSessionByToken(String token);
  Future<void> deleteSession(String token);
  Future<void> deleteUserSessions(String userId);
}
