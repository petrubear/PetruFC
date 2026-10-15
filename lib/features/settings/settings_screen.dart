import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/app_settings.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = isExpanded(context);
    final settings = ref.watch(settingsProvider).valueOrNull ?? const AppSettings();
    final n = ref.read(settingsProvider.notifier);
    Widget size(int v) => Expanded(
      child: PillButton(
        '$v tarjetas',
        onTap: () => n.setSessionSize(v),
        bg: settings.sessionSize == v ? Pt.flamingo : Pt.surface0,
        fg: settings.sessionSize == v ? Pt.crust : Pt.text,
        border: settings.sessionSize == v ? null : Pt.surface1,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: EdgeInsets.fromLTRB(expanded ? 40 : 24, 12, expanded ? 40 : 24, 32),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: RoundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    label: 'Volver',
                    size: expanded ? 48 : 44,
                    onTap: () => context.pop(),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Configuración',
                  style: TextStyle(fontSize: expanded ? 38 : 32, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                const SectionLabel('META DIARIA'),
                const SizedBox(height: 12),
                SurfaceCard(
                  radius: 28,
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${settings.goalMinutes} minutos al día',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const Text(
                        'El anillo de Inicio se llena con tu tiempo de práctica.',
                        style: TextStyle(fontSize: 13, color: Pt.subtext),
                      ),
                      Slider(
                        value: settings.goalMinutes.toDouble(),
                        min: 5,
                        max: 60,
                        divisions: 11,
                        label: '${settings.goalMinutes} min',
                        onChanged: (v) => n.setGoalMinutes(v.round()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionLabel('TAMAÑO DE LA RONDA'),
                const SizedBox(height: 12),
                Row(children: [size(15), const SizedBox(width: 12), size(20)]),
                const SizedBox(height: 8),
                const Text(
                  'Cuántas tarjetas tiene cada ronda de Flashcards y Práctica.',
                  style: TextStyle(fontSize: 13, color: Pt.subtext),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                const SectionLabel('SENSACIONES'),
                const SizedBox(height: 12),
                SurfaceCard(
                  radius: 28,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Vibración'),
                        subtitle: const Text('Al acertar, en combos y al dominar'),
                        value: settings.haptics,
                        onChanged: n.setHaptics,
                      ),
                      SwitchListTile(
                        title: const Text('Festejos y animaciones'),
                        subtitle: const Text('Confeti al completar rondas y metas'),
                        value: settings.effects,
                        onChanged: n.setEffects,
                      ),
                      SwitchListTile(
                        title: const Text('Mostrar mascota'),
                        subtitle: const Text('El gato que te acompaña y festeja'),
                        value: settings.mascotOn,
                        onChanged: n.setMascotOn,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
