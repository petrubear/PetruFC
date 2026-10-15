import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../home/module_menu.dart';

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
      MenuEntry('Memorama', 'Encuentra los pares', Pt.teal, '$base/memory',
          icon: Icons.extension_rounded),
      MenuEntry('Arma la palabra', 'Ordena los caracteres', Pt.flamingo, '$base/build',
          icon: Icons.abc_rounded),
      MenuEntry('Sopa de letras', 'Encuentra las palabras', Pt.pink, '$base/wordsearch',
          icon: Icons.search_rounded),
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
                      label: 'Volver',
                      size: expanded ? 48 : 44,
                      onTap: () => context.pop()),
                  SizedBox(height: expanded ? 28 : 24),
                  const Text('ゲーム',
                      style: TextStyle(
                          color: Pt.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2)),
                  Text('Juegos${module == null ? '' : ' · ${module.name}'}',
                      style: TextStyle(
                          fontSize: expanded ? 44 : 34, fontWeight: FontWeight.w700)),
                  SizedBox(height: expanded ? 28 : 28),
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
        ),
      ),
    );
  }
}
