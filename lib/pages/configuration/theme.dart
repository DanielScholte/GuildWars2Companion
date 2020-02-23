import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guildwars2_companion/providers/configuration.dart';
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
      body: ListView(
        children: [
          _buildThemeOption(context, ThemeMode.light, 'Light'),
          _buildThemeOption(context, ThemeMode.dark, 'Dark'),
        ]
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, ThemeMode themeMode, String title) {
    return RadioListTile(
      groupValue: Theme.of(context).brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
      value: themeMode,
      title: Text(
        title,
        style: Theme.of(context).textTheme.display3,
      ),
      onChanged: (ThemeMode themeMode) {
        Provider.of<ConfigurationProvider>(context, listen: false).changeTheme(themeMode);
      },
    );
  }
}