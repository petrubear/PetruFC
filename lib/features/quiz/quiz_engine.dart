import 'dart:math';

import '../../core/data/database.dart';

// (nombre del sistema, kana de ejemplo, palabra de ejemplo, su significado)
const _scripts = {
  'hiragana': ('Hiragana', 'あ', 'はな', 'Nariz'),
  'katakana': ('Katakana', 'ア', 'コーヒー', 'Café'),
};

enum QuizMode {
  kanaToRomaji('Hiragana → Romaji', 'kana', true),
  romajiToKana('Romaji → Hiragana', 'kana', false),
  wordToMeaning('Hiragana → Español', 'word', true),
  meaningToWord('Español → Hiragana', 'word', false);

  const QuizMode(this._template, this.kind, this.promptIsJapanese);
  final String _template, kind;
  final bool promptIsJapanese;

  (String, String, String, String) _script(String moduleId) =>
      _scripts[moduleId] ?? _scripts['hiragana']!;

  String label(String moduleId) =>
      _template.replaceAll('Hiragana', _script(moduleId).$1);

  String badge(String moduleId) {
    final s = _script(moduleId);
    return switch (this) {
      kanaToRomaji => '${s.$2}→a',
      romajiToKana => 'a→${s.$2}',
      wordToMeaning => '${s.$3}→${s.$4}',
      meaningToWord => '${s.$4}→${s.$3}',
    };
  }

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
