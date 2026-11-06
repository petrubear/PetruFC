import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../home/module_menu.dart';
import '../../core/l10n/language.dart';

class GamesMenuScreen extends ConsumerWidget {
  const GamesMenuScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = isExpanded(context);
    final module = ref
        .watch(modulesProvider)
        .valueOrNull
        ?.where((m) => m.id == moduleId)
        .firstOrNull;
    final base = '/m/$moduleId/games';
    final entries = [
      MenuEntry(context.l10n.memoryName, context.l10n.memorySub, '記', '$base/memory'),
      MenuEntry(context.l10n.buildName, context.l10n.buildSub, '組', '$base/build'),
      if (moduleId != 'kanji')
        MenuEntry(context.l10n.wordSearchName, context.l10n.wordSearchSub, '探', '$base/wordsearch'),
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
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
                  Text('ゲーム',
                      style: TextStyle(
                          color: context.pt.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2)),
                  Text(module == null ? context.l10n.gamesTitle : context.l10n.gamesTitleModule(module.name),
                      style: TextStyle(
                          fontSize: expanded ? 44 : 34, fontWeight: FontWeight.w700)),
                  SizedBox(height: expanded ? 28 : 28),
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
        ),
      ),
    );
  }
}
