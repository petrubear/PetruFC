import 'dart:math';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_settings.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/feedback/feedback.dart';
import 'stroke_score.dart';
import '../../core/audio/sound_service.dart';

class PracticeState {
  const PracticeState({
    required this.item,
    required this.size,
    this.strokes = const [],
    this.checked = false,
    this.score,
    this.graded = 0,
    this.hits = 0,
    this.combo = 0,
    this.bestCombo = 0,
    this.summary = false,
    this.celebrations = 0,
  });
  final int size, graded, hits, combo, bestCombo, celebrations;
  final bool summary;
  final Item item;
  final List<List<Offset>> strokes; // coordenadas normalizadas 0..1
  final bool checked;
  final double? score; // parecido 0..1 con el caracter correcto

  PracticeState copyWith({List<List<Offset>>? strokes, bool? checked, double? score}) =>
      PracticeState(
        item: item,
        size: size,
        strokes: strokes ?? this.strokes,
        checked: checked ?? this.checked,
        score: score ?? this.score,
        graded: graded,
        hits: hits,
        combo: combo,
        bestCombo: bestCombo,
        summary: summary,
        celebrations: celebrations,
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
    final size = (await ref.read(settingsProvider.future)).sessionSize;
    return PracticeState(item: _pick(), size: size);
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

  Future<void> check() async {
    final s = state.valueOrNull;
    if (s == null || s.checked) return;
    state = AsyncData(s.copyWith(checked: true));
    final score = await scoreStrokes(s.strokes, s.item.japanese);
    final cur = state.valueOrNull;
    if (cur != null && cur.item.id == s.item.id && cur.checked) {
      state = AsyncData(cur.copyWith(score: score));
    }
  }

  void grade(bool ok) {
    final s = state.requireValue;
    final haptics = ref.read(settingsProvider).valueOrNull?.haptics ?? true;
    ref.read(repoProvider).recordAnswer(s.item.id, ok).then((streak) {
      if (ok && streak == 5) {
        buzz(haptics, Buzz.heavy);
        ref.read(masteredProvider.notifier).state = [s.item.japanese];
      }
    });
    final graded = s.graded + 1;
    final combo = ok ? s.combo + 1 : 0;
    final milestone = ok && combo % 5 == 0;
    buzz(haptics, !ok ? Buzz.soft : (milestone ? Buzz.medium : Buzz.light));
    ref.read(soundProvider).play(!ok ? SoundCue.wrong : (milestone ? SoundCue.combo : SoundCue.correct));
    final best = combo > s.bestCombo ? combo : s.bestCombo;
    final hits = s.hits + (ok ? 1 : 0);
    state = AsyncData(
      PracticeState(
        item: graded >= s.size ? s.item : _pick(),
        size: s.size,
        graded: graded,
        hits: hits,
        combo: combo,
        bestCombo: best,
        summary: graded >= s.size,
        celebrations: s.celebrations + (milestone ? 1 : 0),
      ),
    );
  }

  void restart() {
    final s = state.requireValue;
    state = AsyncData(PracticeState(item: _pick(), size: s.size));
  }
}

final practiceSessionProvider = AsyncNotifierProvider.autoDispose
    .family<PracticeSession, PracticeState, String>(PracticeSession.new);
