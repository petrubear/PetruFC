import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';

const _n = 8;
const _wordsPerGame = 8;
const _dirs = [(0, 1), (1, 0), (1, 1), (1, -1), (0, -1), (-1, 0), (-1, -1), (-1, 1)];
const _noFill = {'ー', 'ゃ', 'ゅ', 'ょ', 'っ', 'ャ', 'ュ', 'ョ', 'ッ'};

typedef Cell = (int, int);

class WordSearchState {
  const WordSearchState(this.grid, this.words, this.found, this.selection);
  final List<List<String>> grid;
  final List<Item> words;
  final Map<int, List<Cell>> found;
  final List<Cell> selection;

  bool get done => found.length == words.length;
  Set<Cell> get foundCells => {for (final l in found.values) ...l};

  WordSearchState copyWith({Map<int, List<Cell>>? found, List<Cell>? selection}) =>
      WordSearchState(grid, words, found ?? this.found, selection ?? this.selection);
}

WordSearchState _generate(List<Item> all) {
  final rng = Random();
  final usable = all.where((i) => i.japanese.runes.length >= 2).toList()..shuffle(rng);
  final chosen = usable.take(_wordsPerGame).toList()
    ..sort((a, b) => b.japanese.length.compareTo(a.japanese.length));
  final grid = List.generate(_n, (_) => List.filled(_n, ''));
  final placed = <Item>[];
  bool inside(int r, int c) => r >= 0 && c >= 0 && r < _n && c < _n;

  for (final w in chosen) {
    final chars = w.japanese.runes.map(String.fromCharCode).toList();
    for (var t = 0; t < 300; t++) {
      final (dr, dc) = _dirs[rng.nextInt(_dirs.length)];
      final r = rng.nextInt(_n), c = rng.nextInt(_n);
      final er = r + dr * (chars.length - 1), ec = c + dc * (chars.length - 1);
      if (!inside(er, ec)) continue;
      final fits = [
        for (var i = 0; i < chars.length; i++)
          grid[r + dr * i][c + dc * i].isEmpty || grid[r + dr * i][c + dc * i] == chars[i]
      ].every((b) => b);
      if (!fits) continue;
      for (var i = 0; i < chars.length; i++) {
        grid[r + dr * i][c + dc * i] = chars[i];
      }
      placed.add(w);
      break;
    }
  }

  final pool = {
    for (final i in usable) ...i.japanese.runes.map(String.fromCharCode),
  }.where((ch) => !_noFill.contains(ch)).toList();
  for (final row in grid) {
    for (var c = 0; c < _n; c++) {
      if (row[c].isEmpty) row[c] = pool[rng.nextInt(pool.length)];
    }
  }
  return WordSearchState(grid, placed, {}, const []);
}

class WordSearchGame
    extends AutoDisposeFamilyAsyncNotifier<WordSearchState, (String, String)> {
  late List<Item> _all;
  Cell? _start;

  @override
  Future<WordSearchState> build((String, String) arg) async {
    _all = await ref.read(repoProvider).items(arg.$1, [arg.$2]);
    return _generate(_all);
  }

  void newGame() => state = AsyncData(_generate(_all));

  void start(Cell c) {
    _start = c;
    state = AsyncData(state.requireValue.copyWith(selection: [c]));
  }

  // Ajusta la seleccion a la linea recta (8 direcciones) mas cercana al dedo.
  void drag(Cell p) {
    final s = _start;
    if (s == null) return;
    final dr = p.$1 - s.$1, dc = p.$2 - s.$2;
    final adr = dr.abs(), adc = dc.abs();
    final (sr, sc) = adr >= 2 * adc
        ? (dr.sign, 0)
        : adc >= 2 * adr
            ? (0, dc.sign)
            : (dr.sign, dc.sign);
    final cells = <Cell>[];
    for (var i = 0; i <= max(adr, adc); i++) {
      final r = s.$1 + sr * i, c = s.$2 + sc * i;
      if (r < 0 || c < 0 || r >= _n || c >= _n) break;
      cells.add((r, c));
    }
    state = AsyncData(state.requireValue.copyWith(selection: cells));
  }

  void end() {
    final s = state.requireValue;
    _start = null;
    final text = s.selection.map((c) => s.grid[c.$1][c.$2]).join();
    final reversed = text.runes.toList().reversed.map(String.fromCharCode).join();
    for (var i = 0; i < s.words.length; i++) {
      if (s.found.containsKey(i)) continue;
      final w = s.words[i].japanese;
      if (s.selection.length > 1 && (w == text || w == reversed)) {
        HapticFeedback.mediumImpact();
        state = AsyncData(s.copyWith(found: {...s.found, i: s.selection}, selection: []));
        return;
      }
    }
    state = AsyncData(s.copyWith(selection: []));
  }
}

final wordSearchProvider = AsyncNotifierProvider.autoDispose
    .family<WordSearchGame, WordSearchState, (String, String)>(WordSearchGame.new);

class WordSearchScreen extends ConsumerWidget {
  const WordSearchScreen({super.key, required this.moduleId, required this.groupId});
  final String moduleId, groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (moduleId, groupId);
    final session = ref.watch(wordSearchProvider(args));
    final notifier = ref.read(wordSearchProvider(args).notifier);
    final expanded = isExpanded(context);
    return Scaffold(
      body: SafeArea(
        child: session.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (s) {
            final top = Row(
              children: [
                RoundIconButton(
                    icon: Icons.close_rounded,
                    label: 'Cerrar',
                    size: expanded ? 48 : 44,
                    onTap: () => context.pop()),
                const Expanded(
                  child: Text('SOPA DE LETRAS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Pt.subtext,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.4)),
                ),
                RoundIconButton(
                    icon: Icons.refresh_rounded,
                    label: 'Nueva sopa',
                    size: expanded ? 48 : 44,
                    onTap: notifier.newGame),
              ],
            );
            final board = _Board(s, notifier);
            final clues = _Clues(s, notifier);
            if (expanded) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(40, 24, 40, 40),
                child: Column(
                  children: [
                    top,
                    const SizedBox(height: 28),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: Center(child: AspectRatio(aspectRatio: 1, child: board))),
                          const SizedBox(width: 32),
                          SizedBox(width: 340, child: SingleChildScrollView(child: clues)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  top,
                  const SizedBox(height: 20),
                  AspectRatio(aspectRatio: 1, child: board),
                  const SizedBox(height: 20),
                  Expanded(child: SingleChildScrollView(child: clues)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board(this.s, this.notifier);
  final WordSearchState s;
  final WordSearchGame notifier;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, box) {
          final side = box.maxWidth;
          Cell at(Offset p) => (
                (p.dy / side * _n).floor().clamp(0, _n - 1),
                (p.dx / side * _n).floor().clamp(0, _n - 1),
              );
          final found = s.foundCells;
          final sel = s.selection.toSet();
          return GestureDetector(
            onPanStart: (d) => notifier.start(at(d.localPosition)),
            onPanUpdate: (d) => notifier.drag(at(d.localPosition)),
            onPanEnd: (_) => notifier.end(),
            onPanCancel: notifier.end,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Pt.surface0,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Pt.surface1),
              ),
              child: Column(
                children: [
                  for (var r = 0; r < _n; r++)
                    Expanded(
                      child: Row(
                        children: [
                          for (var c = 0; c < _n; c++)
                            Expanded(child: _CellView(
                              s.grid[r][c],
                              found: found.contains((r, c)),
                              selected: sel.contains((r, c)),
                            )),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
}

class _CellView extends StatelessWidget {
  const _CellView(this.ch, {required this.found, required this.selected});
  final String ch;
  final bool found, selected;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(1.5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? Pt.flamingo.withValues(alpha: 0.35)
              : found
                  ? Pt.greenTint
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: Pt.flamingo) : null,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(ch,
              style: TextStyle(
                  fontFamily: Pt.kana,
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  color: found ? Pt.green : Pt.text)),
        ),
      );
}

class _Clues extends StatelessWidget {
  const _Clues(this.s, this.notifier);
  final WordSearchState s;
  final WordSearchGame notifier;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel('ENCUENTRA · ${s.found.length}/${s.words.length}'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < s.words.length; i++)
                _Clue(s.words[i], found: s.found.containsKey(i)),
            ],
          ),
          if (s.done) ...[
            const SizedBox(height: 24),
            const Text('¡Las encontraste todas!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Pt.green)),
            const SizedBox(height: 12),
            PillButton('Nueva sopa', onTap: notifier.newGame),
          ],
        ],
      );
}

class _Clue extends StatelessWidget {
  const _Clue(this.item, {required this.found});
  final Item item;
  final bool found;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: found ? Pt.greenTint : Pt.surface0,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: found ? Pt.green : Pt.surface1),
        ),
        child: Text(found ? '${item.meaningEs} · ${item.japanese}' : item.meaningEs ?? '',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: found ? Pt.green : Pt.text)),
      );
}
