import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../home/module_menu.dart';
import '../../core/l10n/group_names.dart';
import '../../core/l10n/language.dart';

/// Lista de secciones de vocabulario (un grupo `word` por seccion).
class VocabSectionsScreen extends ConsumerWidget {
  const VocabSectionsScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider((moduleId, 'word'))).valueOrNull ?? [];
    final wordGlyph = scriptLabel(moduleId).$3;
    return _MenuPage(
      title: context.l10n.vocabularyTitle,
      glyph: wordGlyph,
      entries: [
        for (final g in groups)
          MenuEntry(groupName(context.l10n, g), groupSubtitle(context.l10n, g), '語', '/m/$moduleId/vocabulary/${g.id}'),
      ],
    );
  }
}

/// Menu de una seccion: Referencia o Practica.
class VocabSectionMenuScreen extends ConsumerWidget {
  const VocabSectionMenuScreen({super.key, required this.moduleId, required this.groupId});
  final String moduleId, groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider((moduleId, 'word'))).valueOrNull ?? [];
    final group = groups.where((g) => g.id == groupId).firstOrNull;
    final name = group == null ? '' : groupName(context.l10n, group);
    final base = '/m/$moduleId/vocabulary/$groupId';
    final (_, kanaGlyph, wordGlyph) = scriptLabel(moduleId);
    return _MenuPage(
      title: name,
      glyph: wordGlyph,
      entries: [
        MenuEntry(context.l10n.menuReference, context.l10n.vocabMenuReferenceSub, '表', '$base/reference'),
        MenuEntry(context.l10n.menuPractice, context.l10n.vocabMenuPracticeSub, '練', '$base/practice'),
        MenuEntry(context.l10n.wordSearchName, context.l10n.wordSearchSub, '探', '$base/wordsearch'),
      ],
    );
  }
}

class _MenuPage extends StatelessWidget {
  const _MenuPage({required this.title, required this.glyph, required this.entries});
  final String title, glyph;
  final List<MenuEntry> entries;

  @override
  Widget build(BuildContext context) {
    final expanded = isExpanded(context);
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('たんご',
                  style: TextStyle(
                      color: context.pt.teal,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2)),
              Text(title,
                  style: TextStyle(
                      fontSize: expanded ? 44 : 36, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Text(glyph,
            style: TextStyle(
                fontFamily: Pt.kana,
                fontWeight: FontWeight.w700,
                fontSize: expanded ? 120 : 84,
                height: 0.9,
                color: context.pt.teal)),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: expanded
              ? const EdgeInsets.fromLTRB(40, 24, 40, 40)
              : const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: context.l10n.back,
                  size: expanded ? 48 : 44,
                  onTap: () => context.pop()),
              SizedBox(height: expanded ? 28 : 24),
              header,
              SizedBox(height: expanded ? 28 : 32),
              Expanded(
                child: ListView(
                  children: [
                    for (final e in entries) ...[
                      MenuEntryTile(e),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
