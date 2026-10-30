import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'seed.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Modules, ItemGroups, Items, Settings, ReviewStats, DailyActivity])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'petrufc'));

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await seedDatabase(this);
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await customStatement(
          "UPDATE item_groups SET name = 'Partes del cuerpo' WHERE id = 'hiragana_body'",
        );
      }
      if (from < 3) {
        // El grupo de palabras de hiragana pasa de 'hiragana_body' a 'hiragana_words'.
        await customStatement(
          "UPDATE item_groups SET id = 'hiragana_words' WHERE id = 'hiragana_body'",
        );
        await customStatement(
          "UPDATE items SET group_id = 'hiragana_words' WHERE group_id = 'hiragana_body'",
        );
        await upgradeToV3(this);
      }
      if (from < 4) await upgradeToV4(this);
      if (from < 5) await upgradeToV5(this);
      if (from < 6) {
        await m.addColumn(reviewStats, reviewStats.streak);
        await m.createTable(dailyActivity);
        // Estimacion de la racha con el historial: sin errores = aciertos (tope 5),
        // con errores y aciertos = 1 (amarillo), solo errores = 0 (rojo).
        await customStatement('''UPDATE review_stats SET streak = CASE
                WHEN correct = attempts THEN MIN(correct, 5)
                WHEN correct > 0 THEN 1 ELSE 0 END''');
      }
      if (from < 7) await upgradeToV7(this);
      if (from < 8) await upgradeToV8(this);
      if (from < 9) await upgradeToV9(this);
      if (from < 10) await upgradeToV10(this);
    },
  );
}
