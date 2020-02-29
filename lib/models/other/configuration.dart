import 'package:flutter/material.dart';

class Configuration {
  ThemeMode themeMode;
  String language;
  bool timeNotation24Hours;

  Configuration({
    this.themeMode,
    this.language,
    this.timeNotation24Hours
  });
}