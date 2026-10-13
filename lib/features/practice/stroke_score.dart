import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

// Compara el trazo del usuario con el glifo de la fuente. Ambos se llevan a una
// rejilla de _n x _n, estirando su caja al mismo tamano (asi no importan la
// posicion, la escala ni la proporcion del lienzo). El puntaje es la media
// armonica de dos fracciones:
//  - precision: trazo del usuario que cae sobre/cerca del glifo
//  - cobertura: glifo que queda cerca de algun trazo del usuario
const _n = 64;
const _box = 56;
const _tolUser = 4.0;
const _tolRef = 7.0;
final _refCache = <String, Uint8List>{};

Future<double> scoreStrokes(List<List<Offset>> strokes, String glyph) async {
  final user = _userMask(strokes);
  if (user == null) return 0;
  final ref = await _refMask(glyph);
  final dRef = _distance(ref);
  final dUser = _distance(user);
  var uCount = 0, uHit = 0, rCount = 0, rHit = 0;
  for (var i = 0; i < _n * _n; i++) {
    if (user[i] == 1) {
      uCount++;
      if (dRef[i] <= _tolUser) uHit++;
    }
    if (ref[i] == 1) {
      rCount++;
      if (dUser[i] <= _tolRef) rHit++;
    }
  }
  if (uCount == 0 || rCount == 0) return 0;
  final p = uHit / uCount, r = rHit / rCount;
  return p + r == 0 ? 0 : 2 * p * r / (p + r);
}

Uint8List? _userMask(List<List<Offset>> strokes) {
  final pts = strokes.expand((s) => s).toList();
  if (pts.isEmpty) return null;
  var minX = pts.first.dx, maxX = minX, minY = pts.first.dy, maxY = minY;
  for (final p in pts) {
    minX = min(minX, p.dx);
    maxX = max(maxX, p.dx);
    minY = min(minY, p.dy);
    maxY = max(maxY, p.dy);
  }
  if (maxX - minX < 0.06 && maxY - minY < 0.06) return null; // solo puntos
  final w = max(maxX - minX, 0.05), h = max(maxY - minY, 0.05);
  const off = (_n - _box) / 2;
  Offset g(Offset p) => Offset(
        off + (p.dx - minX) / w * (_box - 1),
        off + (p.dy - minY) / h * (_box - 1),
      );
  final mask = Uint8List(_n * _n);
  void stamp(Offset p) {
    for (var dy = -1; dy <= 1; dy++) {
      for (var dx = -1; dx <= 1; dx++) {
        final x = p.dx.round() + dx, y = p.dy.round() + dy;
        if (x >= 0 && y >= 0 && x < _n && y < _n) mask[y * _n + x] = 1;
      }
    }
  }

  for (final s in strokes) {
    for (var i = 0; i < s.length; i++) {
      final a = g(s[i]);
      stamp(a);
      if (i == 0) continue;
      final b = g(s[i - 1]);
      final steps = ((a - b).distance * 2).ceil();
      for (var k = 1; k < steps; k++) {
        stamp(Offset.lerp(b, a, k / steps)!);
      }
    }
  }
  return mask;
}

Future<Uint8List> _refMask(String glyph) async {
  final cached = _refCache[glyph];
  if (cached != null) return cached;
  final tp = TextPainter(
    text: TextSpan(
      text: glyph,
      style: const TextStyle(
          fontFamily: Pt.kana,
          fontWeight: FontWeight.w500,
          fontSize: 200,
          color: Colors.black),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final w = tp.width.ceil() + 40, h = tp.height.ceil() + 40;
  final rec = ui.PictureRecorder();
  tp.paint(Canvas(rec), const Offset(20, 20));
  final img = await rec.endRecording().toImage(w, h);
  final data = (await img.toByteData(format: ui.ImageByteFormat.rawRgba))!;
  bool ink(int x, int y) => data.getUint8((y * w + x) * 4 + 3) > 127;

  var minX = w, maxX = 0, minY = h, maxY = 0;
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (ink(x, y)) {
        minX = min(minX, x);
        maxX = max(maxX, x);
        minY = min(minY, y);
        maxY = max(maxY, y);
      }
    }
  }
  final bw = (maxX - minX + 1) / _box, bh = (maxY - minY + 1) / _box;
  const off = (_n - _box) ~/ 2;
  final mask = Uint8List(_n * _n);
  for (var ty = 0; ty < _box; ty++) {
    for (var tx = 0; tx < _box; tx++) {
      final x0 = minX + (tx * bw).floor(), x1 = minX + ((tx + 1) * bw).ceil();
      final y0 = minY + (ty * bh).floor(), y1 = minY + ((ty + 1) * bh).ceil();
      var hit = false;
      for (var y = y0; y < y1 && !hit; y++) {
        for (var x = x0; x < x1; x++) {
          if (x < w && y < h && ink(x, y)) {
            hit = true;
            break;
          }
        }
      }
      if (hit) mask[(ty + off) * _n + (tx + off)] = 1;
    }
  }
  return _refCache[glyph] = mask;
}

// Distancia (chamfer) de cada celda a la celda con tinta mas cercana.
Float32List _distance(Uint8List m) {
  const inf = 1e9;
  final d = Float32List(_n * _n);
  for (var i = 0; i < d.length; i++) {
    d[i] = m[i] == 1 ? 0 : inf;
  }
  double at(int x, int y) =>
      (x < 0 || y < 0 || x >= _n || y >= _n) ? inf : d[y * _n + x];
  for (var y = 0; y < _n; y++) {
    for (var x = 0; x < _n; x++) {
      var v = d[y * _n + x];
      v = min(v, at(x - 1, y) + 1);
      v = min(v, at(x, y - 1) + 1);
      v = min(v, at(x - 1, y - 1) + 1.414);
      v = min(v, at(x + 1, y - 1) + 1.414);
      d[y * _n + x] = v;
    }
  }
  for (var y = _n - 1; y >= 0; y--) {
    for (var x = _n - 1; x >= 0; x--) {
      var v = d[y * _n + x];
      v = min(v, at(x + 1, y) + 1);
      v = min(v, at(x, y + 1) + 1);
      v = min(v, at(x + 1, y + 1) + 1.414);
      v = min(v, at(x - 1, y + 1) + 1.414);
      d[y * _n + x] = v;
    }
  }
  return d;
}
