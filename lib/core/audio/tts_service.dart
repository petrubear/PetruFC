import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../l10n/language.dart';

enum TtsError {
  noVoice,
  failed;

  String message(AppLocalizations l) => this == noVoice ? l.ttsNoVoice : l.ttsFailed;
}

class TtsService {
  final _tts = FlutterTts();
  bool _ready = false;

  /// Devuelve el tipo de error si falla, o null si habla.
  Future<TtsError?> speak(String text) async {
    try {
      if (!_ready) {
        final available = await _tts.isLanguageAvailable('ja-JP');
        if (available != true) {
          return TtsError.noVoice;
        }
        await _tts.setLanguage('ja-JP');
        await _tts.setSpeechRate(0.4);
        _ready = true;
      }
      await _tts.stop();
      await _tts.speak(text);
      return null;
    } catch (_) {
      return TtsError.failed;
    }
  }
}

final ttsProvider = Provider<TtsService>((ref) => TtsService());
