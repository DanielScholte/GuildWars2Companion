part of 'configuration_bloc.dart';

@immutable
abstract class ConfigurationEvent {}

class ChangeThemeEvent extends ConfigurationEvent {
  final ThemeMode theme;

  ChangeThemeEvent({
    this.theme,
  });
}

class ChangeLanguageEvent extends ConfigurationEvent {
  final String language;

  ChangeLanguageEvent({
    this.language,
  });
}

class ChangeTimeNotationEvent extends ConfigurationEvent {
  final bool notation24Hours;

  ChangeTimeNotationEvent({
    this.notation24Hours,
  });
}