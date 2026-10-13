import 'package:flutter/material.dart';

class Pt {
  static const base = Color(0xFF13171B);
  static const mantle = Color(0xFF0C0E11);
  static const crust = Color(0xFF060809);
  static const surface0 = Color(0xFF1F262D);
  static const surface1 = Color(0xFF2C363F);
  static const surface2 = Color(0xFF3B4754);
  static const text = Color(0xFFEEF0F2);
  static const subtext = Color(0xFFA4ADB7);
  static const flamingo = Color(0xFFFC8783);
  static const pink = Color(0xFFFC83DC);
  static const teal = Color(0xFF83FCE8);
  static const green = Color(0xFF8DFC83);
  static const red = Color(0xFFFC83A5);
  static const greenTint = Color(0x248DFC83);
  static const redTint = Color(0x24FC83A5);
  static const paper = Color(0xFFF7F7F8);
  static const ink = Color(0xFF1D1D20);
  static const paperLine = Color(0xFFD1D0DD);
  static const ui = 'ZenMaruGothic';
  static const kana = 'ShipporiMincho';
}

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: Pt.ui,
      scaffoldBackgroundColor: Pt.base,
      colorScheme: const ColorScheme.dark(
        primary: Pt.flamingo,
        onPrimary: Pt.crust,
        surface: Pt.base,
        onSurface: Pt.text,
        error: Pt.red,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Pt.surface1,
        contentTextStyle: TextStyle(color: Pt.text, fontFamily: Pt.ui),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? Pt.base : Pt.subtext),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? Pt.flamingo : Pt.surface2),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    );
