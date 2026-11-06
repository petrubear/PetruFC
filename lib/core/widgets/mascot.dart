import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../data/app_settings.dart';

enum MascotPose { celebrando, animando, pensando, tranquilo, doctor, kimono, ninja, rockero }

/// La mascota en la pose pedida: el siames hace las poses deportivas y el gato negro
/// las de disfraz. Con los festejos apagados se muestra quieta.
class Mascot extends ConsumerWidget {
  const Mascot(this.pose, {super.key, this.height = 120});
  final MascotPose pose;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).valueOrNull;
    if (s != null && !s.mascotOn) return const SizedBox.shrink();
    final cat = pose.index < MascotPose.doctor.index ? 'siames' : 'negro';
    final dir = (s?.effects ?? true) ? 'assets/mascot/anim' : 'assets/mascot';
    return SizedBox(
      height: height,
      child: Image.asset(
        '$dir/${cat}_${pose.name}.webp',
        key: ValueKey('$dir/${cat}_${pose.name}'),
        height: height,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
        // No se muestra nada hasta que el primer cuadro esta listo, y entra con un fundido.
        frameBuilder: (context, child, frame, sync) => AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 180),
          child: child,
        ),
      ),
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
          color: context.pt.surface0,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.pt.surface1),
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

/// Decodifica las mascotas al abrir la app para que aparezcan sin retraso.
class MascotPrecache extends StatefulWidget {
  const MascotPrecache({super.key});

  @override
  State<MascotPrecache> createState() => _MascotPrecacheState();
}

class _MascotPrecacheState extends State<MascotPrecache> {
  bool _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_done) return;
    _done = true;
    for (final pose in MascotPose.values) {
      final cat = pose.index < MascotPose.doctor.index ? 'siames' : 'negro';
      precacheImage(AssetImage('assets/mascot/anim/${cat}_${pose.name}.webp'), context);
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
