import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'seed.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Modules, ItemGroups, Items, Settings, ReviewStats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'petrufc'));

  @override
  int get schemaVersion => 4;

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
          if (from < 3) {
            // El grupo de palabras de hiragana pasa de 'hiragana_body' a 'hiragana_words'.
            await customStatement(
                "UPDATE item_groups SET id = 'hiragana_words' WHERE id = 'hiragana_body'");
            await customStatement(
                "UPDATE items SET group_id = 'hiragana_words' WHERE group_id = 'hiragana_body'");
            await upgradeToV3(this);
          }
          if (from < 4) await upgradeToV4(this);
        },
      );
}
