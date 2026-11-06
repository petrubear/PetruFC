import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/audio/sound_service.dart';
import '../../core/data/app_settings.dart';
import '../../core/data/providers.dart';
import '../../core/l10n/language.dart';
import 'module_menu.dart';

/// Boton principal del inicio: retoma el ultimo estudio (o empieza uno).
class ContinueButton extends ConsumerWidget {
  const ContinueButton({super.key, this.moduleId = 'hiragana'});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final last = ref.watch(settingsProvider).valueOrNull?.lastRoute ?? '';
    final modules = ref.watch(modulesProvider).valueOrNull ?? [];
    final m = RegExp(r'^/m/([^/]+)/([^/?]+)').firstMatch(last);
    final modId = m?.group(1) ?? moduleId;
    final module = modules.where((x) => x.id == modId).firstOrNull;
    final l = context.l10n;
    final fn = switch (m?.group(2)) {
      'learn' => l.menuLearn,
      'practice' => l.menuPractice,
      'play' => l.menuFlashcards,
      'games' => l.menuGames,
      'vocabulary' => l.menuVocabulary,
      _ => null,
    };
    final route = last.isEmpty ? '/m/$moduleId/learn' : last;
    final sub = last.isEmpty || module == null || fn == null
        ? l.continueStart
        : '${module.name} · $fn';
    final glyph = module?.glyph ?? scriptLabel(moduleId).$2;
    final c = context.pt;
    return Material(
      color: c.flamingo,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {
          ref.read(soundProvider).play(SoundCue.tap);
          context.push(route);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 84),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(children: [
              Text(glyph, style: c.display(34, color: c.crust)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.continueTitle,
                        style: TextStyle(color: c.crust, fontSize: 19, fontWeight: FontWeight.w700)),
                    Text(sub, style: TextStyle(color: c.crust.withValues(alpha: .9), fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: c.crust, size: 26),
            ]),
          ),
        ),
      ),
    );
  }
}
