import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'practice_session.dart';
import 'stroke_board.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = practiceSessionProvider(moduleId);
    final session = ref.watch(provider);
    return Scaffold(
      body: SafeArea(
        child: session.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (s) {
            final n = ref.read(provider.notifier);
            final expanded = isExpanded(context);
            final speak = s.item.audioText ?? s.item.japanese;

            final top = Row(
              children: [
                RoundIconButton(
                    icon: Icons.close_rounded,
                    label: 'Cerrar',
                    size: expanded ? 48 : 44,
                    onTap: () => context.pop()),
                const Expanded(
                  child: Text('PRÁCTICA · TRAZO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Pt.subtext,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.4)),
                ),
                SizedBox(width: expanded ? 48 : 44),
              ],
            );
            final romaji = Column(
              children: [
                const Text('Dibuja el hiragana de',
                    style: TextStyle(fontSize: 15, color: Pt.subtext)),
                Text(s.item.reading,
                    style: TextStyle(
                        fontSize: expanded ? 96 : 84,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                        color: Pt.flamingo)),
              ],
            );
            final board = StrokeBoard(
              strokes: s.strokes,
              onStart: s.checked ? null : n.startStroke,
              onMove: s.checked ? null : n.addPoint,
            );
            Widget correctCard(double height, double fontSize) => Container(
                  height: height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Pt.greenTint,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Pt.green, width: 2),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(s.item.japanese,
                        style: TextStyle(
                            fontFamily: Pt.kana,
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize,
                            height: 1,
                            color: Pt.green)),
                  ),
                );
            final draw = Row(
              children: [
                Expanded(
                    child: PillButton('Borrar',
                        onTap: n.clear,
                        bg: Pt.surface0,
                        fg: Pt.text,
                        border: Pt.surface1)),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: PillButton('Check', onTap: n.check)),
              ],
            );
            final grade = Column(
              children: [
                if (s.score != null) _ScoreBadge(s.score!),
                const Text('¿Cómo te fue?',
                    style: TextStyle(fontSize: 15, color: Pt.subtext)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: PillButton('Repasar',
                            onTap: () => n.grade(false),
                            bg: Pt.redTint,
                            fg: Pt.red,
                            border: Pt.red)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: PillButton('Lo logré',
                            onTap: () => n.grade(true), bg: Pt.green)),
                  ],
                ),
              ],
            );

            if (expanded) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(40, 24, 40, 40),
                child: Column(
                  children: [
                    top,
                    const SizedBox(height: 28),
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                romaji,
                                if (s.checked) ...[
                                  const SizedBox(height: 20),
                                  const SectionLabel('CORRECTO', color: Pt.green),
                                  const SizedBox(height: 8),
                                  correctCard(230, 150),
                                ],
                                const Spacer(),
                                s.checked ? grade : draw,
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(child: board),
                                if (s.checked)
                                  Positioned(
                                      right: 22,
                                      bottom: 22,
                                      child: SpeakerButton(text: speak, size: 60)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            if (!s.checked) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: Column(
                  children: [
                    top,
                    const SizedBox(height: 22),
                    romaji,
                    const SizedBox(height: 22),
                    Expanded(child: board),
                    const SizedBox(height: 22),
                    draw,
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                children: [
                  top,
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionLabel('TU TRAZO'),
                            const SizedBox(height: 8),
                            SizedBox(
                                height: 200,
                                child: StrokeBoard(strokes: s.strokes)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionLabel('CORRECTO', color: Pt.green),
                            const SizedBox(height: 8),
                            correctCard(200, 120),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SurfaceCard(
                    radius: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.item.reading,
                                  style: const TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.w700)),
                              const Text('Compara el orden y la forma de los trazos',
                                  style: TextStyle(fontSize: 14, color: Pt.subtext)),
                            ],
                          ),
                        ),
                        SpeakerButton(text: speak),
                      ],
                    ),
                  ),
                  const Spacer(),
                  grade,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge(this.score);
  final double score;

  @override
  Widget build(BuildContext context) {
    final (label, color) = score >= 0.72
        ? ('Muy bien', Pt.green)
        : score >= 0.5
            ? ('Casi, revisa la forma', Pt.yellow)
            : ('Repasa los trazos', Pt.red);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text('${(score * 100).round()}% de parecido · $label',
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }
}
