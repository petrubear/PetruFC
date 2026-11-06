import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/audio/sound_service.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../../core/data/app_settings.dart';
import '../../core/widgets/seal_mark.dart';
import 'continue_button.dart';
import 'daily_goal_card.dart';
import 'module_menu.dart';
import '../../core/l10n/language.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(modulesProvider);
    return Scaffold(
      body: SafeArea(
        child: modules.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => isExpanded(context) ? _Wide(list) : _Narrow(list),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(settingsProvider).valueOrNull?.soundOn ?? true;
    return Row(
      children: [
        const SealMark(),
        const SizedBox(width: 10),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text('Petru FC', maxLines: 1, style: context.pt.display(21)),
          ),
        ),
        RoundIconButton(
          icon: on ? Icons.volume_up_rounded : Icons.volume_off_rounded,
          label: on ? context.l10n.soundOnLabel : context.l10n.soundOffLabel,
          onTap: () => ref.read(settingsProvider.notifier).setSoundOn(!on),
        ),
        const SizedBox(width: 8),
        RoundIconButton(
          icon: Icons.settings_rounded,
          label: context.l10n.settings,
          onTap: () => context.push('/settings'),
        ),
      ],
    );
  }
}

class _Narrow extends StatelessWidget {
  const _Narrow(this.modules);
  final List<StudyModule> modules;

  @override
  Widget build(BuildContext context) {
    final active = modules.where((m) => m.enabled);
    final soon = modules.where((m) => !m.enabled).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        const _Header(),
        const SizedBox(height: 20),
        const DailyGoalCard(),
        const SizedBox(height: 8),
        const MascotGreeting(),
        const SizedBox(height: 12),
        const ContinueButton(),
        const SizedBox(height: 24),
        SectionLabel(context.l10n.modulesLabel),
        const SizedBox(height: 12),
        for (final m in active) ...[_ModuleCard(m), const SizedBox(height: 12)],
        for (final m in soon) ...[_ModuleCard(m), const SizedBox(height: 12)],
      ],
    );
  }
}

class _ModuleCard extends ConsumerWidget {
  const _ModuleCard(this.m);
  final StudyModule m;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.pt;
    final color = m.id == 'katakana' ? c.indigo : (m.enabled ? c.flamingo : c.subtext);
    return Opacity(
      opacity: m.enabled ? 1 : 0.8,
      child: Material(
        color: m.enabled ? c.surface0 : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(c.shape.large),
          side: BorderSide(
              color: m.enabled ? c.outline : c.surface2, width: c.shape.border),
        ),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(c.shape.large)),
          onTap: m.enabled
              ? () {
                  ref.read(soundProvider).play(SoundCue.tap);
                  context.push('/m/${m.id}');
                }
              : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 88),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(children: [
                SizedBox(
                    width: 56, child: Center(child: Text(m.glyph, style: c.display(42, color: color)))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      Text(m.enabled ? context.l10n.moduleBlurb : context.l10n.comingSoonShort,
                          style: TextStyle(fontSize: 13, color: c.subtext)),
                      if (m.enabled) ...[
                        const SizedBox(height: 8),
                        _ProgressBar(m.id, color),
                      ],
                    ],
                  ),
                ),
                if (m.enabled) ...[
                  _Percent(m.id),
                  Icon(Icons.chevron_right_rounded, color: c.subtext),
                ],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Wide extends ConsumerWidget {
  const _Wide(this.modules);
  final List<StudyModule> modules;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedModuleProvider);
    final c = context.pt;
    return Row(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width < 800 ? 280 : 312,
          decoration: BoxDecoration(
            color: c.mantle,
            border: Border(right: BorderSide(color: c.outline, width: c.shape.border)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          child: ListView(
            children: [
              const _Header(),
              const SizedBox(height: 20),
              const DailyGoalCard(),
              const SizedBox(height: 8),
              const MascotGreeting(height: 72),
              const SizedBox(height: 16),
              SectionLabel(context.l10n.modulesLabel),
              const SizedBox(height: 12),
              for (final m in modules) ...[
                _SideTile(m,
                    selected: m.enabled && m.id == selected,
                    onTap: m.enabled
                        ? () => ref.read(selectedModuleProvider.notifier).state = m.id
                        : null),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        Expanded(child: ModuleMenuBody(moduleId: selected, expanded: true)),
      ],
    );
  }
}

class _SideTile extends ConsumerWidget {
  const _SideTile(this.m, {required this.selected, required this.onTap});
  final StudyModule m;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.pt;
    final color = m.id == 'katakana' ? c.indigo : (m.enabled ? c.flamingo : c.subtext);
    return Material(
      color: m.enabled ? c.surface0 : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(c.shape.medium),
        side: BorderSide(
            color: selected ? c.flamingo : (m.enabled ? c.outline : c.surface2),
            width: selected ? 2.5 : c.shape.border),
      ),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(c.shape.medium)),
        onTap: onTap == null
            ? null
            : () {
                ref.read(soundProvider).play(SoundCue.tap);
                onTap!();
              },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                    width: 44, child: Center(child: Text(m.glyph, style: c.display(32, color: color)))),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(m.name,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: m.enabled ? c.text : c.subtext)),
                ),
                if (!m.enabled)
                  Text(context.l10n.comingSoonShort,
                      style: TextStyle(fontSize: 11, letterSpacing: 1, color: c.subtext))
                else
                  _Percent(m.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Percent extends ConsumerWidget {
  const _Percent(this.moduleId);
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(moduleProgressProvider(moduleId)).valueOrNull ?? 0;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text('${(v * 100).round()}%',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: context.pt.subtext)),
    );
  }
}

class _ProgressBar extends ConsumerWidget {
  const _ProgressBar(this.moduleId, this.color);
  final String moduleId;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(moduleProgressProvider(moduleId)).valueOrNull ?? 0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.pt.shape.pill),
      child: LinearProgressIndicator(
        value: v,
        minHeight: 6,
        backgroundColor: context.pt.surface1,
        color: color,
      ),
    );
  }
}
