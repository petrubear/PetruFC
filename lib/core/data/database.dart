import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'seed.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Modules, ItemGroups, Items, Settings, ReviewStats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'petrufc'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDatabase(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await customStatement(
                "UPDATE item_groups SET name = 'Partes del cuerpo' WHERE id = 'hiragana_body'");
          }
        },
      );
}
