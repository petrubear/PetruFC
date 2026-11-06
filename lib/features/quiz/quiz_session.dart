import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_settings.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/feedback/feedback.dart';
import 'quiz_engine.dart';
import '../../core/l10n/language.dart';
import '../../core/audio/sound_service.dart';

typedef QuizArgs = (String moduleId, QuizMode mode, String? groupId, bool multi);

class QuizState {
  const QuizState({
    required this.question,
    required this.size,
    this.selected,
    this.correct = 0,
    this.wrong = 0,
    this.combo = 0,
    this.bestCombo = 0,
    this.summary = false,
    this.celebrations = 0,
    this.mastered = const [],
  });
  final QuizQuestion question;
  final String? selected;
  final int size, correct, wrong, combo, bestCombo;
  final bool summary;
  final int celebrations; // sube con cada hito de combo (dispara el confeti)
  final List<String> mastered; // caracteres que acaban de llegar a verde

  bool get answered => selected != null;
  int get done => correct + wrong;
  bool get finished => answered && done >= size;
}

class QuizSession extends AutoDisposeFamilyAsyncNotifier<QuizState, QuizArgs> {
  late QuizEngine _engine;

  @override
  Future<QuizState> build(QuizArgs arg) async {
    final (moduleId, mode, groupId, multi) = arg;
    // Si el telefono cambia de idioma la ronda se reinicia con los textos nuevos.
    final lang = ref.watch(appLanguageProvider);
    final repo = ref.read(repoProvider);
    final Set<String> ids;
    if (mode.kind == 'kana' || mode.kind == 'kanji') {
      ids = await ref.read(activeGroupsProvider(moduleId).future);
    } else if (groupId != null) {
      ids = {groupId};
    } else {
      ids = (await repo.groups(moduleId, 'word')).map((g) => g.id).toSet();
    }
    final details =
        mode.kind == 'kanji' ? await ref.read(kanjiDetailsProvider.future) : <int, KanjiDetail>{};
    _engine = QuizEngine(await repo.items(moduleId, ids), mode, lang, multi: multi, details: details);
    final size = (await ref.read(settingsProvider.future)).sessionSize;
    return QuizState(question: _engine.next(), size: size);
  }

  Future<void> answer(String option) async {
    final s = state.requireValue;
    if (s.answered) return;
    final ok = option == s.question.correct;
    final haptics = ref.read(settingsProvider).valueOrNull?.haptics ?? true;
    final combo = ok ? s.combo + 1 : 0;
    final milestone = ok && combo % 5 == 0;
    buzz(haptics, !ok ? Buzz.soft : (milestone ? Buzz.medium : Buzz.light));
    ref.read(soundProvider).play(!ok ? SoundCue.wrong : (milestone ? SoundCue.combo : SoundCue.correct));
    state = AsyncData(QuizState(
      question: s.question,
      size: s.size,
      selected: option,
      correct: s.correct + (ok ? 1 : 0),
      wrong: s.wrong + (ok ? 0 : 1),
      combo: combo,
      bestCombo: combo > s.bestCombo ? combo : s.bestCombo,
      celebrations: s.celebrations + (milestone ? 1 : 0),
    ));
    final mastered = <String>[];
    for (final i in s.question.items) {
      final streak = await ref.read(repoProvider).recordAnswer(i.id, ok);
      if (ok && streak == 5) mastered.add(i.japanese);
    }
    final cur = state.valueOrNull;
    if (mastered.isNotEmpty && cur != null && cur.question == s.question) {
      buzz(haptics, Buzz.heavy);
      state = AsyncData(QuizState(
        question: cur.question,
        size: cur.size,
        selected: cur.selected,
        correct: cur.correct,
        wrong: cur.wrong,
        combo: cur.combo,
        bestCombo: cur.bestCombo,
        celebrations: cur.celebrations + 1,
        mastered: mastered,
      ));
    }
  }

  void next() {
    final s = state.requireValue;
    state = AsyncData(
      QuizState(
        question: s.finished ? s.question : _engine.next(),
        size: s.size,
        selected: s.finished ? s.selected : null,
        correct: s.correct,
        wrong: s.wrong,
        combo: s.combo,
        bestCombo: s.bestCombo,
        summary: s.finished,
      ),
    );
  }

  void restart() {
    final s = state.requireValue;
    state = AsyncData(QuizState(question: _engine.next(), size: s.size));
  }
}

final quizSessionProvider = AsyncNotifierProvider.autoDispose
    .family<QuizSession, QuizState, QuizArgs>(QuizSession.new);
