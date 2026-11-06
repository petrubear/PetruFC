import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../data/database.dart';
import '../l10n/language.dart';

/// Estado de dominio de un caracter o palabra segun su racha de aciertos.
enum Mastery {
  unseen,
  weak,
  learning,
  mastered;

  String label(AppLocalizations l) => switch (this) {
        unseen => l.masteryUnseen,
        weak => l.masteryWeak,
        learning => l.masteryLearning,
        mastered => l.masteryMastered,
      };

  Color bgOf(PtStyle c) => switch (this) {
        unseen => c.surface0,
        weak => c.redTint,
        learning => c.yellowTint,
        mastered => c.greenTint,
      };

  Color borderOf(PtStyle c) => switch (this) {
        unseen => c.surface1,
        weak => c.red,
        learning => c.yellow,
        mastered => c.green,
      };

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
                    color: m.bgOf(context.pt),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: m.borderOf(context.pt)),
                  ),
                ),
                const SizedBox(width: 6),
                Text(m.label(context.l10n), style: TextStyle(fontSize: 12, color: context.pt.subtext)),
              ],
            ),
        ],
      );
}
