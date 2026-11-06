import 'dart:math';

import '../../core/data/database.dart';
import '../../core/l10n/language.dart';

// (nombre del sistema, kana de ejemplo, palabra de ejemplo, significado en espanol e ingles)
const _scripts = {
  'hiragana': ('Hiragana', 'あ', 'はな', 'Nariz', 'Nose'),
  'katakana': ('Katakana', 'ア', 'コーヒー', 'Café', 'Coffee'),
};

enum QuizMode {
  kanaToRomaji('kana', true),
  romajiToKana('kana', false),
  scriptSwap('kana', true),
  wordToMeaning('word', true),
  meaningToWord('word', false);

  const QuizMode(this.kind, this.promptIsJapanese);
  final String kind;
  final bool promptIsJapanese;

  (String, String, String, String, String) _script(String moduleId) =>
      _scripts[moduleId] ?? _scripts['hiragana']!;

  String label(AppLocalizations l, String moduleId) {
    final script = _script(moduleId).$1;
    return switch (this) {
      kanaToRomaji => l.modeKanaToRomaji(script),
      romajiToKana => l.modeRomajiToKana(script),
      scriptSwap => moduleId == 'katakana'
          ? l.modeScriptSwap('Katakana', 'Hiragana')
          : l.modeScriptSwap('Hiragana', 'Katakana'),
      wordToMeaning => l.modeWordToMeaning(script),
      meaningToWord => l.modeMeaningToWord(script),
    };
  }

  String badge(String moduleId, AppLanguage lang) {
    final s = _script(moduleId);
    final meaning = lang == AppLanguage.en ? s.$5 : s.$4;
    return switch (this) {
      kanaToRomaji => '${s.$2}→a',
      romajiToKana => 'a→${s.$2}',
      scriptSwap => moduleId == 'katakana' ? 'ア→あ' : 'あ→ア',
      wordToMeaning => '${s.$3}→$meaning',
      meaningToWord => '$meaning→${s.$3}',
    };
  }

  bool get answersAreJapanese => this == scriptSwap || !promptIsJapanese;

  String prompt(Item i, AppLanguage lang) => switch (this) {
        kanaToRomaji || scriptSwap || wordToMeaning => i.japanese,
        romajiToKana => i.reading,
        meaningToWord => i.meaning(lang)!,
      };

  String answer(Item i, AppLanguage lang) => switch (this) {
        kanaToRomaji => i.reading,
        romajiToKana || meaningToWord => i.japanese,
        scriptSwap => _swapScript(i),
        wordToMeaning => i.meaning(lang)!,
      };
}

// Hiragana (U+3041..) y katakana (U+30A1..) estan separados por 0x60 punto a punto.
String _swapScript(Item i) {
  final toHira = i.moduleId == 'katakana';
  return String.fromCharCodes(
      i.japanese.runes.map((r) => toHira ? r - 0x60 : r + 0x60));
}

class QuizQuestion {
  const QuizQuestion(this.items, this.prompt, this.options, this.correct);
  final List<Item> items;
  Item get item => items.first;
  final String prompt;
  final List<String> options;
  final String correct;
}

class QuizEngine {
  QuizEngine(this.pool, this.mode, this.lang, {this.multi = false, Random? rng})
      : _rng = rng ?? Random();
  final List<Item> pool;
  final QuizMode mode;
  final AppLanguage lang;
  final bool multi;

  String _answer(Item i) => mode.answer(i, lang);
  String _prompt(Item i) => mode.prompt(i, lang);
  final Random _rng;
  int? _lastId;

  // 9 caracteres en 3 bloques de 3 (una linea por bloque).
  static String _blocks(List<String> v) => [
        for (var i = 0; i < v.length; i += 3) v.sublist(i, i + 3).join(' '),
      ].join('\n');

  QuizQuestion _nextMulti() {
    final picks = [for (var i = 0; i < 9; i++) pool[_rng.nextInt(pool.length)]];
    final answers = picks.map(_answer).toList();
    final correct = _blocks(answers);
    final choices = pool.map(_answer).toSet().toList();
    final options = <String>{correct};
    for (var tries = 0; options.length < 4 && tries < 50; tries++) {
      final alt = [...answers];
      final slots = List.generate(9, (i) => i)..shuffle(_rng);
      for (final i in slots.take(2 + _rng.nextInt(2))) {
        alt[i] = choices[_rng.nextInt(choices.length)];
      }
      options.add(_blocks(alt));
    }
    return QuizQuestion(picks, _blocks(picks.map(_prompt).toList()),
        options.toList()..shuffle(_rng), correct);
  }

  QuizQuestion next() {
    if (multi) return _nextMulti();
    Item target;
    do {
      target = pool[_rng.nextInt(pool.length)];
    } while (pool.length > 1 && target.id == _lastId);
    _lastId = target.id;
    final correct = _answer(target);
    final others = pool.map(_answer).where((a) => a != correct).toSet().toList()
      ..shuffle(_rng);
    final options = [correct, ...others.take(3)]..shuffle(_rng);
    return QuizQuestion([target], _prompt(target), options, correct);
  }
}
