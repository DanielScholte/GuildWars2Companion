import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/providers/changelog.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:provider/provider.dart';

class ChangelogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Changelog',
        color: Colors.blue,
        elevation: 4.0,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChangelogProvider>(
        builder: (context, state, child) {
          return ListView(
            padding: EdgeInsets.all(8.0),
            children: state.changelog
              .map((c) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Version ${c.version}',
                      style: Theme.of(context).textTheme.display2,
                    ),
                    Column(
                      children: c.changes
                        .map((change) => Row(
                          children: [
                            Container(
                              width: 20.0,
                              child: Icon(
                                FontAwesomeIcons.solidCircle,
                                size: 6.0,
                              ),
                            ),
                            Text(
                              change,
                              style: Theme.of(context).textTheme.display3
                            ),
                          ]
                        ))
                        .toList(),
                    )
                  ],
                ),
              ))
              .toList()
          );
        }
      )
    );
  }
}