import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_settings.dart';

/// Sonidos de interfaz inspirados en el shamisen (ver `tool/make_sfx.py`).
enum SoundCue { tap, correct, wrong, combo, goal }

class SoundService {
  SoundService(this._enabled);
  final bool Function() _enabled;
  final Map<SoundCue, AudioPlayer> _players = {};
  final Map<SoundCue, DateTime> _last = {};
  bool _ready = false;

  Future<AudioPlayer> _player(SoundCue cue) async {
    if (!_ready) {
      _ready = true;
      await AudioPlayer.global.setAudioContext(AudioContext(
        android: const AudioContextAndroid(
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.none,
        ),
      ));
    }
    final existing = _players[cue];
    if (existing != null) return existing;
    final p = AudioPlayer()..setPlayerMode(PlayerMode.lowLatency);
    await p.setReleaseMode(ReleaseMode.stop);
    await p.setSource(AssetSource('sfx/${cue.name}.wav'));
    return _players[cue] = p;
  }

  /// Reproduce el sonido sin esperar; ignora fallos y respeta el ajuste.
  void play(SoundCue cue) {
    if (!_enabled()) return;
    final now = DateTime.now();
    final prev = _last[cue];
    if (prev != null && now.difference(prev).inMilliseconds < 80) return;
    _last[cue] = now;
    () async {
      try {
        final p = await _player(cue);
        await p.stop();
        await p.resume();
      } catch (_) {}
    }();
  }

  void dispose() {
    for (final p in _players.values) {
      p.dispose();
    }
  }
}

final soundProvider = Provider<SoundService>((ref) {
  final s = SoundService(
      () => ref.read(settingsProvider).valueOrNull?.soundOn ?? true);
  ref.onDispose(s.dispose);
  return s;
});
