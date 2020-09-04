import 'package:flutter/material.dart';

class ThemeUtil {
  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
      primaryColor: Color(0xFFAA0404),
      accentColor: Colors.red,
      cardColor: Colors.white,
      scaffoldBackgroundColor: Color(0xFFEEEEEE),
      cursorColor: Color(0xFFAA0404),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 22.0,
          color: Colors.white,
          fontWeight: FontWeight.normal
        ),
        headline2: TextStyle(
          fontSize: 18.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        bodyText1: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      )
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      primaryColor: Color(0xFFAA0404),
      accentColor: Color(0xFFEEEEEE),
      cardColor: Color(0xFF262626),
      scaffoldBackgroundColor: Color(0xFF111111),
      cursorColor: Color(0xFFAA0404),
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
  }
}