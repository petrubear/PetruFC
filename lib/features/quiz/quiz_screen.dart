import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'quiz_engine.dart';
import 'quiz_session.dart';

enum _Opt { idle, good, bad, dim }

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key, required this.moduleId, required this.mode, this.groupId});
  final String moduleId;
  final QuizMode mode;
  final String? groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multi = mode.kind == 'kana' && ref.read(multiSelectProvider);
    final args = (moduleId, mode, groupId, multi);
    final session = ref.watch(quizSessionProvider(args));
    return Scaffold(
      body: SafeArea(
        child: session.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (s) {
            final notifier = ref.read(quizSessionProvider(args).notifier);
            final expanded = isExpanded(context);
            final q = s.question;
            final asList = mode == QuizMode.wordToMeaning;
            final base = switch (mode) {
              QuizMode.kanaToRomaji => 150.0,
              QuizMode.romajiToKana => 110.0,
              QuizMode.wordToMeaning => 96.0,
              QuizMode.meaningToWord => 60.0,
            };
            _Opt stateOf(String o) => !s.answered
                ? _Opt.idle
                : o == q.correct
                    ? _Opt.good
                    : o == s.selected
                        ? _Opt.bad
                        : _Opt.dim;

            final prompt = _PromptCard(
              text: q.prompt,
              japanese: mode.promptIsJapanese,
              size: (expanded ? base * 1.7 : base) * (multi ? 0.42 : 1),
              speakText: mode.promptIsJapanese
                  ? q.items.map((i) => i.audioText ?? i.japanese).join(multi ? '、' : '')
                  : null,
            );
            final tiles = [
              for (final o in q.options)
                _OptionTile(
                  label: o,
                  state: stateOf(o),
                  japanese: mode.answersAreJapanese,
                  list: asList && !expanded,
                  fontSize: multi ? (expanded ? 26 : 17) : (expanded ? 34 : (asList ? 21 : 28)),
                  onTap: () => notifier.answer(o),
                ),
            ];
            final top = Row(
              children: [
                RoundIconButton(
                    icon: Icons.close_rounded,
                    label: 'Cerrar',
                    size: expanded ? 48 : 44,
                    onTap: () => context.pop()),
                Expanded(
                  child: Text(mode.label(moduleId).toUpperCase(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Pt.subtext,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2)),
                ),
                ScoreChips(correct: s.correct, wrong: s.wrong),
              ],
            );
            final next = Opacity(
              opacity: s.answered ? 1 : 0,
              child: IgnorePointer(
                ignoring: !s.answered,
                child: PillButton('Siguiente', onTap: notifier.next),
              ),
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
                          Expanded(child: prompt),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Column(
                              children: [
                                for (final t in tiles) ...[
                                  Expanded(child: t),
                                  const SizedBox(height: 14),
                                ],
                                next,
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
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                children: [
                  top,
                  const SizedBox(height: 24),
                  Expanded(child: prompt),
                  const SizedBox(height: 24),
                  asList
                      ? Column(children: [
                          for (final t in tiles) ...[
                            SizedBox(width: double.infinity, child: t),
                            const SizedBox(height: 12),
                          ],
                        ])
                      : _grid(tiles),
                  const SizedBox(height: 12),
                  next,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _grid(List<Widget> t) => Column(
        children: [
          for (var i = 0; i < t.length; i += 2)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 14),
              child: Row(
                children: [
                  Expanded(child: t[i]),
                  const SizedBox(width: 14),
                  Expanded(child: i + 1 < t.length ? t[i + 1] : const SizedBox()),
                ],
              ),
            ),
        ],
      );
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.text,
    required this.japanese,
    required this.size,
    required this.speakText,
  });
  final String text;
  final bool japanese;
  final double size;
  final String? speakText;

  @override
  Widget build(BuildContext context) => SurfaceCard(
        radius: 36,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: japanese ? Pt.kana : Pt.ui,
                          fontSize: size,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: japanese ? Pt.text : Pt.flamingo)),
                ),
              ),
            ),
            if (speakText != null)
              Positioned(right: 18, bottom: 18, child: SpeakerButton(text: speakText!)),
          ],
        ),
      );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.state,
    required this.japanese,
    required this.list,
    required this.fontSize,
    required this.onTap,
  });
  final String label;
  final _Opt state;
  final bool japanese, list;
  final double fontSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg) = switch (state) {
      _Opt.good => (Pt.greenTint, Pt.green, Pt.green),
      _Opt.bad => (Pt.redTint, Pt.red, Pt.red),
      _ => (Pt.surface0, Pt.surface1, Pt.text),
    };
    final mark = state == _Opt.good ? '✓ ' : (state == _Opt.bad ? '✗ ' : '');
    final highlighted = state == _Opt.good || state == _Opt.bad;
    return Opacity(
      opacity: state == _Opt.dim ? 0.45 : 1,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: border, width: highlighted ? 2 : 1),
        ),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          onTap: state == _Opt.idle ? onTap : null,
          child: Container(
            alignment: list ? Alignment.centerLeft : Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
            child: Text('$mark$label',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: japanese ? Pt.kana : Pt.ui,
                    fontSize: fontSize,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    color: fg)),
          ),
        ),
      ),
    );
  }
}
