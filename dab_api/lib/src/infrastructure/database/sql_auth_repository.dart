import '../../domain/entities/session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../database/database_client.dart';

class SqlAuthRepository implements AuthRepository {
  final _pool = DatabaseClient().pool;

  @override
  Future<User?> findByEmail(String email) async {
    final result = await _pool.execute(
      'SELECT id, email, password_hash, created_at, updated_at FROM users WHERE email = @email',
      parameters: {'email': email},
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return User(
      id: row[0] as String,
      email: row[1] as String,
      passwordHash: row[2] as String,
      createdAt: row[3] as DateTime,
      updatedAt: row[4] as DateTime?,
    );
  }

  @override
  Future<void> createUser(User user) async {
    await _pool.execute(
      'INSERT INTO users (id, email, password_hash, created_at) VALUES (@id, @email, @passwordHash, @createdAt)',
      parameters: {
        'id': user.id,
        'email': user.email,
        'passwordHash': user.passwordHash,
        'createdAt': user.createdAt,
      },
    );
  }

  @override
  Future<void> createSession(Session session) async {
    await _pool.execute(
      'INSERT INTO refresh_tokens (id, user_id, token, expires_at, device_info) VALUES (@id, @userId, @token, @expiresAt, @deviceInfo)',
      parameters: {
        'id': session.id,
        'userId': session.userId,
        'token': session.refreshToken,
        'expiresAt': session.expiresAt,
        'deviceInfo': session.deviceInfo,
      },
    );
  }

  @override
  Future<Session?> findSessionByToken(String token) async {
    final result = await _pool.execute(
      'SELECT id, user_id, token, expires_at, device_info FROM refresh_tokens WHERE token = @token',
      parameters: {'token': token},
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return Session(
      id: row[0] as String,
      userId: row[1] as String,
      refreshToken: row[2] as String,
      expiresAt: row[3] as DateTime,
      deviceInfo: row[4] as String?,
    );
  }

  @override
  Future<void> deleteSession(String token) async {
    await _pool.execute(
      'DELETE FROM refresh_tokens WHERE token = @token',
      parameters: {'token': token},
    );
  }

  @override
  Future<void> deleteUserSessions(String userId) async {
    await _pool.execute(
      'DELETE FROM refresh_tokens WHERE user_id = @userId',
      parameters: {'userId': userId},
    );
  }
}
