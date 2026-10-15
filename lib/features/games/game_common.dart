import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/widgets/mastery.dart';

/// (moduleId, kind: 'kana' | 'word', groupId solo para 'word')
typedef GameArgs = (String moduleId, String kind, String? groupId);

Future<List<Item>> loadGamePool(Ref ref, GameArgs a) async {
  final ids = a.$2 == 'kana'
      ? await ref.read(activeGroupsProvider(a.$1).future)
      : {a.$3!};
  return ref.read(repoProvider).items(a.$1, ids);
}

/// Elige n elementos sin repetir `key`: la mitad de lo que esta en rojo o amarillo,
/// despues lo no visto y al final lo dominado.
List<Item> pickPriority(
  List<Item> pool,
  Map<int, ReviewStat> stats,
  int n,
  String Function(Item) key, [
  Random? rng,
]) {
  final r = rng ?? Random();
  List<Item> of(bool Function(Mastery) f) =>
      pool.where((i) => f(Mastery.of(stats[i.id]))).toList()..shuffle(r);
  final needs = of((m) => m == Mastery.weak || m == Mastery.learning);
  final unseen = of((m) => m == Mastery.unseen);
  final mastered = of((m) => m == Mastery.mastered);
  final seen = <String>{};
  final out = <Item>[];
  void take(Iterable<Item> from, int max) {
    for (final i in from) {
      if (out.length >= n || max <= 0) return;
      if (seen.add(key(i))) {
        out.add(i);
        max--;
      }
    }
  }

  take(needs, n ~/ 2);
  take(unseen, n);
  take(mastered, n);
  take(needs, n);
  return out..shuffle(r);
}

/// "Hiragana · Básicos + Dakuten" o "Katakana · Colores": lo que se esta practicando.
final gameScopeLabelProvider =
    FutureProvider.autoDispose.family<String, GameArgs>((ref, a) async {
  final modules = await ref.watch(modulesProvider.future);
  final name = modules.firstWhere((m) => m.id == a.$1).name;
  if (a.$2 == 'kana') {
    final active = await ref.watch(activeGroupsProvider(a.$1).future);
    final groups = await ref.watch(groupsProvider((a.$1, 'kana')).future);
    return '$name · ${groups.where((g) => active.contains(g.id)).map((g) => g.name).join(' + ')}';
  }
  final groups = await ref.watch(groupsProvider((a.$1, 'word')).future);
  return '$name · ${groups.firstWhere((g) => g.id == a.$3).name}';
});

class ScopeChip extends ConsumerWidget {
  const ScopeChip(this.args, {super.key});
  final GameArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = ref.watch(gameScopeLabelProvider(args)).valueOrNull ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Pt.surface0,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Pt.surface1),
      ),
      child: Text(label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: Pt.subtext, fontWeight: FontWeight.w500)),
    );
  }
}
