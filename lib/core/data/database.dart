import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'seed.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Modules, ItemGroups, Items, Settings, ReviewStats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'petrufc'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDatabase(this);
        },
      );
}
