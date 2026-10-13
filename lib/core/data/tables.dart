import 'package:drift/drift.dart';

@DataClassName('StudyModule')
class Modules extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get glyph => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get enabled => boolean()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ItemGroup')
class ItemGroups extends Table {
  TextColumn get id => text()();
  TextColumn get moduleId => text()();
  TextColumn get kind => text()(); // kana | word
  TextColumn get name => text()();
  TextColumn get subtitle => text()();
  IntColumn get sortOrder => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get moduleId => text()();
  TextColumn get groupId => text()();
  TextColumn get kind => text()(); // kana | word
  TextColumn get japanese => text()();
  TextColumn get reading => text()();
  TextColumn get meaningEs => text().nullable()();
  TextColumn get audioText => text().nullable()();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

class ReviewStats extends Table {
  IntColumn get itemId => integer()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get correct => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSeen => dateTime()();
  @override
  Set<Column> get primaryKey => {itemId};
}
