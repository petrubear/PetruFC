import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/activity/activity_tracker.dart';
import '../../core/data/app_settings.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/feedback/feedback.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'game_common.dart';

const _pairs = 6;

class MemoryCard {
  const MemoryCard(this.itemId, this.text, this.japanese);
  final int itemId;
  final String text;
  final bool japanese;
}

class MemoryState {
  const MemoryState({
    required this.cards,
    this.faceUp = const {},
    this.matched = const {},
    this.missed = const {},
    this.locked = false,
    this.hits = 0,
    this.combo = 0,
    this.bestCombo = 0,
    this.summary = false,
  });
  final List<MemoryCard> cards;
  final Set<int> faceUp, matched; // indices de cartas
  final Set<int> missed; // items que ya salieron en un par equivocado
  final bool locked, summary;
  final int hits, combo, bestCombo;

  int get pairs => cards.length ~/ 2;

  MemoryState copyWith({
    Set<int>? faceUp,
    Set<int>? matched,
    Set<int>? missed,
    bool? locked,
    int? hits,
    int? combo,
    int? bestCombo,
    bool? summary,
  }) =>
      MemoryState(
        cards: cards,
        faceUp: faceUp ?? this.faceUp,
        matched: matched ?? this.matched,
        missed: missed ?? this.missed,
        locked: locked ?? this.locked,
        hits: hits ?? this.hits,
        combo: combo ?? this.combo,
        bestCombo: bestCombo ?? this.bestCombo,
        summary: summary ?? this.summary,
      );
}

class MemoryGame extends AutoDisposeFamilyAsyncNotifier<MemoryState, GameArgs> {
  late List<Item> _pool;
  bool _alive = true;

  String _key(Item i) => arg.$2 == 'kana' ? i.reading : (i.meaningEs ?? i.reading);

  @override
  Future<MemoryState> build(GameArgs arg) async {
    ref.onDispose(() => _alive = false);
    _pool = await loadGamePool(ref, arg);
    return _deal();
  }

  Future<MemoryState> _deal() async {
    final stats = await ref.read(statsProvider.future);
    final items = pickPriority(_pool, stats, _pairs, _key);
    final cards = [
      for (final i in items) ...[
        MemoryCard(i.id, i.japanese, true),
        MemoryCard(i.id, _key(i), false),
      ],
    ]..shuffle(Random());
    return MemoryState(cards: cards);
  }

  Future<void> restart() async => state = AsyncData(await _deal());

  void flip(int i) {
    final s = state.valueOrNull;
    if (s == null || s.locked || s.summary || s.matched.contains(i) || s.faceUp.contains(i)) {
      return;
    }
    final haptics = ref.read(settingsProvider).valueOrNull?.haptics ?? true;
    buzz(haptics, Buzz.soft);
    final up = {...s.faceUp, i};
    if (up.length < 2) {
      state = AsyncData(s.copyWith(faceUp: up));
      return;
    }
    final [a, b] = up.toList();
    final ca = s.cards[a], cb = s.cards[b];
    if (ca.itemId == cb.itemId) {
      // Solo suma aciertos: un par sin errores previos cuenta, nunca resta.
      final clean = !s.missed.contains(ca.itemId);
      if (clean) {
        ref.read(repoProvider).recordAnswer(ca.itemId, true).then((streak) {
          if (streak == 5 && _alive) {
            ref.read(masteredProvider.notifier).state = [ca.japanese ? ca.text : cb.text];
          }
        });
      }
      final combo = s.combo + 1;
      final matched = {...s.matched, a, b};
      buzz(haptics, Buzz.light);
      state = AsyncData(s.copyWith(
        faceUp: {},
        matched: matched,
        hits: s.hits + (clean ? 1 : 0),
        combo: combo,
        bestCombo: max(combo, s.bestCombo),
      ));
      if (matched.length == s.cards.length) {
        Future.delayed(const Duration(milliseconds: 900), () {
          final c = state.valueOrNull;
          if (_alive && c != null) state = AsyncData(c.copyWith(summary: true));
        });
      }
    } else {
      state = AsyncData(s.copyWith(
        faceUp: up,
        locked: true,
        combo: 0,
        missed: {...s.missed, ca.itemId, cb.itemId},
      ));
      Future.delayed(const Duration(milliseconds: 900), () {
        final c = state.valueOrNull;
        if (_alive && c != null) state = AsyncData(c.copyWith(faceUp: {}, locked: false));
      });
    }
  }
}

final memoryProvider = AsyncNotifierProvider.autoDispose
    .family<MemoryGame, MemoryState, GameArgs>(MemoryGame.new);

class MemoryScreen extends ConsumerWidget {
  const MemoryScreen({super.key, required this.args});
  final GameArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(memoryProvider(args));
    final n = ref.read(memoryProvider(args).notifier);
    ref.listen(masteredProvider, (prev, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('¡${next.join(' ')} dominado!'),
            duration: const Duration(seconds: 2)));
      }
    });
    final expanded = isExpanded(context);
    return ActivityScope(
      child: Scaffold(
        body: SafeArea(
          child: session.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (s) {
              if (s.summary) {
                return SessionSummary(
                  correct: s.hits,
                  total: s.pairs,
                  bestCombo: s.bestCombo,
                  onAgain: n.restart,
                  onExit: () => context.pop(),
                );
              }
              final cols = expanded ? 4 : 3;
              final rows = (s.cards.length / cols).ceil();
              final pad = expanded ? 40.0 : 24.0;
              return Padding(
                padding: EdgeInsets.fromLTRB(pad, expanded ? 24 : 12, pad, expanded ? 40 : 24),
                child: Column(
                  children: [
                    Row(children: [
                      RoundIconButton(
                          icon: Icons.close_rounded,
                          label: 'Cerrar',
                          size: expanded ? 48 : 44,
                          onTap: () => context.pop()),
                      const Expanded(
                        child: Text('MEMORAMA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Pt.subtext,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.4)),
                      ),
                      SizedBox(width: expanded ? 48 : 44),
                    ]),
                    const SizedBox(height: 10),
                    ScopeChip(args),
                    const SizedBox(height: 12),
                    SessionProgress(done: s.matched.length ~/ 2, size: s.pairs),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Column(
                        children: [
                          for (var r = 0; r < rows; r++)
                            Expanded(
                              child: Row(
                                children: [
                                  for (var c = 0; c < cols; c++)
                                    Expanded(
                                      child: r * cols + c < s.cards.length
                                          ? Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: _CardView(
                                                s.cards[r * cols + c],
                                                up: s.faceUp.contains(r * cols + c),
                                                matched: s.matched.contains(r * cols + c),
                                                onTap: () => n.flip(r * cols + c),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CardView extends StatelessWidget {
  const _CardView(this.card, {required this.up, required this.matched, required this.onTap});
  final MemoryCard card;
  final bool up, matched;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shown = up || matched;
    final color = matched ? Pt.green : (up ? Pt.flamingo : Pt.surface1);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: matched ? Pt.greenTint : (up ? Pt.surface1 : Pt.surface0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: shown ? 2 : 1),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: shown
              ? FittedBox(
                  key: const ValueKey('up'),
                  fit: BoxFit.scaleDown,
                  child: Text(card.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: card.japanese ? Pt.kana : Pt.ui,
                          fontWeight: FontWeight.w700,
                          fontSize: card.japanese ? 40 : 22,
                          color: matched ? Pt.green : Pt.text)),
                )
              : Icon(Icons.pets_rounded,
                  key: const ValueKey('down'),
                  color: Pt.flamingo.withValues(alpha: 0.55),
                  size: 30),
        ),
      ),
    );
  }
}
