import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Aro de progreso de tinta: pista tenue y arco shu con punta redonda.
class InkRing extends StatelessWidget {
  const InkRing({
    super.key,
    required this.value,
    this.size = 96,
    this.stroke = 10,
    this.color,
    this.child,
  });
  final double value;
  final double size, stroke;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: Stack(alignment: Alignment.center, children: [
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              value.clamp(0, 1).toDouble(),
              stroke,
              context.pt.surface1,
              color ?? context.pt.flamingo,
            ),
          ),
          if (child != null) child!,
        ]),
      );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.v, this.w, this.track, this.arc);
  final double v, w;
  final Color track, arc;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Rect.fromLTWH(w / 2, w / 2, size.width - w, size.height - w);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(r, 0, math.pi * 2, false, p..color = track);
    if (v > 0) canvas.drawArc(r, -math.pi / 2, math.pi * 2 * v, false, p..color = arc);
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.v != v || o.track != track || o.arc != arc || o.w != w;
}
