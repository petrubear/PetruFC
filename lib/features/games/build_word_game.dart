import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/name_text.dart';
import '../../app/theme.dart';
import '../../core/activity/activity_tracker.dart';
import '../../core/data/app_settings.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/feedback/feedback.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'game_common.dart';
import '../../core/l10n/language.dart';
import '../../core/audio/sound_service.dart';

const _wordsPerRound = 10;

class WordTile {
  const WordTile(this.id, this.char);
  final int id;
  final String char;
}

class BuildState {
  const BuildState({
    required this.words,
    required this.tiles,
    this.index = 0,
    this.placed = const [],
    this.dirty = false,
    this.wrongTile,
    this.hits = 0,
    this.combo = 0,
    this.bestCombo = 0,
    this.summary = false,
  });
  final List<Item> words;
  final List<WordTile> tiles;
  final int index, hits, combo, bestCombo;
  final List<int> placed; // ids de fichas ya colocadas, en orden
  final bool dirty, summary;
  final int? wrongTile;

  Item get word => words[index];
  List<String> get chars => surname(word.japanese).runes.map(String.fromCharCode).toList();
  bool get wordDone => placed.length == chars.length;

  BuildState copyWith({
    List<WordTile>? tiles,
    int? index,
    List<int>? placed,
    bool? dirty,
    int? Function()? wrongTile,
    int? hits,
    int? combo,
    int? bestCombo,
    bool? summary,
  }) =>
      BuildState(
        words: words,
        tiles: tiles ?? this.tiles,
        index: index ?? this.index,
        placed: placed ?? this.placed,
        dirty: dirty ?? this.dirty,
        wrongTile: wrongTile != null ? wrongTile() : this.wrongTile,
        hits: hits ?? this.hits,
        combo: combo ?? this.combo,
        bestCombo: bestCombo ?? this.bestCombo,
        summary: summary ?? this.summary,
      );
}

class BuildWordGame extends AutoDisposeFamilyAsyncNotifier<BuildState, GameArgs> {
  late List<Item> _pool;
  bool _alive = true;
  final _rng = Random();

  @override
  Future<BuildState> build(GameArgs arg) async {
    ref.onDispose(() => _alive = false);
    _pool = (await loadGamePool(ref, arg)).where((i) => surname(i.japanese).runes.length >= 2).toList();
    return _deal();
  }

  List<WordTile> _tilesFor(Item w) {
    final chars = surname(w.japanese).runes.map(String.fromCharCode).toList();
    var tiles = [for (var i = 0; i < chars.length; i++) WordTile(i, chars[i])];
    for (var t = 0; t < 5; t++) {
      tiles.shuffle(_rng);
      if (tiles.map((e) => e.char).join() != chars.join()) break;
    }
    return tiles;
  }

  Future<BuildState> _deal() async {
    final stats = await ref.read(statsProvider.future);
    final words = pickPriority(_pool, stats, _wordsPerRound, (i) => i.japanese);
    return BuildState(words: words, tiles: _tilesFor(words.first));
  }

  Future<void> restart() async => state = AsyncData(await _deal());

  void tap(int tileId) {
    final s = state.valueOrNull;
    if (s == null || s.wordDone || s.summary || s.placed.contains(tileId)) return;
    final haptics = ref.read(settingsProvider).valueOrNull?.haptics ?? true;
    final tile = s.tiles.firstWhere((t) => t.id == tileId);
    if (tile.char == s.chars[s.placed.length]) {
      final placed = [...s.placed, tileId];
      final done = placed.length == s.chars.length;
      if (!done) {
        buzz(haptics, Buzz.light);
        ref.read(soundProvider).play(SoundCue.tap);
        state = AsyncData(s.copyWith(placed: placed));
        return;
      }
      final combo = s.dirty ? 0 : s.combo + 1;
      buzz(haptics, Buzz.medium);
      ref.read(soundProvider).play(!s.dirty && combo % 5 == 0 ? SoundCue.combo : SoundCue.correct);
      if (!s.dirty) {
        ref.read(repoProvider).recordAnswer(s.word.id, true).then((streak) {
          if (streak == 5 && _alive) {
            ref.read(masteredProvider.notifier).state = [s.word.japanese];
          }
        });
      }
      state = AsyncData(s.copyWith(
        placed: placed,
        hits: s.hits + (s.dirty ? 0 : 1),
        combo: combo,
        bestCombo: max(combo, s.bestCombo),
      ));
    } else {
      buzz(haptics, Buzz.soft);
      ref.read(soundProvider).play(SoundCue.wrong);
      // El primer error de la palabra cuenta como fallo; despues solo se corrige.
      if (!s.dirty) ref.read(repoProvider).recordAnswer(s.word.id, false);
      state = AsyncData(s.copyWith(dirty: true, combo: 0, wrongTile: () => tileId));
      Future.delayed(const Duration(milliseconds: 450), () {
        final c = state.valueOrNull;
        if (_alive && c != null) state = AsyncData(c.copyWith(wrongTile: () => null));
      });
    }
  }

  void next() {
    final s = state.requireValue;
    if (s.index + 1 >= s.words.length) {
      state = AsyncData(s.copyWith(summary: true));
      return;
    }
    final word = s.words[s.index + 1];
    state = AsyncData(BuildState(
      words: s.words,
      tiles: _tilesFor(word),
      index: s.index + 1,
      hits: s.hits,
      combo: s.combo,
      bestCombo: s.bestCombo,
    ));
  }
}

final buildWordProvider = AsyncNotifierProvider.autoDispose
    .family<BuildWordGame, BuildState, GameArgs>(BuildWordGame.new);

class BuildWordScreen extends ConsumerWidget {
  const BuildWordScreen({super.key, required this.args});
  final GameArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(buildWordProvider(args));
    final n = ref.read(buildWordProvider(args).notifier);
    ref.listen(masteredProvider, (prev, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(context.l10n.masteredToast(next.join(' '))),
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
                  total: s.words.length,
                  bestCombo: s.bestCombo,
                  onAgain: n.restart,
                  onExit: () => context.pop(),
                );
              }
              final pad = expanded ? 40.0 : 24.0;
              final last = s.index + 1 >= s.words.length;
              return Padding(
                padding: EdgeInsets.fromLTRB(pad, expanded ? 24 : 12, pad, expanded ? 40 : 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      children: [
                        Row(children: [
                          RoundIconButton(
                              icon: Icons.close_rounded,
                              label: context.l10n.close,
                              size: expanded ? 48 : 44,
                              onTap: () => context.pop()),
                          Expanded(
                            child: Text(context.l10n.buildTag,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: context.pt.subtext,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.4)),
                          ),
                          SizedBox(width: expanded ? 48 : 44),
                        ]),
                        const SizedBox(height: 10),
                        ScopeChip(args),
                        const SizedBox(height: 12),
                        SessionProgress(done: s.index, size: s.words.length),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SurfaceCard(
                            radius: 36,
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(s.word.meaning(context.lang) ?? '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 44,
                                              fontWeight: FontWeight.w700,
                                              color: context.pt.flamingo)),
                                    ),
                                  ),
                                ),
                                if (s.wordDone)
                                  Positioned(
                                    right: 18,
                                    bottom: 18,
                                    child: SpeakerButton(
                                        text: s.word.audioText ?? s.word.japanese),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (var i = 0; i < s.chars.length; i++)
                              _Slot(
                                i < s.placed.length ? s.chars[i] : '',
                                done: s.wordDone,
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final t in s.tiles)
                              _TileButton(
                                t.char,
                                used: s.placed.contains(t.id),
                                wrong: s.wrongTile == t.id,
                                onTap: () => n.tap(t.id),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Opacity(
                          opacity: s.wordDone ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !s.wordDone,
                            child: SizedBox(
                              width: double.infinity,
                              child: PillButton(last ? context.l10n.viewSummary : context.l10n.next, onTap: n.next),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot(this.char, {required this.done});
  final String char;
  final bool done;

  @override
  Widget build(BuildContext context) => Container(
        width: 52,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: done ? context.pt.greenTint : context.pt.surface0,
          borderRadius: BorderRadius.circular(context.pt.shape.small),
          border: Border.all(
              color: done ? context.pt.green : (char.isEmpty ? context.pt.surface1 : context.pt.flamingo),
              width: char.isEmpty ? 1 : 2),
        ),
        child: Text(char,
            style: TextStyle(
                fontFamily: Pt.kana,
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: done ? context.pt.green : context.pt.text)),
      );
}

class _TileButton extends StatelessWidget {
  const _TileButton(this.char, {required this.used, required this.wrong, required this.onTap});
  final String char;
  final bool used, wrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: used ? 0.15 : 1,
        child: Material(
          color: wrong ? context.pt.redTint : context.pt.surface0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.pt.shape.small),
            side: BorderSide(color: wrong ? context.pt.red : context.pt.outline, width: wrong ? 2 : context.pt.shape.border),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.pt.shape.small)),
            onTap: used ? null : onTap,
            child: SizedBox(
              width: 64,
              height: 64,
              child: Stack(alignment: Alignment.center, children: [
                Text(char,
                    style: TextStyle(
                        fontFamily: Pt.kana,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        color: wrong ? context.pt.red : context.pt.text)),
                if (wrong)
                  Positioned(
                      top: 4,
                      right: 6,
                      child: Icon(Icons.close_rounded, size: 16, color: context.pt.red)),
              ]),
            ),
          ),
        ),
      );
}
