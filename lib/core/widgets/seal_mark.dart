import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Sello rojo con un kanji, ligeramente girado.
class SealMark extends StatelessWidget {
  const SealMark({super.key, this.kanji = '学', this.size = 40});
  final String kanji;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Transform.rotate(
          angle: -4 * math.pi / 180,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.pt.flamingo,
              borderRadius: BorderRadius.circular(size * 0.16),
            ),
            child: Text(kanji,
                style: context.pt.display(size * 0.55, color: context.pt.crust, weight: FontWeight.w700)),
          ),
        ),
      );
}
