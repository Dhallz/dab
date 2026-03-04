import 'package:drift/drift.dart';

import 'package:dab_api/src/domain/entities/session.dart';

@UseRowClass(Session)
class SessionsTable extends Table {
  @override
  String get tableName => 'sessions';

  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get refreshToken => text().named('token')();
  DateTimeColumn get expiresAt => dateTime().named('expires_at')();
  TextColumn get deviceInfo => text().nullable().named('device_info')();

  @override
  Set<Column> get primaryKey => {id};
}
