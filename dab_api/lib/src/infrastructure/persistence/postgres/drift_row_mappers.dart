import 'package:dab_api/src/domain/entities/session.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/infrastructure/persistence/postgres/app_database.dart';
import 'package:drift_postgres/drift_postgres.dart';

User userFromUsersRow(UsersTableData row) {
  return User(
    id: row.id,
    name: row.name,
    email: row.email,
    avatarUrl: row.avatarUrl,
    passwordHash: row.passwordHash,
    role: UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == row.role.toLowerCase(),
      orElse: () => UserRole.standard,
    ),
    phorgePhid: row.phorgePhid,
    phorgeUsername: row.phorgeUsername,
    createdAt: row.createdAt.dateTime,
    updatedAt: row.updatedAt?.dateTime,
  );
}

Session sessionFromSessionsRow(SessionsTableData row) {
  return Session(
    id: row.id,
    userId: row.userId,
    refreshToken: row.refreshToken,
    expiresAt: row.expiresAt.dateTime,
    deviceInfo: row.deviceInfo,
  );
}

PgDateTime toPgDateTime(DateTime value) => PgDateTime(value);

PgDateTime? toPgDateTimeOrNull(DateTime? value) =>
    value != null ? PgDateTime(value) : null;
