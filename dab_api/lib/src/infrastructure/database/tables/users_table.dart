import 'package:dab_api/src/domain/entities/user.dart';
import 'package:drift/drift.dart';

@UseRowClass(User)
class UsersTable extends Table {
  @override
  String get tableName => 'users';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text().named('password_hash')();
  TextColumn get role => text().withDefault(const Constant('Standard'))();
  TextColumn get phorgePhid => text().nullable().named('phorge_phid')();
  TextColumn get phorgeUsername => text().nullable().named('phorge_username')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
