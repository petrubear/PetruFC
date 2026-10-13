import 'package:drift/drift.dart';

import 'database.dart';

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

  Future<void> recordAnswer(int itemId, bool correct) => db.transaction(() async {
        final cur = await (db.select(db.reviewStats)
              ..where((r) => r.itemId.equals(itemId)))
            .getSingleOrNull();
        await db.into(db.reviewStats).insertOnConflictUpdate(
              ReviewStatsCompanion.insert(
                itemId: Value(itemId),
                attempts: Value((cur?.attempts ?? 0) + 1),
                correct: Value((cur?.correct ?? 0) + (correct ? 1 : 0)),
                lastSeen: DateTime.now(),
              ),
            );
      });
}
