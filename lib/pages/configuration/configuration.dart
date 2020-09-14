import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/pages/configuration/caching.dart';
import 'package:guildwars2_companion/pages/configuration/faq.dart';
import 'package:guildwars2_companion/pages/configuration/language.dart';
import 'package:guildwars2_companion/pages/configuration/notifications.dart';
import 'package:guildwars2_companion/pages/configuration/theme.dart';
import 'package:guildwars2_companion/pages/configuration/time.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:package_info/package_info.dart';

import 'changelog.dart';

class ConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CompanionHeader(
            color: Theme.of(context).scaffoldBackgroundColor,
            enforceColor: true,
            foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            includeBack: true,
            includeShadow: false,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  width: 80.0,
                ),
                Container(height: 4.0,),
                Text(
                  'Guild Wars 2 Companion',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Theme.of(context).textTheme.headline2.color,
                  )
                ),
                Text(
                  'By Daniël Scholte / Revolt.2860',
                  style: Theme.of(context).textTheme.bodyText1
                ),
                _getAppVersion()
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    'Thanks to the Guild Wars 2 Wiki and GW2.Ninja for the event timers.',
                    style: Theme.of(context).textTheme.bodyText1
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    '©2010–2018 ArenaNet, LLC. All rights reserved. Guild Wars, Guild Wars 2, Heart of Thorns, Guild Wars 2: Path of Fire, ArenaNet, NCSOFT, the Interlocking NC Logo, and all associated logos and designs are trademarks or registered trademarks of NCSOFT Corporation. All other trademarks are the property of their respective owners.',
                    style: Theme.of(context).textTheme.bodyText1
                  ),
                ),
                Container(height: 4.0,),
                CompanionButton(
                  title: 'Theme',
                  color: Colors.blue,
                  leading: Icon(
                    FontAwesomeIcons.palette,
                    color: Colors.white,
                  ),
                  height: 64.0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ThemeConfigurationPage()
                  )),
                ),
                CompanionButton(
                  title: 'Scheduled notifications',
                  color: Colors.blue,
                  leading: Icon(
                    FontAwesomeIcons.solidBell,
                    color: Colors.white,
                  ),
                  height: 64.0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationsPage()
                  )),
                ),
                CompanionButton(
                  title: 'Api and Wiki Language',
                  color: Colors.blue,
                  leading: Icon(
                    FontAwesomeIcons.globeEurope,
                    color: Colors.white,
                  ),
                  height: 64.0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LanguageConfigurationPage()
                  )),
                ),
                CompanionButton(
                  title: 'Time notation',
                  color: Colors.blue,
                  leading: Icon(
                    FontAwesomeIcons.clock,
                    color: Colors.white,
                  ),
                  height: 64.0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TimeConfigurationPage()
                  )),
                ),
                CompanionButton(
                  title: 'Caching',
                  color: Colors.blue,
                  leading: Icon(
                    FontAwesomeIcons.hourglassHalf,
                    color: Colors.white,
                  ),
                  height: 64.0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CachingConfigurationPage()
                  )),
                ),
                CompanionButton(
                  title: 'Frequently asked questions',
                  color: Colors.blue,
                  leading: Icon(
                    FontAwesomeIcons.question,
                    color: Colors.white,
                  ),
                  height: 64.0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FaqPage()
                  )),
                ),
                CompanionButton(
                  title: 'Changelog',
                  color: Colors.blue,
                  leading: Icon(
                    FontAwesomeIcons.listOl,
                    color: Colors.white,
                  ),
                  height: 64.0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangelogPage()
                  )),
                ),
                CompanionButton(
                  title: 'View the project on Github',
                  color: Colors.blue,
                  leading: Icon(
                    FontAwesomeIcons.github,
                    color: Colors.white,
                  ),
                  height: 64.0,
                  onTap: () => Urls.launchUrl(Urls.repositoryUrl),
                ),
                Container(height: 8.0,),
                Text(
                  'Enjoying the app?',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Review the app on the ${_getPlatformName()}!',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  child: InkWell(
                    onTap: () => Urls.launchUrl(_getPlatformUrl()),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            _getPlatformIcon()
                          ),
                          Container(width: 8.0,),
                          Text(
                            'Review the app',
                            style: Theme.of(context).textTheme.headline2,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPlatformUrl() {
    return Platform.isIOS ? 'https://apps.apple.com/us/app/gw2-companion/id1498072028' : 'https://play.google.com/store/apps/details?id=com.danielscholte.guildwars2_companion';
  }

  String _getPlatformName() {
    return Platform.isIOS ? 'App Store' : 'Play Store';
  }

  IconData _getPlatformIcon() {
    return Platform.isIOS ? FontAwesomeIcons.appStoreIos : FontAwesomeIcons.googlePlay;
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
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
          )
        );
      },
    );
  }
}
