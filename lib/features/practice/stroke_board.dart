import 'package:flutter/material.dart';

import '../../app/theme.dart';

class StrokeBoard extends StatelessWidget {
  const StrokeBoard({super.key, required this.strokes, this.onStart, this.onMove});
  final List<List<Offset>> strokes;
  final ValueChanged<Offset>? onStart, onMove;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: LayoutBuilder(builder: (context, c) {
          Offset norm(Offset p) => Offset(
                (p.dx / c.maxWidth).clamp(0.0, 1.0).toDouble(),
                (p.dy / c.maxHeight).clamp(0.0, 1.0).toDouble(),
              );
          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: onStart == null ? null : (e) => onStart!(norm(e.localPosition)),
            onPointerMove: onMove == null ? null : (e) => onMove!(norm(e.localPosition)),
            child: CustomPaint(painter: _StrokePainter(strokes), size: Size.infinite),
          );
        }),
      );
}

class _StrokePainter extends CustomPainter {
  _StrokePainter(this.strokes);
  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Pt.paper);
    final guide = Paint()
      ..color = Pt.paperLine
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(size.width / 2, size.height * 0.06),
        Offset(size.width / 2, size.height * 0.94), guide);
    canvas.drawLine(Offset(size.width * 0.07, size.height / 2),
        Offset(size.width * 0.93, size.height / 2), guide);

    final width = (size.shortestSide * 0.03).clamp(3.0, 14.0).toDouble();
    final ink = Paint()
      ..color = Pt.ink
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = width;
    Offset at(Offset p) => Offset(p.dx * size.width, p.dy * size.height);
    for (final s in strokes) {
      if (s.length == 1) {
        canvas.drawCircle(at(s.first), width / 2, Paint()..color = Pt.ink);
        continue;
      }
      final path = Path()..moveTo(at(s.first).dx, at(s.first).dy);
      for (final p in s.skip(1)) {
        path.lineTo(at(p).dx, at(p).dy);
      }
      canvas.drawPath(path, ink);
    }
  }

  @override
  bool shouldRepaint(_StrokePainter old) => old.strokes != strokes;
}
