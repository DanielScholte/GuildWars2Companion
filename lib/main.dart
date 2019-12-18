import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guildwars2_companion/pages/tab.dart';
import 'package:guildwars2_companion/pages/token.dart';
import 'package:guildwars2_companion/utils/token.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GuildWars2Companion(await TokenUtil.tokenPresent()));
}

class GuildWars2Companion extends StatelessWidget {
  final bool isAuthenticated;

  GuildWars2Companion(this.isAuthenticated);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Guild Wars 2 Companion',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Color(0xFFAA0404),
        accentColor: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFEDF0F6),
        cursorColor: Color(0xFFAA0404)
      ),
      home: isAuthenticated ? TabPage() : TokenPage(),
    );
  }

  // B2537E72-F213-E34F-8499-20FE02DA411216C368B9-75F1-41A5-B616-B447A1228A0B
}