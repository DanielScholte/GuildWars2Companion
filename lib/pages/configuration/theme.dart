import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/utils/theme.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

class ThemeConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Theme',
        color: Colors.blue,
      ),
      body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (context, state) {
          final Configuration configuration = (state as LoadedConfiguration).configuration;
          
          return ListView(
            children: <Widget>[
              _buildThemeOption(context, configuration.themeMode, ThemeMode.light, 'Light'),
              _buildThemeOption(context, configuration.themeMode, ThemeMode.dark, 'Dark'),
              _buildThemeOption(context, configuration.themeMode, ThemeMode.system, 'Use system theme'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, ThemeMode currentThemeMode, ThemeMode themeMode, String title) {
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
            systemNavigationBarColor: themeMode == ThemeMode.dark ? ThemeUtil.getDarkTheme().scaffoldBackgroundColor : ThemeUtil.getLightTheme().scaffoldBackgroundColor,
            systemNavigationBarIconBrightness: themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark
          ));
        }

        BlocProvider.of<ConfigurationBloc>(context).add(ChangeThemeEvent(theme: themeMode));
      },
    );
  }
}