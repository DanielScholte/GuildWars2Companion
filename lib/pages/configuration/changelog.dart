import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/changelog/changelog_bloc.dart';
import 'package:guildwars2_companion/models/other/changelog.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

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
      body: BlocBuilder<ChangelogBloc, ChangelogState>(
        builder: (context, state) {
          final List<Changelog> changelogs = (state as LoadedChangelog).changelogs;

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            children: changelogs
              .map((c) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Version ${c.version}',
                      style: Theme.of(context).textTheme.headline2,
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
                              style: Theme.of(context).textTheme.bodyText1
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
        },
      ),
    );
  }
}