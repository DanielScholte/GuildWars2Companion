import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationProvider extends ChangeNotifier {

  ThemeMode themeMode = ThemeMode.light;
  String language = 'en';

  Future<void> changeTheme(ThemeMode theme) async {
    themeMode = theme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("configuration_theme", theme.index);
    notifyListeners();
    return;
  }

  Future<void> changeLanguage(String lang) async {
    language = lang;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("configuration_lang", lang);
    notifyListeners();
    return;
  }

  Future<void> loadConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeMode = ThemeMode.values[prefs.getInt("configuration_theme") ?? 1];
    language = prefs.getString('configuration_lang') ?? 'en';
  }
}