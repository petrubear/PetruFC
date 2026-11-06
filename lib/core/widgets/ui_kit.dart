import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../audio/tts_service.dart';
import '../data/app_settings.dart';
import '../feedback/feedback.dart';
import 'mascot.dart';
import '../l10n/language.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 44,
    this.bg,
    this.fg,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;
  final Color? bg, fg;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: label,
        child: Material(
          color: bg ?? context.pt.surface0,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, color: fg ?? context.pt.text, size: size * 0.5),
            ),
          ),
        ),
      );
}

class PillButton extends StatelessWidget {
  const PillButton(
    this.label, {
    super.key,
    required this.onTap,
    this.bg,
    this.fg,
    this.border,
  });
  final String label;
  final VoidCallback? onTap;
  final Color? bg, fg, border;

  @override
  Widget build(BuildContext context) => Material(
        color: bg ?? context.pt.flamingo,
        shape: StadiumBorder(
            side: border == null ? BorderSide.none : BorderSide(color: border!)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(label,
                  style: TextStyle(
                      color: fg ?? context.pt.crust, fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      );
}

class ScoreChips extends StatelessWidget {
  const ScoreChips({super.key, required this.correct, required this.wrong});
  final int correct, wrong;

  Widget _chip(String text, Color fg, Color bg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
        child: Text(text,
            style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.w700)),
      );

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _chip('✓ $correct', context.pt.green, context.pt.greenTint),
          const SizedBox(width: 8),
          _chip('✗ $wrong', context.pt.red, context.pt.redTint),
        ],
      );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          color: color ?? context.pt.subtext,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.4));
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.radius = 36,
    this.color,
    this.borderColor,
    this.borderWidth = 1,
    this.padding,
  });
  final Widget child;
  final double radius, borderWidth;
  final Color? color, borderColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? context.pt.surface0,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor ?? context.pt.surface1, width: borderWidth),
        ),
        child: child,
      );
}

class SpeakerButton extends ConsumerWidget {
  const SpeakerButton({super.key, required this.text, this.size = 52});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) => RoundIconButton(
        icon: Icons.volume_up_rounded,
        label: context.l10n.listenPronunciation,
        size: size,
        bg: context.pt.flamingo,
        fg: context.pt.crust,
        onTap: () async {
          final error = await ref.read(ttsProvider).speak(text);
          if (error != null && context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.message(context.l10n))));
          }
        },
      );
}

class SessionProgress extends StatelessWidget {
  const SessionProgress({super.key, required this.done, required this.size});
  final int done, size;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (done / size).clamp(0, 1).toDouble(),
            minHeight: 8,
            backgroundColor: context.pt.surface1,
            color: context.pt.flamingo,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(
        '$done / $size',
        style: TextStyle(color: context.pt.subtext, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    ],
  );
}

class SessionSummary extends ConsumerStatefulWidget {
  const SessionSummary({
    super.key,
    required this.correct,
    required this.total,
    required this.bestCombo,
    required this.onAgain,
    required this.onExit,
  });
  final int correct, total, bestCombo;
  final VoidCallback onAgain, onExit;

  @override
  ConsumerState<SessionSummary> createState() => _SessionSummaryState();
}

class _SessionSummaryState extends ConsumerState<SessionSummary> {
  @override
  void initState() {
    super.initState();
    buzz(ref.read(settingsProvider).valueOrNull?.haptics ?? true, Buzz.heavy);
  }

  @override
  Widget build(BuildContext context) {
    final correct = widget.correct, total = widget.total, bestCombo = widget.bestCombo;
    final onAgain = widget.onAgain, onExit = widget.onExit;
    final pct = total == 0 ? 0 : (correct * 100 / total).round();
    Widget stat(String label, String value) => Expanded(
      child: SurfaceCard(
        radius: 24,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            Text(label, style: TextStyle(fontSize: 13, color: context.pt.subtext)),
          ],
        ),
      ),
    );
    return Stack(children: [
      Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Mascot(
                pct >= 80
                    ? MascotPose.celebrando
                    : pct >= 50
                        ? MascotPose.animando
                        : MascotPose.tranquilo,
                height: 150,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.summaryTitle,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Text(
                '$correct / $total',
                style: TextStyle(fontSize: 72, fontWeight: FontWeight.w700, color: context.pt.green),
              ),
              Text(context.l10n.summaryCorrectLabel, style: TextStyle(fontSize: 16, color: context.pt.subtext)),
              const SizedBox(height: 24),
              Row(
                children: [
                  stat(context.l10n.summaryBestCombo, '$bestCombo'),
                  const SizedBox(width: 12),
                  stat(context.l10n.summaryAccuracy, '$pct%'),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: PillButton(context.l10n.summaryAgain, onTap: onAgain),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: PillButton(
                  context.l10n.summaryExit,
                  onTap: onExit,
                  bg: context.pt.surface0,
                  fg: context.pt.text,
                  border: context.pt.surface1,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
      const Positioned.fill(child: ConfettiBurst(big: true)),
    ]);
  }
}
