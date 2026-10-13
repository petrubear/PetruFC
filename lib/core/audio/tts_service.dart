import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final _tts = FlutterTts();
  bool _ready = false;

  /// Devuelve un mensaje para mostrar al usuario si falla, o null si habla.
  Future<String?> speak(String text) async {
    try {
      if (!_ready) {
        final available = await _tts.isLanguageAvailable('ja-JP');
        if (available != true) {
          return 'Falta la voz japonesa. Instálala en Ajustes > Salida de texto a voz.';
        }
        await _tts.setLanguage('ja-JP');
        await _tts.setSpeechRate(0.4);
        _ready = true;
      }
      await _tts.stop();
      await _tts.speak(text);
      return null;
    } catch (_) {
      return 'No se pudo reproducir el audio.';
    }
  }
}

final ttsProvider = Provider<TtsService>((ref) => TtsService());
