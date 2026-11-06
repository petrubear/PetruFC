import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class AppSettings {
  const AppSettings({
    this.goalMinutes = 20,
    this.sessionSize = 15,
    this.haptics = true,
    this.effects = true,
    this.mascotOn = true,
    this.soundOn = true,
    this.styleId = 'washi',
    this.lastRoute = '',
  });
  final int goalMinutes, sessionSize;
  final bool haptics, effects, mascotOn, soundOn;
  final String styleId, lastRoute;

  AppSettings copyWith({
    int? goalMinutes,
    int? sessionSize,
    bool? haptics,
    bool? effects,
    bool? mascotOn,
    bool? soundOn,
    String? styleId,
    String? lastRoute,
  }) =>
      AppSettings(
        goalMinutes: goalMinutes ?? this.goalMinutes,
        sessionSize: sessionSize ?? this.sessionSize,
        haptics: haptics ?? this.haptics,
        effects: effects ?? this.effects,
        mascotOn: mascotOn ?? this.mascotOn,
        soundOn: soundOn ?? this.soundOn,
        styleId: styleId ?? this.styleId,
        lastRoute: lastRoute ?? this.lastRoute,
      );
}

class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final m = await ref.read(repoProvider).allSettings();
    return AppSettings(
      goalMinutes: int.tryParse(m['goal_minutes'] ?? '') ?? 20,
      sessionSize: int.tryParse(m['session_size'] ?? '') ?? 15,
      haptics: m['haptics'] != '0',
      effects: m['effects'] != '0',
      mascotOn: m['mascot_on'] != '0',
      soundOn: m['sound'] != '0',
      styleId: m['style'] ?? 'washi',
      lastRoute: m['last_route'] ?? '',
    );
  }

  Future<void> setGoalMinutes(int v) async {
    await ref.read(repoProvider).saveSetting('goal_minutes', '$v');
    state = AsyncData(state.requireValue.copyWith(goalMinutes: v));
  }

  Future<void> setSessionSize(int v) async {
    await ref.read(repoProvider).saveSetting('session_size', '$v');
    state = AsyncData(state.requireValue.copyWith(sessionSize: v));
  }

  Future<void> setHaptics(bool v) async {
    await ref.read(repoProvider).saveSetting('haptics', v ? '1' : '0');
    state = AsyncData(state.requireValue.copyWith(haptics: v));
  }

  Future<void> setMascotOn(bool v) async {
    await ref.read(repoProvider).saveSetting('mascot_on', v ? '1' : '0');
    state = AsyncData(state.requireValue.copyWith(mascotOn: v));
  }

  Future<void> setSoundOn(bool v) async {
    await ref.read(repoProvider).saveSetting('sound', v ? '1' : '0');
    state = AsyncData(state.requireValue.copyWith(soundOn: v));
  }

  Future<void> setLastRoute(String v) async {
    final cur = state.valueOrNull;
    if (cur == null || cur.lastRoute == v) return;
    state = AsyncData(cur.copyWith(lastRoute: v));
    await ref.read(repoProvider).saveSetting('last_route', v);
  }

  Future<void> setStyle(String v) async {
    await ref.read(repoProvider).saveSetting('style', v);
    state = AsyncData(state.requireValue.copyWith(styleId: v));
  }

  Future<void> setEffects(bool v) async {
    await ref.read(repoProvider).saveSetting('effects', v ? '1' : '0');
    state = AsyncData(state.requireValue.copyWith(effects: v));
  }
}

final settingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);
