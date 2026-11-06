import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';

/// Trazos de un kana (datos de KanjiVG, CC BY-SA 3.0), en un cuadro de 109 x 109.
class KanaGlyph {
  const KanaGlyph(this.paths, this.numbers);
  final List<Path> paths;
  final List<Offset> numbers;
}

const kvgSize = 109.0;

/// Trazos de los caracteres de un modulo (kana o kanji), por caracter.
final strokesProvider = FutureProvider.family<Map<String, KanaGlyph>, String>((ref, moduleId) async {
  final asset = moduleId == 'kanji' ? 'assets/kanji/strokes.json' : 'assets/kana/strokes.json';
  final raw = jsonDecode(await rootBundle.loadString(asset)) as Map<String, dynamic>;
  return {
    for (final e in raw.entries)
      e.key: KanaGlyph(
        [for (final d in (e.value['p'] as List)) _parsePath(d as String)],
        [
          for (final n in (e.value['n'] as List))
            Offset((n[0] as num).toDouble(), (n[1] as num).toDouble()),
        ],
      ),
  };
});

final kanaStrokesProvider = strokesProvider('hiragana');

// Los datos usan solo M (absoluto) y c (curva cubica relativa).
Path _parsePath(String d) {
  final path = Path();
  var x = 0.0, y = 0.0;
  for (final m in RegExp(r'([Mc])([^Mc]*)').allMatches(d)) {
    final n = [
      for (final v in RegExp(r'-?\d*\.?\d+').allMatches(m.group(2)!)) double.parse(v.group(0)!),
    ];
    if (m.group(1) == 'M') {
      x = n[0];
      y = n[1];
      path.moveTo(x, y);
    } else {
      for (var i = 0; i + 5 < n.length; i += 6) {
        path.cubicTo(x + n[i], y + n[i + 1], x + n[i + 2], y + n[i + 3], x + n[i + 4], y + n[i + 5]);
        x += n[i + 4];
        y += n[i + 5];
      }
    }
  }
  return path;
}

/// Dibuja la guia: trazos grises numerados y, mientras dura la animacion,
/// los trazos que ya se dibujaron en color. Los combinados (kya) usan dos cuadros.
class GuidePainter extends CustomPainter {
  GuidePainter(this.glyphs, this.colors, {this.showGuide = true, this.progress, this.weight = 3.8});
  final double weight;
  final PtStyle colors;
  final List<KanaGlyph> glyphs;
  final bool showGuide;

  /// Trazos completados (con decimales) durante la animacion; null si no hay.
  final double? progress;

  @override
  void paint(Canvas canvas, Size size) {
    final two = glyphs.length > 1;
    final side = two ? size.width * 0.52 : size.shortestSide * 0.86;
    final scale = side / kvgSize;
    final startX = two ? (size.width - side * 1.9) / 2 : (size.width - side) / 2;
    final y0 = (size.height - side) / 2;

    final base = Paint()
      ..color = colors.guide
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = weight * scale;
    final hot = Paint()
      ..color = colors.flamingo
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = weight * scale;

    var k = 0; // numero de trazo global
    for (var g = 0; g < glyphs.length; g++) {
      final glyph = glyphs[g];
      canvas.save();
      canvas.translate(startX + g * side * 0.9, y0);
      canvas.scale(scale);
      for (var i = 0; i < glyph.paths.length; i++, k++) {
        if (showGuide) {
          canvas.drawPath(glyph.paths[i], base);
        }
        final p = progress;
        if (p != null && p > k) {
          final frac = (p - k).clamp(0.0, 1.0).toDouble();
          for (final metric in glyph.paths[i].computeMetrics()) {
            canvas.drawPath(metric.extractPath(0, metric.length * frac), hot);
          }
        }
      }
      if (showGuide) {
        for (var i = 0; i < glyph.numbers.length; i++) {
          final tp = TextPainter(
            text: TextSpan(
              text: '${k - glyph.numbers.length + i + 1}',
              style: TextStyle(
                color: colors.guideNumber,
                fontSize: 7,
                fontWeight: FontWeight.w700,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, glyph.numbers[i] - Offset(tp.width / 2, tp.height / 2));
        }
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(GuidePainter old) => true;
}
