import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class AppSettings {
  const AppSettings({this.goalMinutes = 20, this.sessionSize = 15});
  final int goalMinutes, sessionSize;

  AppSettings copyWith({int? goalMinutes, int? sessionSize}) => AppSettings(
    goalMinutes: goalMinutes ?? this.goalMinutes,
    sessionSize: sessionSize ?? this.sessionSize,
  );
}

class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final m = await ref.read(repoProvider).allSettings();
    return AppSettings(
      goalMinutes: int.tryParse(m['goal_minutes'] ?? '') ?? 20,
      sessionSize: int.tryParse(m['session_size'] ?? '') ?? 15,
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
}

final settingsProvider = AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
