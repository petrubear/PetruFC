import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../audio/tts_service.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 44,
    this.bg = Pt.surface0,
    this.fg = Pt.text,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;
  final Color bg, fg;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: label,
        child: Material(
          color: bg,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, color: fg, size: size * 0.5),
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
    this.bg = Pt.flamingo,
    this.fg = Pt.crust,
    this.border,
  });
  final String label;
  final VoidCallback? onTap;
  final Color bg, fg;
  final Color? border;

  @override
  Widget build(BuildContext context) => Material(
        color: bg,
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
                      color: fg, fontSize: 18, fontWeight: FontWeight.w700)),
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
          _chip('✓ $correct', Pt.green, Pt.greenTint),
          const SizedBox(width: 8),
          _chip('✗ $wrong', Pt.red, Pt.redTint),
        ],
      );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color = Pt.subtext});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.4));
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.radius = 36,
    this.color = Pt.surface0,
    this.borderColor = Pt.surface1,
    this.borderWidth = 1,
    this.padding,
  });
  final Widget child;
  final double radius, borderWidth;
  final Color color, borderColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: borderWidth),
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
        label: 'Escuchar pronunciación',
        size: size,
        bg: Pt.flamingo,
        fg: Pt.crust,
        onTap: () async {
          final error = await ref.read(ttsProvider).speak(text);
          if (error != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
          }
        },
      );
}
