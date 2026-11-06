import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../data/app_settings.dart';
import '../widgets/mascot.dart';
import '../l10n/language.dart';

enum Buzz { soft, light, medium, heavy }

void buzz(bool enabled, Buzz kind) {
  if (!enabled) return;
  switch (kind) {
    case Buzz.soft:
      HapticFeedback.selectionClick();
    case Buzz.light:
      HapticFeedback.lightImpact();
    case Buzz.medium:
      HapticFeedback.mediumImpact();
    case Buzz.heavy:
      HapticFeedback.heavyImpact();
  }
}

/// Caracteres que acaban de pasar a verde (la pantalla de estudio muestra un aviso).
final masteredProvider = StateProvider<List<String>>((ref) => []);

/// Cada vez que se alcanza la meta diaria se incrementa (la app muestra el festejo).
final goalReachedProvider = StateProvider<int>((ref) => 0);

class _Piece {
  _Piece(Random r, List<Color> palette)
      : angle = -pi / 2 + (r.nextDouble() - 0.5) * pi * 1.1,
        speed = 0.55 + r.nextDouble() * 0.75,
        spin = (r.nextDouble() - 0.5) * 14,
        size = 6 + r.nextDouble() * 7,
        color = palette[r.nextInt(palette.length)];
  final double angle, speed, spin, size;
  final Color color;
}

/// Explosion de confeti ligera. Se reproduce una vez al aparecer.
class ConfettiBurst extends ConsumerStatefulWidget {
  const ConfettiBurst({super.key, this.big = false});
  final bool big;

  @override
  ConsumerState<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends ConsumerState<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.big ? 2600 : 1700),
  )..forward();
  late final List<_Piece> _pieces = () {
    final r = Random();
    final c = Theme.of(context).extension<PtColors>() ?? PtColors.dark;
    return List.generate(widget.big ? 90 : 42, (_) => _Piece(r, [c.flamingo, c.pink, c.teal, c.yellow, c.green]));
  }();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(ref.watch(settingsProvider).valueOrNull?.effects ?? true)) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(_pieces, _c.value),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.t);
  final List<_Piece> pieces;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height * 0.4);
    for (final p in pieces) {
      final d = p.speed * t * size.shortestSide * 0.9;
      final pos = origin +
          Offset(cos(p.angle) * d, sin(p.angle) * d + 0.5 * 1.6 * t * t * size.height);
      final paint = Paint()
        ..color = p.color.withValues(alpha: (1 - t * t).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.spin * t);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.55),
            const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}

/// Festejo global al cumplir la meta diaria (se muestra sobre cualquier pantalla).
class GoalCelebrationOverlay extends ConsumerStatefulWidget {
  const GoalCelebrationOverlay({super.key});

  @override
  ConsumerState<GoalCelebrationOverlay> createState() => _GoalCelebrationState();
}

class _GoalCelebrationState extends ConsumerState<GoalCelebrationOverlay> {
  int _shown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _show() {
    buzz(ref.read(settingsProvider).valueOrNull?.haptics ?? true, Buzz.heavy);
    setState(() => _shown++);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), _hide);
  }

  void _hide() {
    if (mounted) setState(() => _shown = 0);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(goalReachedProvider, (prev, next) {
      if (next != prev) _show();
    });
    if (_shown == 0) return const SizedBox.shrink();
    return Stack(children: [
      Positioned.fill(child: ConfettiBurst(key: ValueKey(_shown), big: true)),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: _hide,
              child: Material(
                color: context.pt.surface1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: context.pt.green, width: 2),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Mascot(MascotPose.rockero, height: 64),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.goalCelebrationTitle,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: context.pt.text)),
                            Text(context.l10n.goalCelebrationBody,
                                style: TextStyle(fontSize: 13, color: context.pt.subtext)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
