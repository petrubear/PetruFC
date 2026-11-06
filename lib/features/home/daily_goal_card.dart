import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/activity/activity_tracker.dart';
import '../../core/data/app_settings.dart';
import '../../core/data/repository.dart';
import '../../core/widgets/ink_ring.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/ui_kit.dart';
import '../../core/l10n/language.dart';

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
    final l = context.l10n;
    final greeting = now.hour < 11
        ? l.greetMorning
        : now.hour < 17
            ? l.greetDay
            : l.greetEvening;
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              InkRing(
                value: todaySec / goalSec,
                size: 88,
                color: done ? context.pt.green : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${todaySec ~/ 60}', style: context.pt.display(26)),
                    Text(l.minOfGoal(goalMin),
                        style: TextStyle(fontSize: 10, color: context.pt.subtext)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(greeting, style: context.pt.display(24)),
                    const SizedBox(height: 4),
                    Text(
                      done ? l.goalReached : l.goalMinutesLeft(left),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: done ? context.pt.green : context.pt.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 6; i >= 0; i--)
                Expanded(
                  child: _DayBar(
                    label: MaterialLocalizations.of(context)
                        .narrowWeekdays[now.subtract(Duration(days: i)).weekday % 7],
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
  Widget build(BuildContext context) {
    final c = context.pt;
    final full = ratio >= 1;
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: full ? c.green : (ratio > 0 ? c.flamingo.withValues(alpha: .18) : Colors.transparent),
            border: Border.all(
                color: full ? c.green : (today ? c.outline : c.surface2), width: c.shape.border),
          ),
          child: full
              ? Icon(Icons.check_rounded, size: 18, color: c.crust)
              : ratio > 0
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: c.flamingo, shape: BoxShape.circle))
                  : null,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: today ? FontWeight.w700 : FontWeight.w500,
            color: today ? c.text : c.subtext,
          ),
        ),
      ],
    );
  }
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
        ? (MascotPose.celebrando, context.l10n.mascotGoalDone)
        : min == 0
            ? (MascotPose.kimono, context.l10n.mascotHello)
            : (MascotPose.animando, context.l10n.mascotKeepGoing(goalMin - min));
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
