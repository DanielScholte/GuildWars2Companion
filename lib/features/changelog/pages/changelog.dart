import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/changelog/bloc/changelog_bloc.dart';
import 'package:guildwars2_companion/features/changelog/models/changelog.dart';

class ChangelogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Changelog',
        color: Colors.blue,
      ),
      body: BlocBuilder<ChangelogBloc, ChangelogState>(
        builder: (context, state) {
          final List<Changelog> changelogs = state.changelogs;

          return CompanionListView(
            children: changelogs
              .map((c) => Padding(
                padding: EdgeInsets.all(8.0),
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
                            Expanded(
                              child: Text(
                                change,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
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