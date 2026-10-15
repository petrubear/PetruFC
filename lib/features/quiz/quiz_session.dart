import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_settings.dart';
import '../../core/data/providers.dart';
import 'quiz_engine.dart';

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
  });
  final QuizQuestion question;
  final String? selected;
  final int size, correct, wrong, combo, bestCombo;
  final bool summary;

  bool get answered => selected != null;
  int get done => correct + wrong;
  bool get finished => answered && done >= size;
}

class QuizSession extends AutoDisposeFamilyAsyncNotifier<QuizState, QuizArgs> {
  late QuizEngine _engine;

  @override
  Future<QuizState> build(QuizArgs arg) async {
    final (moduleId, mode, groupId, multi) = arg;
    final repo = ref.read(repoProvider);
    final Set<String> ids;
    if (mode.kind == 'kana') {
      ids = await ref.read(activeGroupsProvider(moduleId).future);
    } else if (groupId != null) {
      ids = {groupId};
    } else {
      ids = (await repo.groups(moduleId, 'word')).map((g) => g.id).toSet();
    }
    _engine = QuizEngine(await repo.items(moduleId, ids), mode, multi: multi);
    final size = (await ref.read(settingsProvider.future)).sessionSize;
    return QuizState(question: _engine.next(), size: size);
  }

  void answer(String option) {
    final s = state.requireValue;
    if (s.answered) return;
    final ok = option == s.question.correct;
    for (final i in s.question.items) {
      ref.read(repoProvider).recordAnswer(i.id, ok);
    }
    final combo = ok ? s.combo + 1 : 0;
    state = AsyncData(
      QuizState(
        question: s.question,
        size: s.size,
        selected: option,
        correct: s.correct + (ok ? 1 : 0),
        wrong: s.wrong + (ok ? 0 : 1),
        combo: combo,
        bestCombo: combo > s.bestCombo ? combo : s.bestCombo,
      ),
    );
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
