import 'dart:math';

import '../../core/data/database.dart';

enum QuizMode {
  kanaToRomaji('Hiragana → Romaji', 'あ→a', 'kana', true),
  romajiToKana('Romaji → Hiragana', 'a→あ', 'kana', false),
  wordToMeaning('Hiragana → Español', 'はな→Nariz', 'word', true),
  meaningToWord('Español → Hiragana', 'Nariz→はな', 'word', false);

  const QuizMode(this.label, this.badge, this.kind, this.promptIsJapanese);
  final String label, badge, kind;
  final bool promptIsJapanese;

  bool get answersAreJapanese => !promptIsJapanese;

  String prompt(Item i) => switch (this) {
        kanaToRomaji || wordToMeaning => i.japanese,
        romajiToKana => i.reading,
        meaningToWord => i.meaningEs!,
      };

  String answer(Item i) => switch (this) {
        kanaToRomaji => i.reading,
        romajiToKana || meaningToWord => i.japanese,
        wordToMeaning => i.meaningEs!,
      };
}

class QuizQuestion {
  const QuizQuestion(this.item, this.prompt, this.options, this.correct);
  final Item item;
  final String prompt;
  final List<String> options;
  final String correct;
}

class QuizEngine {
  QuizEngine(this.pool, this.mode, [Random? rng]) : _rng = rng ?? Random();
  final List<Item> pool;
  final QuizMode mode;
  final Random _rng;
  int? _lastId;

  QuizQuestion next() {
    Item target;
    do {
      target = pool[_rng.nextInt(pool.length)];
    } while (pool.length > 1 && target.id == _lastId);
    _lastId = target.id;
    final correct = mode.answer(target);
    final others = pool.map(mode.answer).where((a) => a != correct).toSet().toList()
      ..shuffle(_rng);
    final options = [correct, ...others.take(3)]..shuffle(_rng);
    return QuizQuestion(target, mode.prompt(target), options, correct);
  }
}
