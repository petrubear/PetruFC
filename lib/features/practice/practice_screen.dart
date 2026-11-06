import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/activity/activity_tracker.dart';
import '../../core/feedback/feedback.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'practice_session.dart';
import 'stroke_board.dart';
import '../../core/l10n/language.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = practiceSessionProvider(moduleId);
    final session = ref.watch(provider);
    ref.listen(masteredProvider, (prev, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(context.l10n.masteredToast(next.join(' '))),
            duration: const Duration(seconds: 2)));
      }
    });
    return ActivityScope(
      child: Scaffold(
        body: Stack(children: [
          SafeArea(
          child: session.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (s) {
              final n = ref.read(provider.notifier);
              if (s.summary) {
                return SessionSummary(
                  correct: s.hits,
                  total: s.graded,
                  bestCombo: s.bestCombo,
                  onAgain: n.restart,
                  onExit: () => context.pop(),
                );
              }
              final expanded = isExpanded(context);
              final speak = s.item.audioText ?? s.item.japanese;

              final top = Column(
                children: [
                  Row(
                    children: [
                      RoundIconButton(
                        icon: Icons.close_rounded,
                        label: context.l10n.close,
                        size: expanded ? 48 : 44,
                        onTap: () => context.pop(),
                      ),
                      Expanded(
                        child: Text(
                          context.l10n.practiceTag,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.pt.subtext,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(width: expanded ? 48 : 44),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SessionProgress(done: s.graded, size: s.size),
                ],
              );
              final isKanji = moduleId == 'kanji';
              final romaji = Column(
                children: [
                  Text(
                    isKanji
                        ? context.l10n.practiceDrawKanji
                        : context.l10n.practiceDrawPrompt(moduleId == 'katakana' ? 'katakana' : 'hiragana'),
                    style: TextStyle(fontSize: 15, color: context.pt.subtext),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isKanji ? (s.item.meaning(context.lang) ?? s.item.reading) : s.item.reading,
                      style: TextStyle(
                        fontSize: expanded ? 96 : 84,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                        color: context.pt.flamingo,
                      ),
                    ),
                  ),
                  if (isKanji)
                    Text(s.item.audioText ?? '',
                        style: TextStyle(fontSize: 20, color: context.pt.subtext)),
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
                  color: context.pt.greenTint,
                  borderRadius: BorderRadius.circular(context.pt.shape.large),
                  border: Border.all(color: context.pt.green, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    s.item.japanese,
                    style: TextStyle(
                      fontFamily: Pt.kana,
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize,
                      height: 1,
                      color: context.pt.green,
                    ),
                  ),
                ),
              );
              final draw = Row(
                children: [
                  Expanded(
                    child: PillButton(
                      context.l10n.erase,
                      onTap: n.clear,
                      bg: context.pt.surface0,
                      fg: context.pt.text,
                      border: context.pt.surface1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: PillButton(context.l10n.practiceCheck, onTap: n.check)),
                ],
              );
              final grade = Column(
                children: [
                  if (s.score != null) _ScoreBadge(s.score!),
                  Text(context.l10n.practiceHowDidYouDo, style: TextStyle(fontSize: 15, color: context.pt.subtext)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: PillButton(
                          context.l10n.practiceReview,
                          onTap: () => n.grade(false),
                          bg: context.pt.redTint,
                          fg: context.pt.red,
                          border: context.pt.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PillButton(context.l10n.practiceGotIt, onTap: () => n.grade(true), bg: context.pt.green),
                      ),
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
                                    SectionLabel(context.l10n.practiceCorrect, color: context.pt.green),
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
                                      child: SpeakerButton(text: speak, size: 60),
                                    ),
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
                padding: EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: Column(
                  children: [
                    top,
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionLabel(context.l10n.practiceYourStroke),
                              const SizedBox(height: 8),
                              SizedBox(height: 200, child: StrokeBoard(strokes: s.strokes)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionLabel(context.l10n.practiceCorrect, color: context.pt.green),
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
                                Text(
                                  s.item.reading,
                                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  context.l10n.practiceCompare,
                                  style: TextStyle(fontSize: 14, color: context.pt.subtext),
                                ),
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
          if ((session.valueOrNull?.celebrations ?? 0) > 0)
            Positioned.fill(
                child: ConfettiBurst(key: ValueKey(session.valueOrNull!.celebrations))),
        ]),
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
        ? (context.l10n.verdictGreat, context.pt.green)
        : score >= 0.5
            ? (context.l10n.verdictClose, context.pt.yellow)
            : (context.l10n.verdictReview, context.pt.red);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(context.pt.shape.pill),
        border: Border.all(color: color),
      ),
      child: Text(context.l10n.similarity((score * 100).round(), label),
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }
}
