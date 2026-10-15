import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../data/app_settings.dart';

enum MascotPose { celebrando, animando, pensando, tranquilo, doctor, kimono, ninja, rockero }

/// La mascota en la pose pedida. El gato (siames o negro) se sortea cada vez que aparece.
class Mascot extends ConsumerStatefulWidget {
  const Mascot(this.pose, {super.key, this.height = 120});
  final MascotPose pose;
  final double height;

  @override
  ConsumerState<Mascot> createState() => _MascotState();
}

class _MascotState extends ConsumerState<Mascot> {
  final _cat = Random().nextBool() ? 'siames' : 'negro';

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider).valueOrNull;
    if (s != null && !s.mascotOn) return const SizedBox.shrink();
    return Image.asset(
      'assets/mascot/${_cat}_${widget.pose.name}.webp',
      height: widget.height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}

class SpeechBubble extends StatelessWidget {
  const SpeechBubble(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Pt.surface0,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Pt.surface1),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.3)),
      );
}

/// Mascota con un globo de texto que aparece un momento y se desvanece.
class MascotPopup extends StatefulWidget {
  const MascotPopup({super.key, required this.text, required this.pose});
  final String text;
  final MascotPose pose;

  @override
  State<MascotPopup> createState() => _MascotPopupState();
}

class _MascotPopupState extends State<MascotPopup> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SpeechBubble(widget.text),
              const SizedBox(width: 6),
              Mascot(widget.pose, height: 96),
            ],
          ),
        ),
      );
}
