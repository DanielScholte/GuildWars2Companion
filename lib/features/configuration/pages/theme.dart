import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/themes/dark.dart';
import 'package:guildwars2_companion/core/themes/light.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';

class ThemeConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.blue,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Theme',
          color: Colors.blue,
        ),
        body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, state) {
            List<_Theme> themes = [
              _Theme('Light', ThemeMode.light),
              _Theme('Dark', ThemeMode.dark),
              _Theme('Use system theme', ThemeMode.system),
            ];

            return ListView(
              children: themes
                .map((theme) => _buildThemeOption(
                  context: context,
                  currentThemeMode: state.configuration.themeMode,
                  themeMode: theme.value,
                  title: theme.name
                ))
                .toList()
            );
          },
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    @required BuildContext context,
    @required ThemeMode currentThemeMode,
    @required ThemeMode themeMode,
    @required String title
  }) {
    return RadioListTile(
      groupValue: currentThemeMode,
      value: themeMode,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      onChanged: (ThemeMode themeMode) {
        if (themeMode == ThemeMode.light || themeMode == ThemeMode.dark) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: themeMode == ThemeMode.dark ? darkTheme.scaffoldBackgroundColor : lightTheme.scaffoldBackgroundColor,
            systemNavigationBarIconBrightness: themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark
          ));
        }

        BlocProvider.of<ConfigurationBloc>(context).add(ChangeThemeEvent(theme: themeMode));
      },
    );
  }
}

class _Theme {
  final String name;
  final ThemeMode value;

  _Theme(this.name, this.value);
}