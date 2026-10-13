import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../home/module_menu.dart';

/// Lista de secciones de vocabulario (un grupo `word` por seccion).
class VocabSectionsScreen extends ConsumerWidget {
  const VocabSectionsScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider((moduleId, 'word'))).valueOrNull ?? [];
    return _MenuPage(
      title: 'Vocabulario',
      entries: [
        for (final g in groups)
          MenuEntry(g.name, g.subtitle, Pt.teal, '/m/$moduleId/vocabulary/${g.id}',
              glyph: 'め'),
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
    final name = groups.where((g) => g.id == groupId).firstOrNull?.name ?? '';
    final base = '/m/$moduleId/vocabulary/$groupId';
    return _MenuPage(
      title: name,
      entries: [
        MenuEntry('Referencia', 'Palabras y significados', Pt.yellow, '$base/reference',
            icon: Icons.grid_view_rounded),
        MenuEntry('Práctica', 'Elige la respuesta correcta', Pt.flamingo, '$base/practice',
            glyph: 'あ'),
      ],
    );
  }
}

class _MenuPage extends StatelessWidget {
  const _MenuPage({required this.title, required this.entries});
  final String title;
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
              const Text('たんご',
                  style: TextStyle(
                      color: Pt.teal,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2)),
              Text(title,
                  style: TextStyle(
                      fontSize: expanded ? 44 : 36, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Text('め',
            style: TextStyle(
                fontFamily: Pt.kana,
                fontWeight: FontWeight.w700,
                fontSize: expanded ? 120 : 84,
                height: 0.9,
                color: Pt.teal)),
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
                  label: 'Volver',
                  size: expanded ? 48 : 44,
                  onTap: () => context.pop()),
              SizedBox(height: expanded ? 28 : 24),
              header,
              SizedBox(height: expanded ? 28 : 32),
              Expanded(
                child: ListView(
                  children: [
                    for (final e in entries) ...[
                      MenuEntryTile(e, expanded: expanded),
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
