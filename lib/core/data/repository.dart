import 'package:drift/drift.dart';

import 'database.dart';

String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class StudyRepository {
  StudyRepository(this.db);
  final AppDatabase db;

  Future<List<StudyModule>> modules() => (db.select(db.modules)
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .get();

  Future<List<ItemGroup>> groups(String moduleId, String kind) =>
      (db.select(db.itemGroups)
            ..where((g) => g.moduleId.equals(moduleId) & g.kind.equals(kind))
            ..orderBy([(g) => OrderingTerm.asc(g.sortOrder)]))
          .get();

  Future<List<Item>> items(String moduleId, Iterable<String> groupIds) =>
      (db.select(db.items)
            ..where((i) => i.moduleId.equals(moduleId) & i.groupId.isIn(groupIds)))
          .get();

  Future<Set<String>> activeGroups(String moduleId) async {
    final row = await (db.select(db.settings)
          ..where((s) => s.key.equals('active_groups:$moduleId')))
        .getSingleOrNull();
    final v = row?.value ?? '';
    return v.isEmpty ? <String>{} : v.split(',').toSet();
  }

  Future<void> saveActiveGroups(String moduleId, Set<String> ids) =>
      db.into(db.settings).insertOnConflictUpdate(SettingsCompanion.insert(
          key: 'active_groups:$moduleId', value: ids.join(',')));

  /// Registra la respuesta y devuelve la racha de aciertos resultante.
  Future<int> recordAnswer(int itemId, bool correct) => db.transaction(() async {
    final cur = await (db.select(
      db.reviewStats,
    )..where((r) => r.itemId.equals(itemId))).getSingleOrNull();
    final streak = correct ? (cur?.streak ?? 0) + 1 : 0;
    await db
        .into(db.reviewStats)
        .insertOnConflictUpdate(
          ReviewStatsCompanion.insert(
            itemId: Value(itemId),
            attempts: Value((cur?.attempts ?? 0) + 1),
            correct: Value((cur?.correct ?? 0) + (correct ? 1 : 0)),
            streak: Value(streak),
            lastSeen: DateTime.now(),
          ),
        );
    return streak;
  });

  Stream<Map<int, ReviewStat>> watchStats() =>
      db.select(db.reviewStats).watch().map((l) => {for (final r in l) r.itemId: r});

  Future<Map<String, String>> allSettings() async => {
    for (final r in await db.select(db.settings).get()) r.key: r.value,
  };

  Future<void> saveSetting(String key, String value) =>
      db.into(db.settings).insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  /// Suma segundos al dia y devuelve el total del dia.
  Future<int> addSeconds(String day, int seconds) => db.transaction(() async {
    final cur = await (db.select(
      db.dailyActivity,
    )..where((d) => d.day.equals(day))).getSingleOrNull();
    final total = (cur?.seconds ?? 0) + seconds;
    await db
        .into(db.dailyActivity)
        .insertOnConflictUpdate(DailyActivityCompanion.insert(day: day, seconds: Value(total)));
    return total;
  });

  Stream<Map<String, int>> watchActivitySince(String day) =>
      (db.select(db.dailyActivity)..where((d) => d.day.isBiggerOrEqualValue(day))).watch().map(
        (l) => {for (final d in l) d.day: d.seconds},
      );
}
