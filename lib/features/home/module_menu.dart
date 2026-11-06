import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../../core/audio/sound_service.dart';
import 'continue_button.dart';
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
              const SizedBox(height: 16),
              Expanded(child: ModuleMenuBody(moduleId: moduleId, expanded: false)),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuEntry {
  const MenuEntry(this.title, this.subtitle, this.kanji, this.path);
  final String title, subtitle, kanji, path;
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
    final l = context.l10n;
    final (eyebrow, _, _) = scriptLabel(moduleId);
    final entries = [
      MenuEntry(l.menuReference, l.menuReferenceSub, '表', '/m/$moduleId/reference'),
      MenuEntry(l.menuLearn, l.menuLearnSub, '筆', '/m/$moduleId/learn'),
      MenuEntry(l.menuPractice, l.menuPracticeSub, '練', '/m/$moduleId/practice'),
      MenuEntry(l.menuFlashcards, l.menuFlashcardsSub, '札', '/m/$moduleId/flashcards'),
      MenuEntry(l.menuVocabulary, l.menuVocabularySub, '語', '/m/$moduleId/vocabulary'),
      MenuEntry(l.menuGames, l.menuGamesSub, '遊', '/m/$moduleId/games'),
    ];
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow,
                  style: TextStyle(
                      color: context.pt.flamingo,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5)),
              const SizedBox(height: 4),
              Text(module.name, style: context.pt.display(expanded ? 46 : 38)),
            ],
          ),
        ),
        Text(module.glyph,
            style: context.pt.display(expanded ? 110 : 80, color: context.pt.flamingo)
                .copyWith(height: 0.9)),
      ],
    );
    if (expanded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(40, 36, 40, 32),
        child: Column(
          children: [
            header,
            const SizedBox(height: 22),
            ContinueButton(moduleId: moduleId),
            const SizedBox(height: 22),
            Expanded(child: SingleChildScrollView(child: FunctionGrid(entries))),
          ],
        ),
      );
    }
    return ListView(
      children: [
        header,
        const SizedBox(height: 24),
        for (final e in entries) ...[MenuEntryTile(e), const SizedBox(height: 12)],
      ],
    );
  }
}

/// Cuadricula 2 x 3 de funciones con su kanji (Fold abierto).
class FunctionGrid extends ConsumerWidget {
  const FunctionGrid(this.entries, {super.key});
  final List<MenuEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.pt;
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final e in entries)
          Semantics(
            button: true,
            label: '${e.title}. ${e.subtitle}',
            child: Material(
              color: c.surface0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(c.shape.large),
                side: BorderSide(color: c.outline, width: c.shape.border),
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(c.shape.large)),
                onTap: () {
                  ref.read(soundProvider).play(SoundCue.tap);
                  context.push(e.path);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.kanji, style: c.display(44, color: c.flamingo)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          Text(e.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: c.subtext)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MenuEntryTile extends ConsumerWidget {
  const MenuEntryTile(this.e, {super.key});
  final MenuEntry e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.pt;
    return Material(
      color: c.surface0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(c.shape.large),
        side: BorderSide(color: c.outline, width: c.shape.border),
      ),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(c.shape.large)),
        onTap: () {
          ref.read(soundProvider).play(SoundCue.tap);
          context.push(e.path);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 88),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  child: Center(child: Text(e.kanji, style: c.display(38, color: c.flamingo))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      Text(e.subtitle, style: TextStyle(fontSize: 14, color: c.subtext)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: c.subtext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
