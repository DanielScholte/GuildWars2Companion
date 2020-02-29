import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationService {

  ThemeMode themeMode = ThemeMode.light;
  String language = 'en';
  bool timeNotation24Hours = true;

  Future<void> changeTheme(ThemeMode theme) async {
    themeMode = theme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("configuration_theme", theme.index);
    return;
  }

  Future<void> changeLanguage(String lang) async {
    language = lang;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("configuration_lang", lang);
    return;
  }

  Future<void> changeTimeNotation(bool notation24Hours) async {
    timeNotation24Hours = notation24Hours;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("configuration_time24", notation24Hours);
    return;
  }

  Future<void> loadConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeMode = ThemeMode.values[prefs.getInt("configuration_theme") ?? 1];
    language = prefs.getString('configuration_lang') ?? 'en';
    timeNotation24Hours = prefs.getBool('configuration_time24') ?? true;
  }
}