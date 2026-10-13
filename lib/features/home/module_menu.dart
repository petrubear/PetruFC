import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'home_screen.dart';

class ModuleMenuScreen extends StatelessWidget {
  const ModuleMenuScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context) {
    if (isExpanded(context)) return const HomeScreen();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: 'Volver',
                  onTap: () => context.pop()),
              const SizedBox(height: 24),
              Expanded(child: ModuleMenuBody(moduleId: moduleId, expanded: false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Entry {
  const _Entry(this.title, this.subtitle, this.color, this.path, {this.glyph, this.icon});
  final String title, subtitle, path;
  final Color color;
  final String? glyph;
  final IconData? icon;
}

class ModuleMenuBody extends ConsumerWidget {
  const ModuleMenuBody({super.key, required this.moduleId, required this.expanded});
  final String moduleId;
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final module = ref
        .watch(modulesProvider)
        .valueOrNull
        ?.where((m) => m.id == moduleId)
        .firstOrNull;
    if (module == null) return const SizedBox();
    final entries = [
      _Entry('Flashcards', 'Reconoce cada carácter', Pt.flamingo,
          '/m/$moduleId/flashcards', glyph: 'あ'),
      _Entry('Práctica', 'Dibuja con el dedo', Pt.pink, '/m/$moduleId/practice',
          icon: Icons.edit_rounded),
      _Entry('Vocabulario', 'Partes del cuerpo', Pt.teal,
          '/m/$moduleId/vocabulary', glyph: 'め'),
    ];
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ひらがな',
                style: TextStyle(
                    color: Pt.flamingo,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2)),
            Text(module.name,
                style: TextStyle(
                    fontSize: expanded ? 44 : 36, fontWeight: FontWeight.w700)),
          ],
        ),
        Text(module.glyph,
            style: TextStyle(
                fontFamily: Pt.kana,
                fontWeight: FontWeight.w700,
                fontSize: expanded ? 120 : 84,
                height: 0.9,
                color: Pt.flamingo)),
      ],
    );
    final tiles = [for (final e in entries) _EntryTile(e, expanded: expanded)];
    if (expanded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(40, 32, 40, 40),
        child: Column(
          children: [
            header,
            const SizedBox(height: 28),
            for (final t in tiles) ...[Expanded(child: t), const SizedBox(height: 18)],
          ]..removeLast(),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        const SizedBox(height: 32),
        for (final t in tiles) ...[t, const SizedBox(height: 14)],
      ],
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile(this.e, {required this.expanded});
  final _Entry e;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final box = expanded ? 84.0 : 64.0;
    return Material(
      color: Pt.surface0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(expanded ? 32 : 28),
        side: const BorderSide(color: Pt.surface1),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(expanded ? 32 : 28)),
        onTap: () => context.push(e.path),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: expanded ? 28 : 22, vertical: 22),
          child: Row(
            children: [
              Container(
                width: box,
                height: box,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: e.color,
                    borderRadius: BorderRadius.circular(expanded ? 26 : 20)),
                child: e.glyph != null
                    ? Text(e.glyph!,
                        style: TextStyle(
                            fontFamily: Pt.kana,
                            fontWeight: FontWeight.w700,
                            fontSize: box * 0.52,
                            color: Pt.crust))
                    : Icon(e.icon, color: Pt.crust, size: box * 0.5),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.title,
                        style: TextStyle(
                            fontSize: expanded ? 26 : 21, fontWeight: FontWeight.w700)),
                    Text(e.subtitle,
                        style: TextStyle(
                            fontSize: expanded ? 16 : 14, color: Pt.subtext)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Pt.subtext),
            ],
          ),
        ),
      ),
    );
  }
}
