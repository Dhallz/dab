import 'package:drift/drift.dart';

class ActivitiesTable extends Table {
  @override
  String get tableName => 'activities';

  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get providerName =>
      text().named('provider_name')(); // discriminator
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get url => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
