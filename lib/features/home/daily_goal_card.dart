import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/activity/activity_tracker.dart';
import '../../core/data/app_settings.dart';
import '../../core/data/repository.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/ui_kit.dart';

const _weekdays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

class DailyGoalCard extends ConsumerWidget {
  const DailyGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalMin = ref.watch(settingsProvider).valueOrNull?.goalMinutes ?? 20;
    final days = ref.watch(recentActivityProvider).valueOrNull ?? {};
    final now = DateTime.now();
    final goalSec = goalMin * 60;
    final todaySec = days[dayKey(now)] ?? 0;
    final done = todaySec >= goalSec;
    final left = ((goalSec - todaySec) / 60).ceil();
    return SurfaceCard(
      radius: 28,
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: CustomPaint(
                  painter: _RingPainter(todaySec / goalSec, done),
                  child: Center(
                    child: Text(
                      '${todaySec ~/ 60}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('META DE HOY'),
                    const SizedBox(height: 4),
                    Text(
                      done ? '¡Meta cumplida!' : 'Te faltan $left min',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: done ? Pt.green : Pt.text,
                      ),
                    ),
                    Text(
                      'de $goalMin min de práctica',
                      style: const TextStyle(fontSize: 13, color: Pt.subtext),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (var i = 6; i >= 0; i--)
                Expanded(
                  child: _DayBar(
                    label: _weekdays[now.subtract(Duration(days: i)).weekday - 1],
                    ratio: min(1.0, (days[dayKey(now.subtract(Duration(days: i)))] ?? 0) / goalSec),
                    today: i == 0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({required this.label, required this.ratio, required this.today});
  final String label;
  final double ratio;
  final bool today;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 14,
        height: 36,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(color: Pt.surface1, borderRadius: BorderRadius.circular(999)),
        child: FractionallySizedBox(
          heightFactor: ratio == 0 ? 0.08 : max(0.08, ratio),
          child: Container(
            decoration: BoxDecoration(
              color: ratio >= 1
                  ? Pt.green
                  : ratio == 0
                  ? Pt.surface2
                  : Pt.flamingo,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: today ? FontWeight.w700 : FontWeight.w500,
          color: today ? Pt.text : Pt.subtext,
        ),
      ),
    ],
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.ratio, this.done);
  final double ratio;
  final bool done;

  @override
  void paint(Canvas canvas, Size size) {
    const w = 9.0;
    final rect = Offset.zero & size;
    final r = rect.deflate(w / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..color = Pt.surface1;
    canvas.drawArc(r, 0, 2 * pi, false, base);
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..color = done ? Pt.green : Pt.flamingo;
    canvas.drawArc(r, -pi / 2, 2 * pi * ratio.clamp(0.0, 1.0), false, fill);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.ratio != ratio || old.done != done;
}

/// Mascota con un globo que cambia segun el avance del dia.
class MascotGreeting extends ConsumerWidget {
  const MascotGreeting({super.key, this.height = 104});
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final activity = ref.watch(recentActivityProvider).valueOrNull;
    // Hasta tener los datos no se muestra nada, para no cambiar de pose de golpe.
    if (settings == null || activity == null) return SizedBox(height: height);
    final goalMin = settings.goalMinutes;
    final min = (activity[dayKey(DateTime.now())] ?? 0) ~/ 60;
    final (pose, text) = min >= goalMin
        ? (MascotPose.celebrando, '¡Meta cumplida! Hoy lo diste todo')
        : min == 0
            ? (MascotPose.kimono, '¡Hola! Empecemos con unos minutos de japonés')
            : (MascotPose.animando, 'Vas muy bien, te faltan ${goalMin - min} min');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Mascot(pose, height: height),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(padding: const EdgeInsets.only(bottom: 14), child: SpeechBubble(text)),
        ),
      ],
    );
  }
}
