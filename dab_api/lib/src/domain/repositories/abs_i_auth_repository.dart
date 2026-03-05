import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../entities/session.dart';
import '../entities/user.dart';

abstract class AbsIAuthRepository {
  Future<Either<DatabaseFailure, User?>> findByEmail(String email);
  Future<Either<DatabaseFailure, User?>> findById(String id);
  Future<Either<DatabaseFailure, void>> createUser(User user);
  Future<Either<DatabaseFailure, List<User>>> findUsersWithPhorge();
  Future<Either<DatabaseFailure, void>> createSession(Session session);
  Future<Either<DatabaseFailure, Session?>> findSessionByToken(String token);
  Future<Either<DatabaseFailure, void>> deleteSession(String token);
  Future<Either<DatabaseFailure, void>> deleteUserSessions(String userId);
}
