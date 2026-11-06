import 'package:flutter/widgets.dart';

/// Detecta la ultima pantalla de estudio abierta para retomarla desde el inicio.
class StudyObserver extends NavigatorObserver {
  static void Function(String uri)? onVisit;
  static String Function()? currentUri;

  static final _study = RegExp(
      r'^/m/[^/]+/(learn|practice|play/[^/?]+|games/[^/]+/play|vocabulary/[^/]+/(practice|wordsearch))(\?.*)?$');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Future.delayed(const Duration(milliseconds: 250), () {
      final uri = currentUri?.call();
      if (uri != null && _study.hasMatch(uri)) onVisit?.call(uri);
    });
  }
}
