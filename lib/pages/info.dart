import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import 'package:package_info/package_info.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        title: '',
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  width: 100.0,
                ),
                Container(height: 16.0,),
                Text(
                  'Guild Wars 2 Companion',
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),
                Text(
                  'By Daniël Scholte / Revolt.2860',
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                ),
                _getAppVersion()
              ],
            ),
            Text(
              '©2010–2018 ArenaNet, LLC. All rights reserved. Guild Wars, Guild Wars 2, Heart of Thorns, Guild Wars 2: Path of Fire, ArenaNet, NCSOFT, the Interlocking NC Logo, and all associated logos and designs are trademarks or registered trademarks of NCSOFT Corporation. All other trademarks are the property of their respective owners.',
              style: TextStyle(
                fontSize: 16.0
              ),
            ),
          ],
        ),
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
          style: TextStyle(
            fontSize: 16.0
          ),
        );
      },
    );
  }
}
