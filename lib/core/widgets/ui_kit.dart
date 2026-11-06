import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../audio/sound_service.dart';
import '../audio/tts_service.dart';
import '../data/app_settings.dart';
import '../feedback/feedback.dart';
import 'mascot.dart';
import '../l10n/language.dart';

class RoundIconButton extends ConsumerWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 48,
    this.bg,
    this.fg,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;
  final Color? bg, fg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = size < context.pt.shape.minTap ? context.pt.shape.minTap : size;
    return Tooltip(
      message: label,
      child: Material(
        color: bg ?? Colors.transparent,
        shape: CircleBorder(
            side: bg == null
                ? BorderSide(color: context.pt.outline, width: context.pt.shape.border)
                : BorderSide.none),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            ref.read(soundProvider).play(SoundCue.tap);
            onTap();
          },
          child: SizedBox(
            width: d,
            height: d,
            child: Icon(icon, color: fg ?? context.pt.text, size: d * 0.45),
          ),
        ),
      ),
    );
  }
}

class PillButton extends ConsumerWidget {
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
  final Color? bg, fg;
  final Color? border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = bg == null;
    return Material(
      color: bg ?? context.pt.flamingo,
      shape: StadiumBorder(
          side: border == null
              ? BorderSide.none
              : BorderSide(color: context.pt.outline, width: context.pt.shape.border)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap == null
            ? null
            : () {
                ref.read(soundProvider).play(SoundCue.tap);
                onTap!();
              },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: primary ? context.pt.shape.primaryTap : context.pt.shape.minTap),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label,
                    maxLines: 1,
                    style: TextStyle(
                        color: fg ?? context.pt.crust, fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreChips extends StatelessWidget {
  const ScoreChips({super.key, required this.correct, required this.wrong});
  final int correct, wrong;

  Widget _chip(BuildContext context, String text, Color fg, Color bg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration:
            BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(context.pt.shape.pill),
            border: Border.all(color: fg.withValues(alpha: .6))),
        child: Text(text,
            style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.w700)),
      );

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _chip(context, '✓ $correct', context.pt.green, context.pt.greenTint),
          const SizedBox(width: 8),
          _chip(context, '✗ $wrong', context.pt.red, context.pt.redTint),
        ],
      );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: context.pt.label.copyWith(color: color ?? context.pt.subtext));
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.radius,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.hero = false,
  });
  final Widget child;
  final double? radius, borderWidth;
  final Color? color, borderColor;
  final EdgeInsetsGeometry? padding;

  /// Tarjeta destacada con sombra plana de tinta.
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final sh = context.pt.shape;
    final r = BorderRadius.circular(radius ?? sh.large);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? context.pt.surface0,
        borderRadius: r,
        border: Border.all(color: borderColor ?? context.pt.outline, width: borderWidth ?? sh.border),
        boxShadow: hero
            ? [BoxShadow(color: context.pt.shadow, offset: const Offset(0, 8), blurRadius: 0, spreadRadius: -2)]
            : null,
      ),
      child: child,
    );
  }
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
          borderRadius: BorderRadius.circular(context.pt.shape.pill),
          child: LinearProgressIndicator(
            value: (done / size).clamp(0, 1).toDouble(),
            minHeight: 10,
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
        radius: context.pt.shape.medium,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(value, style: context.pt.display(28)),
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
                style: context.pt.display(32),
              ),
              const SizedBox(height: 16),
              Text(
                '$correct / $total',
                style: context.pt.display(72, color: context.pt.green),
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
                  border: context.pt.outline,
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
