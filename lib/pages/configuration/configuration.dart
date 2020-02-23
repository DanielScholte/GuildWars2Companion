import 'package:flutter/material.dart';
import 'package:guildwars2_companion/providers/configuration.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class ConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor,
      body: Column(
        children: <Widget>[
          CompanionHeader(
            color: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            includeBack: true,
            includeShadow: false,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  width: 100.0,
                ),
                Container(height: 16.0,),
                Text(
                  'Guild Wars 2 Companion',
                  style: Theme.of(context).textTheme.display1.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                  )
                ),
                Text(
                  'By Daniël Scholte / Revolt.2860',
                  style: Theme.of(context).textTheme.display3.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                  )
                ),
                _getAppVersion()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text(
              'Thanks to the Guild Wars 2 Wiki and GW2.Ninja for the event timers.',
              style: Theme.of(context).textTheme.display3.copyWith(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text(
              '©2010–2018 ArenaNet, LLC. All rights reserved. Guild Wars, Guild Wars 2, Heart of Thorns, Guild Wars 2: Path of Fire, ArenaNet, NCSOFT, the Interlocking NC Logo, and all associated logos and designs are trademarks or registered trademarks of NCSOFT Corporation. All other trademarks are the property of their respective owners.',
              style: Theme.of(context).textTheme.display3.copyWith(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
              )
            ),
          ),
          Consumer<ConfigurationProvider>(
            builder: (context, state, child) {
              return Switch(
                value: state.themeMode == ThemeMode.dark,
                onChanged: (value) => state.changeTheme(value ? ThemeMode.dark : ThemeMode.light),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _getAppVersion() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (!snapshot.hasData) {
          return Container(
            width: 32.0,
            height: 32.0,
            child: CircularProgressIndicator(),
          );
        }

        return Text(
          'Version ${snapshot.data.version} - Build ${snapshot.data.buildNumber}',
          style: Theme.of(context).textTheme.display3.copyWith(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
          )
        );
      },
    );
  }
}
