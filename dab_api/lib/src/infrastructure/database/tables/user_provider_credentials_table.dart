import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class UserProviderCredentialsTable extends Table {
  @override
  String get tableName => 'user_provider_credentials';

  TextColumn get id => text()();
  TextColumn get userId => text()
      .named('user_id')
      .customConstraint('NOT NULL REFERENCES users(id) ON DELETE CASCADE')();
  TextColumn get providerId => text().named('provider_id')();
  TextColumn get settings =>
      text().withDefault(const Constant('{}')).named('settings')();
  TextColumn get status => text().withDefault(const Constant('connected'))();
  TimestampColumn get createdAt => customType(PgTypes.timestampWithTimezone)
      .named('created_at')
      .withDefault(now())();
  TimestampColumn get updatedAt => customType(PgTypes.timestampWithTimezone)
      .nullable()
      .named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, providerId},
  ];
}
