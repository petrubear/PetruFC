import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'home_screen.dart';
import '../../core/l10n/language.dart';

/// Rotulo japones, kana de ejemplo y glifo de vocabulario de cada modulo kana.
const _scriptLabels = {
  'hiragana': ('ひらがな', 'あ', 'め'),
  'katakana': ('カタカナ', 'ア', 'メ'),
};

(String, String, String) scriptLabel(String moduleId) =>
    _scriptLabels[moduleId] ?? _scriptLabels['hiragana']!;

class ModuleMenuScreen extends ConsumerWidget {
  const ModuleMenuScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isExpanded(context)) {
      // Al desplegar el Fold, el panel derecho debe mostrar este modulo.
      if (ref.read(selectedModuleProvider) != moduleId) {
        Future.microtask(
            () => ref.read(selectedModuleProvider.notifier).state = moduleId);
      }
      return const HomeScreen();
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: context.l10n.back,
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

class MenuEntry {
  const MenuEntry(this.title, this.subtitle, this.color, this.path, {this.glyph, this.icon});
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
    final (eyebrow, kanaGlyph, wordGlyph) = scriptLabel(moduleId);
    final entries = [
      MenuEntry(context.l10n.menuReference, context.l10n.menuReferenceSub, context.pt.yellow,
          '/m/$moduleId/reference', icon: Icons.grid_view_rounded),
      MenuEntry(context.l10n.menuLearn, context.l10n.menuLearnSub, context.pt.red, '/m/$moduleId/learn',
          icon: Icons.gesture_rounded),
      MenuEntry(context.l10n.menuPractice, context.l10n.menuPracticeSub, context.pt.pink, '/m/$moduleId/practice',
          icon: Icons.edit_rounded),
      MenuEntry(context.l10n.menuFlashcards, context.l10n.menuFlashcardsSub, context.pt.flamingo,
          '/m/$moduleId/flashcards', glyph: kanaGlyph),
      MenuEntry(context.l10n.menuVocabulary, context.l10n.menuVocabularySub, context.pt.teal,
          '/m/$moduleId/vocabulary', glyph: wordGlyph),
      MenuEntry(context.l10n.menuGames, context.l10n.menuGamesSub, context.pt.green,
          '/m/$moduleId/games', icon: Icons.sports_esports_rounded),
    ];
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eyebrow,
                style: TextStyle(
                    color: context.pt.flamingo,
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
                color: context.pt.flamingo)),
      ],
    );
    List<Widget> tilesFor(double? boxSize) =>
        [for (final e in entries) MenuEntryTile(e, expanded: expanded, boxSize: boxSize)];
    final tiles = tilesFor(null);
    if (expanded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(40, 32, 40, 40),
        child: Column(
          children: [
            header,
            const SizedBox(height: 28),
            // Los mosaicos se reparten el alto, pero nunca menos de lo que necesitan.
            Expanded(
              child: LayoutBuilder(builder: (context, c) {
                const gap = 18.0;
                final each = (c.maxHeight - gap * (tiles.length - 1)) / tiles.length;
                final h = each < 104.0 ? 104.0 : each;
                final boxed = tilesFor(null);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final t in boxed) ...[SizedBox(height: h, child: t), const SizedBox(height: gap)],
                    ]..removeLast(),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    }
    return ListView(
      children: [
        header,
        const SizedBox(height: 32),
        for (final t in tiles) ...[t, const SizedBox(height: 14)],
      ],
    );
  }
}

class MenuEntryTile extends StatelessWidget {
  const MenuEntryTile(this.e, {super.key, required this.expanded, this.boxSize});
  final MenuEntry e;
  final bool expanded;
  final double? boxSize;

  @override
  Widget build(BuildContext context) {
    final box = boxSize ?? (expanded ? 72.0 : 64.0);
    return Material(
      color: context.pt.surface0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(expanded ? 32 : 28),
        side: BorderSide(color: context.pt.surface1),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(expanded ? 32 : 28)),
        onTap: () => context.push(e.path),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: expanded ? 28 : 22, vertical: expanded ? 12 : 22),
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
                            color: context.pt.crust))
                    : Icon(e.icon, color: context.pt.crust, size: box * 0.5),
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
                            fontSize: expanded ? 16 : 14, color: context.pt.subtext)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: context.pt.subtext),
            ],
          ),
        ),
      ),
    );
  }
}
