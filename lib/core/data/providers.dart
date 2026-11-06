import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'repository.dart';

final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final repoProvider = Provider((ref) => StudyRepository(ref.watch(dbProvider)));

final modulesProvider =
    FutureProvider((ref) => ref.watch(repoProvider).modules());

final groupsProvider = FutureProvider.family<List<ItemGroup>, (String, String)>(
    (ref, k) => ref.watch(repoProvider).groups(k.$1, k.$2));

/// Flashcards de kana: 9 caracteres en 3 bloques de 3 en lugar de uno.
final multiSelectProvider = StateProvider<bool>((ref) => false);

/// Estadisticas por item (racha, intentos) para colorear tablas y listas.
final statsProvider = StreamProvider.autoDispose<Map<int, ReviewStat>>(
    (ref) => ref.watch(repoProvider).watchStats());

final selectedModuleProvider = StateProvider<String>((ref) => 'hiragana');

class ActiveGroups extends AutoDisposeFamilyAsyncNotifier<Set<String>, String> {
  @override
  Future<Set<String>> build(String arg) =>
      ref.read(repoProvider).activeGroups(arg);

  Future<void> toggle(String groupId) async {
    final cur = {...state.requireValue};
    if (cur.contains(groupId)) {
      if (cur.length == 1) return; // siempre queda al menos un set
      cur.remove(groupId);
    } else {
      cur.add(groupId);
    }
    await ref.read(repoProvider).saveActiveGroups(arg, cur);
    state = AsyncData(cur);
  }
}

final activeGroupsProvider = AsyncNotifierProvider.autoDispose
    .family<ActiveGroups, Set<String>, String>(ActiveGroups.new);

/// Avance de un modulo de caracteres (kana o kanji): caracteres dominados (racha >= 5) sobre el total.
final moduleProgressProvider =
    FutureProvider.autoDispose.family<double, String>((ref, moduleId) async {
  final repo = ref.watch(repoProvider);
  final stats = ref.watch(statsProvider).valueOrNull ?? {};
  final groups = await repo.groups(moduleId, moduleId == 'kanji' ? 'kanji' : 'kana');
  final items = await repo.items(moduleId, groups.map((g) => g.id));
  if (items.isEmpty) return 0;
  final done = items.where((i) => (stats[i.id]?.streak ?? 0) >= 5).length;
  return done / items.length;
});

/// Detalles de los kanji (lecturas on y kun, trazos, grado) por id de item.
final kanjiDetailsProvider = FutureProvider<Map<int, KanjiDetail>>((ref) async {
  final db = ref.watch(dbProvider);
  return {for (final d in await db.select(db.kanjiDetails).get()) d.itemId: d};
});
