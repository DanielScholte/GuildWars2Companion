import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guildwars2_companion/providers/configuration.dart';
import 'package:guildwars2_companion/utils/theme.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:provider/provider.dart';

class ThemeConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Theme',
        color: Colors.red,
        elevation: 4.0,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ConfigurationProvider>(
        builder: (context, state, child) {
          return ListView(
            children: [
              _buildThemeOption(context, state.themeMode, ThemeMode.light, 'Light'),
              _buildThemeOption(context, state.themeMode, ThemeMode.dark, 'Dark'),
              _buildThemeOption(context, state.themeMode, ThemeMode.system, 'Use system theme'),
            ]
          );
        }
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, ThemeMode currentThemeMode, ThemeMode themeMode, String title) {
    return RadioListTile(
      groupValue: currentThemeMode,
      value: themeMode,
      title: Text(
        title,
        style: Theme.of(context).textTheme.display3,
      ),
      onChanged: (ThemeMode themeMode) {
        if (themeMode == ThemeMode.light || themeMode == ThemeMode.dark) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: themeMode == ThemeMode.dark ? ThemeUtil.getDarkTheme().scaffoldBackgroundColor : ThemeUtil.getLightTheme().scaffoldBackgroundColor,
            systemNavigationBarIconBrightness: themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark
          ));
        }

        Provider.of<ConfigurationProvider>(context, listen: false).changeTheme(themeMode);
      },
    );
  }
}