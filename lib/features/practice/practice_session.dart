import 'dart:math';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/database.dart';
import '../../core/data/providers.dart';

class PracticeState {
  const PracticeState({
    required this.item,
    this.strokes = const [],
    this.checked = false,
  });
  final Item item;
  final List<List<Offset>> strokes; // coordenadas normalizadas 0..1
  final bool checked;

  PracticeState copyWith({List<List<Offset>>? strokes, bool? checked}) =>
      PracticeState(
        item: item,
        strokes: strokes ?? this.strokes,
        checked: checked ?? this.checked,
      );
}

class PracticeSession
    extends AutoDisposeFamilyAsyncNotifier<PracticeState, String> {
  late List<Item> _pool;
  int? _lastId;
  final _rng = Random();

  Item _pick() {
    Item i;
    do {
      i = _pool[_rng.nextInt(_pool.length)];
    } while (_pool.length > 1 && i.id == _lastId);
    _lastId = i.id;
    return i;
  }

  @override
  Future<PracticeState> build(String arg) async {
    final ids = await ref.read(activeGroupsProvider(arg).future);
    _pool = await ref.read(repoProvider).items(arg, ids);
    return PracticeState(item: _pick());
  }

  void startStroke(Offset p) {
    final s = state.valueOrNull;
    if (s == null || s.checked) return;
    state = AsyncData(s.copyWith(strokes: [
      ...s.strokes,
      [p]
    ]));
  }

  void addPoint(Offset p) {
    final s = state.valueOrNull;
    if (s == null || s.checked || s.strokes.isEmpty) return;
    final last = [...s.strokes.last, p];
    state = AsyncData(
        s.copyWith(strokes: [...s.strokes.sublist(0, s.strokes.length - 1), last]));
  }

  void clear() {
    final s = state.valueOrNull;
    if (s != null) state = AsyncData(s.copyWith(strokes: const []));
  }

  void check() {
    final s = state.valueOrNull;
    if (s != null) state = AsyncData(s.copyWith(checked: true));
  }

  void grade(bool ok) {
    final s = state.requireValue;
    ref.read(repoProvider).recordAnswer(s.item.id, ok);
    state = AsyncData(PracticeState(item: _pick()));
  }
}

final practiceSessionProvider = AsyncNotifierProvider.autoDispose
    .family<PracticeSession, PracticeState, String>(PracticeSession.new);
