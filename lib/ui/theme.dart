import 'package:flutter/material.dart';

class AppTheme {
  static const Color iceBlue = Color(0xFF7DD3FC);
  static const Color iceDark = Color(0xFF0F172A);
  static const Color iceText = Color(0xFF334155);
  static const Color background = Color(0xFFF0F9FF);
  
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    primaryColor: iceBlue,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.light(
      primary: iceBlue,
      secondary: iceDark,
      background: background,
    ),
  );
}
