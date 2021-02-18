import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
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