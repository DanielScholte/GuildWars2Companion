import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.red,
  primaryColor: Color(0xFFAA0404),
  accentColor: Color(0xFFEEEEEE),
  cardColor: Color(0xFF262626),
  scaffoldBackgroundColor: Color(0xFF111111),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color(0xFFAA0404)
  ),
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 22.0,
      color: Colors.white,
      fontWeight: FontWeight.normal
    ),
    headline2: TextStyle(
      fontSize: 18.0,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    bodyText1: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.normal,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 0,
    foregroundColor: Colors.black,
  ),
);