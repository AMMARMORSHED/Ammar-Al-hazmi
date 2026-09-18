import 'package:flutter/material.dart';
class AppTheme {
  static ThemeData light = _theme(Brightness.light);
  static ThemeData dark = _theme(Brightness.dark);
  static ThemeData _theme(Brightness b) { final color = ColorScheme.fromSeed(seedColor: const Color(0xff176b87), brightness: b); return ThemeData(useMaterial3: true, colorScheme: color, brightness: b, cardTheme: const CardTheme(margin: EdgeInsets.symmetric(vertical: 6), elevation: 0), inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), filled: true), visualDensity: VisualDensity.adaptivePlatformDensity); }
}
