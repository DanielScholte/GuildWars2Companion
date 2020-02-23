import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConfigurationProvider extends ChangeNotifier {

  ThemeMode themeMode = ThemeMode.light;

  void changeTheme(ThemeMode theme) {
    themeMode = theme;
    notifyListeners();
  }
}