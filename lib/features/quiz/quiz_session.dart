import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import 'quiz_engine.dart';

typedef QuizArgs = (String moduleId, QuizMode mode);

class QuizState {
  const QuizState({
    required this.question,
    this.selected,
    this.correct = 0,
    this.wrong = 0,
  });
  final QuizQuestion question;
  final String? selected;
  final int correct, wrong;

  bool get answered => selected != null;
}

class QuizSession extends AutoDisposeFamilyAsyncNotifier<QuizState, QuizArgs> {
  late QuizEngine _engine;

  @override
  Future<QuizState> build(QuizArgs arg) async {
    final (moduleId, mode) = arg;
    final repo = ref.read(repoProvider);
    final Set<String> ids;
    if (mode.kind == 'kana') {
      ids = await ref.read(activeGroupsProvider(moduleId).future);
    } else {
      ids = (await repo.groups(moduleId, 'word')).map((g) => g.id).toSet();
    }
    _engine = QuizEngine(await repo.items(moduleId, ids), mode);
    return QuizState(question: _engine.next());
  }

  void answer(String option) {
    final s = state.requireValue;
    if (s.answered) return;
    final ok = option == s.question.correct;
    ref.read(repoProvider).recordAnswer(s.question.item.id, ok);
    state = AsyncData(QuizState(
      question: s.question,
      selected: option,
      correct: s.correct + (ok ? 1 : 0),
      wrong: s.wrong + (ok ? 0 : 1),
    ));
  }

  void next() {
    final s = state.requireValue;
    state = AsyncData(QuizState(
      question: _engine.next(),
      correct: s.correct,
      wrong: s.wrong,
    ));
  }
}

final quizSessionProvider = AsyncNotifierProvider.autoDispose
    .family<QuizSession, QuizState, QuizArgs>(QuizSession.new);
