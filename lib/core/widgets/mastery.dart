import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../data/database.dart';

/// Estado de dominio de un caracter o palabra segun su racha de aciertos.
enum Mastery {
  unseen(Pt.surface0, Pt.surface1, 'Sin ver'),
  weak(Pt.redTint, Pt.red, 'Fallado'),
  learning(Color(0x24FCD583), Pt.yellow, 'Aprendiendo'),
  mastered(Pt.greenTint, Pt.green, 'Dominado');

  const Mastery(this.bg, this.border, this.label);
  final Color bg, border;
  final String label;

  static Mastery of(ReviewStat? s) {
    if (s == null || s.attempts == 0) return unseen;
    if (s.streak >= 5) return mastered;
    return s.streak >= 1 ? learning : weak;
  }
}

class MasteryLegend extends StatelessWidget {
  const MasteryLegend({super.key});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 14,
        runSpacing: 6,
        children: [
          for (final m in Mastery.values)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: m.bg,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: m.border),
                  ),
                ),
                const SizedBox(width: 6),
                Text(m.label, style: const TextStyle(fontSize: 12, color: Pt.subtext)),
              ],
            ),
        ],
      );
}
