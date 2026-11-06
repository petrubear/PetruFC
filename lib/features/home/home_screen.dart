import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
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

class _Header extends StatelessWidget {
  const _Header({this.title = 38});
  final double title;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: _titles(context)),
      RoundIconButton(
        icon: Icons.settings_rounded,
        label: context.l10n.settings,
        onTap: () => context.push('/settings'),
      ),
    ],
  );

  Widget _titles(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '日本語 · NIHONGO',
        style: TextStyle(
          color: context.pt.flamingo,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 2,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Petru FC',
        style: TextStyle(fontSize: title, fontWeight: FontWeight.w700, height: 1.1),
      ),
      const SizedBox(height: 6),
      Text(context.l10n.homeTagline, style: TextStyle(fontSize: 16, color: context.pt.subtext)),
    ],
  );
}

class _Narrow extends StatelessWidget {
  const _Narrow(this.modules);
  final List<StudyModule> modules;

  @override
  Widget build(BuildContext context) {
    final active = modules.where((m) => m.enabled);
    final soon = modules.where((m) => !m.enabled).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      children: [
        const _Header(),
        const SizedBox(height: 16),
        const MascotGreeting(),
        const SizedBox(height: 8),
        const DailyGoalCard(),
        const SizedBox(height: 20),
        for (final m in active) ...[_Hero(m), SizedBox(height: 16)],
        if (soon.isNotEmpty) ...[
          SizedBox(height: 12),
          SectionLabel(context.l10n.comingSoon),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [for (final m in soon) _Soon(m)],
          ),
        ],
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero(this.m);
  final StudyModule m;

  @override
  Widget build(BuildContext context) => Material(
        color: context.pt.surface0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(color: context.pt.surface1),
        ),
        child: InkWell(
          onTap: () => context.push('/m/${m.id}'),
          child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                Positioned(
                  right: -6,
                  top: -18,
                  child: Text(m.glyph,
                      style: TextStyle(
                          fontFamily: Pt.kana,
                          fontWeight: FontWeight.w700,
                          fontSize: 210,
                          height: 1,
                          color: context.pt.flamingo)),
                ),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 200,
                        child: Text(context.l10n.moduleBlurb,
                            style: TextStyle(fontSize: 15, color: context.pt.subtext)),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                            color: context.pt.flamingo,
                            borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(context.l10n.open,
                                style: TextStyle(
                                    color: context.pt.crust,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, color: context.pt.crust, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Soon extends StatelessWidget {
  const _Soon(this.m);
  final StudyModule m;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: 0.7,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: context.pt.surface0, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(m.glyph,
                  style: TextStyle(
                      fontFamily: Pt.kana, fontSize: 40, height: 1.1, color: context.pt.pink)),
              Text(m.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );
}

class _Wide extends ConsumerWidget {
  const _Wide(this.modules);
  final List<StudyModule> modules;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedModuleProvider);
    final soon = modules.where((m) => !m.enabled).toList();
    return Row(
      children: [
        Container(
          width: 312,
          color: context.pt.mantle,
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: ListView(
            children: [
              const _Header(title: 36),
              const SizedBox(height: 12),
              const MascotGreeting(height: 84),
              const SizedBox(height: 8),
              const DailyGoalCard(),
              const SizedBox(height: 20),
              for (final m in modules.where((m) => m.enabled)) ...[
                _SideTile(m,
                    selected: m.id == selected,
                    onTap: () => ref.read(selectedModuleProvider.notifier).state = m.id),
                SizedBox(height: 12),
              ],
              if (soon.isNotEmpty) ...[
                SizedBox(height: 10),
                SectionLabel(context.l10n.comingSoon),
                const SizedBox(height: 12),
                for (final m in soon) ...[
                  Opacity(opacity: 0.7, child: _SideTile(m, selected: false, onTap: null)),
                  const SizedBox(height: 12),
                ],
              ],
            ],
          ),
        ),
        Expanded(child: ModuleMenuBody(moduleId: selected, expanded: true)),
      ],
    );
  }
}

class _SideTile extends StatelessWidget {
  const _SideTile(this.m, {required this.selected, required this.onTap});
  final StudyModule m;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: context.pt.surface0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
              color: selected ? context.pt.flamingo : Colors.transparent, width: 2),
        ),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Text(m.glyph,
                    style: TextStyle(
                        fontFamily: Pt.kana,
                        fontWeight: FontWeight.w700,
                        fontSize: 44,
                        height: 1,
                        color: m.enabled ? context.pt.flamingo : context.pt.pink)),
                const SizedBox(width: 14),
                Text(m.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
}
