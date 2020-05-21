import 'package:flutter/material.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Frequently asked questions',
        color: Colors.blue,
        elevation: 4.0,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Text(
            'Why are my achievement points or mastery level incorrect?',
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            '''
All data in the GW2 Companion app is retrieved from the official Guild Wars 2 api.
Some Achievements and Masteries are currently missing from the Api. So when adding up the points, this number does not match the one from in-game.
            ''',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      )
    );
  }
}