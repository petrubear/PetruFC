import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/app_version.dart';
import '../../core/data/app_settings.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../../core/l10n/language.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = isExpanded(context);
    final settings = ref.watch(settingsProvider).valueOrNull ?? const AppSettings();
    final n = ref.read(settingsProvider.notifier);
    Widget size(int v) => Expanded(
      child: PillButton(
        context.l10n.settingsCards(v),
        onTap: () => n.setSessionSize(v),
        bg: settings.sessionSize == v ? context.pt.flamingo : context.pt.surface0,
        fg: settings.sessionSize == v ? context.pt.crust : context.pt.text,
        border: settings.sessionSize == v ? null : context.pt.surface1,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: EdgeInsets.fromLTRB(expanded ? 40 : 24, 12, expanded ? 40 : 24, 32),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: RoundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    label: context.l10n.back,
                    size: expanded ? 48 : 44,
                    onTap: () => context.pop(),
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  context.l10n.settings,
                  style: TextStyle(fontSize: expanded ? 38 : 32, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 24),
                SectionLabel(context.l10n.settingsDailyGoal),
                const SizedBox(height: 12),
                SurfaceCard(
                  radius: 28,
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.settingsGoalMinutes(settings.goalMinutes),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        context.l10n.settingsGoalHint,
                        style: TextStyle(fontSize: 13, color: context.pt.subtext),
                      ),
                      Slider(
                        value: settings.goalMinutes.toDouble(),
                        min: 5,
                        max: 60,
                        divisions: 11,
                        label: context.l10n.settingsGoalSlider(settings.goalMinutes),
                        onChanged: (v) => n.setGoalMinutes(v.round()),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SectionLabel(context.l10n.settingsRoundSize),
                const SizedBox(height: 12),
                Row(children: [size(15), const SizedBox(width: 12), size(20)]),
                const SizedBox(height: 8),
                Text(
                  context.l10n.settingsRoundHint,
                  style: TextStyle(fontSize: 13, color: context.pt.subtext),
                ),
                SizedBox(height: 24),
                SizedBox(height: 24),
                SectionLabel(context.l10n.settingsFeedback),
                const SizedBox(height: 12),
                SurfaceCard(
                  radius: 28,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(context.l10n.settingsVibration),
                        subtitle: Text(context.l10n.settingsVibrationSub),
                        value: settings.haptics,
                        onChanged: n.setHaptics,
                      ),
                      SwitchListTile(
                        title: Text(context.l10n.settingsEffects),
                        subtitle: Text(context.l10n.settingsEffectsSub),
                        value: settings.effects,
                        onChanged: n.setEffects,
                      ),
                      SwitchListTile(
                        title: Text(context.l10n.settingsMascot),
                        subtitle: Text(context.l10n.settingsMascotSub),
                        value: settings.mascotOn,
                        onChanged: n.setMascotOn,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(context.l10n.settingsVersion(appVersion),
                      style: TextStyle(color: context.pt.subtext, fontSize: 13)),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(context.l10n.settingsCredit,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.pt.subtext, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
