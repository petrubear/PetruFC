import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'module_menu.dart';

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
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('日本語 · NIHONGO',
              style: TextStyle(
                  color: Pt.flamingo,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2)),
          const SizedBox(height: 6),
          Text('Petru FC',
              style: TextStyle(fontSize: title, fontWeight: FontWeight.w700, height: 1.1)),
          const SizedBox(height: 6),
          const Text('Estudia japonés a tu ritmo',
              style: TextStyle(fontSize: 16, color: Pt.subtext)),
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
        const SizedBox(height: 28),
        for (final m in active) ...[_Hero(m), const SizedBox(height: 16)],
        if (soon.isNotEmpty) ...[
          const SizedBox(height: 12),
          const SectionLabel('PRÓXIMAMENTE'),
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
        color: Pt.surface0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: Pt.surface1),
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
                      style: const TextStyle(
                          fontFamily: Pt.kana,
                          fontWeight: FontWeight.w700,
                          fontSize: 210,
                          height: 1,
                          color: Pt.flamingo)),
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
                      const SizedBox(
                        width: 200,
                        child: Text('Flashcards, práctica y vocabulario',
                            style: TextStyle(fontSize: 15, color: Pt.subtext)),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                            color: Pt.flamingo,
                            borderRadius: BorderRadius.circular(999)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Entrar',
                                style: TextStyle(
                                    color: Pt.crust,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, color: Pt.crust, size: 18),
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
              color: Pt.surface0, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(m.glyph,
                  style: const TextStyle(
                      fontFamily: Pt.kana, fontSize: 40, height: 1.1, color: Pt.pink)),
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
          color: Pt.mantle,
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: ListView(
            children: [
              const _Header(title: 36),
              const SizedBox(height: 24),
              for (final m in modules.where((m) => m.enabled)) ...[
                _SideTile(m,
                    selected: m.id == selected,
                    onTap: () => ref.read(selectedModuleProvider.notifier).state = m.id),
                const SizedBox(height: 12),
              ],
              if (soon.isNotEmpty) ...[
                const SizedBox(height: 10),
                const SectionLabel('PRÓXIMAMENTE'),
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
        color: Pt.surface0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
              color: selected ? Pt.flamingo : Colors.transparent, width: 2),
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
                        color: m.enabled ? Pt.flamingo : Pt.pink)),
                const SizedBox(width: 14),
                Text(m.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
}
