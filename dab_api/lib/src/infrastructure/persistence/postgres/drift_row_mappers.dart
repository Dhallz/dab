import 'package:dab_api/src/domain/entities/session.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/infrastructure/persistence/postgres/app_database.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Maps a Drift users row to the domain [User] entity.
extension OnUsersTableData on UsersTableData {
  User toUser() {
    return User(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      passwordHash: passwordHash,
      role: UserRole.values.firstWhere(
        (e) => e.name.toLowerCase() == role.toLowerCase(),
        orElse: () => UserRole.standard,
      ),
      phorgePhid: phorgePhid,
      phorgeUsername: phorgeUsername,
      createdAt: createdAt.dateTime,
      updatedAt: updatedAt?.dateTime,
    );
  }
}

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Maps a Drift sessions row to the domain [Session] entity.
extension OnSessionsTableData on SessionsTableData {
  Session toSession() {
    return Session(
      id: id,
      userId: userId,
      refreshToken: refreshToken,
      expiresAt: expiresAt.dateTime,
      deviceInfo: deviceInfo,
    );
  }
}

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Wraps a [DateTime] as Drift Postgres `timestamptz`.
extension OnDateTime on DateTime {
  PgDateTime toPgDateTime() => PgDateTime(this);
}

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Wraps an optional [DateTime] as Drift Postgres `timestamptz`.
extension OnDateTimeNullable on DateTime? {
  PgDateTime? toPgDateTimeOrNull() =>
      this != null ? PgDateTime(this!) : null;
}
