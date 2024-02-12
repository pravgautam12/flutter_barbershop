// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

//theme method that returns themedata object
ThemeData theme() {
  return ThemeData(
    fontFamily: 'Futura',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme(
      primary: Color(0xFFFE3C5B),
      secondary: Color(0xFFBBBBBB),
      background: Color(0xFFF5F5F5),
      brightness: Brightness.light,
      surface: Color(0xFF54B435),
      error: Color(0xFFF32424),
      onSurface: Color(0xFF54B435),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onError: Color(0xFFF32424),
      onBackground: Colors.white,
    ), 
    textTheme: TextTheme(
      displayMedium: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
      displaySmall: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.normal,
        fontSize: 18,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        color: Color(0xFF2b2e4a),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
    ),
  );
}