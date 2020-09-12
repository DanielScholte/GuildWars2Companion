import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/raid/raid_bloc.dart';
import 'package:guildwars2_companion/models/other/raid.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

import 'raid.dart';

class RaidsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.blue,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Raids',
          color: Colors.blue,
        ),
        body: BlocBuilder<RaidBloc, RaidState>(
          builder: (context, state) {
            if (state is ErrorRaidsState) {
              return Center(
                child: CompanionError(
                  title: 'the raids',
                  onTryAgain: () =>
                    BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(state.includeProgress)),
                ),
              );
            }

            if (state is LoadedRaidsState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(state.includeProgress));
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: state.raids
                    .map((d) => _buildRaidRow(context, d))
                    .toList(),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRaidRow(BuildContext context, Raid raid) {
    return CompanionButton(
      color: raid.color,
      title: raid.name,
      height: null,
      hero: raid.id,
      leading: Image.asset(
        'assets/raids/${raid.id}.jpg'
      ),
      subtitleWidgets: raid.checkpoints
        .map((c) => Padding(
          padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Row(
            children: <Widget>[
              if (c.completed)
                Icon(
                  FontAwesomeIcons.check,
                  color: Colors.white,
                  size: 20.0,
                )
              else
                Container(
                  width: 20.0,
                  child: Icon(
                    FontAwesomeIcons.solidCircle,
                    color: Colors.white,
                    size: 6.0,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    c.name,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.white
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ))
        .toList(),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RaidPage(raid),
      )),
    );
  }
}
