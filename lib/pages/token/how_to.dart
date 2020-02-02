import 'package:flutter/material.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/simple_button.dart';

class HowToTokenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'How do I get a token?',
        color: Colors.red,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Text(
            'To use the Guild Wars 2 Companion app, you need to generate a personal token on the Arenanet website:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
          Center(
            child: CompanionSimpleButton(
              text: 'account.arena.net/applications',
              onPressed: () => Urls.launchUrl('https://account.arena.net/applications'),
            ),
          ),
          Text(
            'Instructions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500
            ),
          ),
          Text(
            "After navigating to the above mentioned website, click on the 'New Key' button to generate a new key.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
          Container(height: 16.0,),
          Text(
            "On the next page, enter a name for the key and select which elements you want to app to have access to.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
          Text(
            "We recommend to select all the options to get the optimal experience.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
          Text(
            "Keep in mind, the app can only retrieve the selected information. The app cannot make any changes to your account, and the retrieved information will stay on your phone and won't be shared.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
          Container(height: 16.0,),
          Text(
            "After creating a new api key, copy and paste the key in the app, or scan the qr code.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
        ],
      ),
    );
  }
}