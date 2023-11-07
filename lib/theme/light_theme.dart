import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFFFB6E3B),
  secondaryHeaderColor: const Color(0xFF03041D),
  disabledColor: const Color(0xFFBEBEC7),
  brightness: Brightness.light,
  hintColor: const Color(0xFF8F8F9A),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(
      0xFFFB6E3B))),
  colorScheme: const ColorScheme.light(primary: Color(0xFFFB6E3B),
      tertiary: Color(0xff6165D7),
      tertiaryContainer: Color(0xff171DB6),
      secondary: Color(0xFFFF8200)).copyWith(background: const Color(0xFFF3F3F3)).copyWith(error: const Color(0xFFE84D4F)),

);