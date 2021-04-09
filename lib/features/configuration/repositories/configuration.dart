import 'package:flutter/material.dart';
import 'package:guildwars2_companion/features/configuration/models/configuration.dart';
import 'package:guildwars2_companion/features/configuration/services/configuration.dart';

class ConfigurationRepository {
  final ConfigurationService configurationService;

  ConfigurationRepository({
    @required this.configurationService
  });

  Future<void> changeTheme(ThemeMode theme) => this.configurationService.changeTheme(theme);

  Future<void> changeLanguage(String lang) => this.configurationService.changeLanguage(lang);

  Future<void> changeTimeNotation(bool notation24Hours) => this.configurationService.changeTimeNotation(notation24Hours);

  Configuration getConfiguration() {
    return Configuration(
      language: configurationService.language,
      themeMode: configurationService.themeMode,
      timeNotation24Hours: configurationService.timeNotation24Hours,
    );
  }
}